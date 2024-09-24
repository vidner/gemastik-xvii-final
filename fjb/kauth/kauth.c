#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
#include <sodium.h>
#include <string.h>
#include <time.h>

#include "kauth.h"

#define kauth_token_claim_BYTES                                                \
  (sodium_base64_ENCODED_LEN(sizeof(struct kauth_user),                        \
                             sodium_base64_VARIANT_URLSAFE_NO_PADDING))

#define kauth_token_sign_BYTES                                                 \
  (sodium_base64_ENCODED_LEN(crypto_auth_hmacsha256_BYTES,                     \
                             sodium_base64_VARIANT_URLSAFE_NO_PADDING))

#define kauth_token_BYTES (kauth_token_claim_BYTES + kauth_token_sign_BYTES) - 1

static int encode(lua_State *L) {
  int typ;
  struct kauth_user claim;
  unsigned char h[crypto_auth_hmacsha256_BYTES];
  unsigned char token[kauth_token_BYTES];

  memset(h, 0, crypto_auth_hmacsha256_BYTES);
  memset(token, 0, kauth_token_BYTES);
  memset(&claim, 0, sizeof(struct kauth_user));

  size_t keylen = 0;
  const char *key = luaL_checklstring(L, 1, &keylen);
  if (keylen != crypto_auth_hmacsha256_KEYBYTES) {
    lua_pushstring(L, "invalid key len");
    return lua_error(L);
  }

  luaL_checktype(L, 2, LUA_TTABLE);

  if ((typ = lua_getfield(L, 2, "id")) != LUA_TNUMBER) {
    lua_pop(L, 1);
    lua_pushstring(L, "invalid type id (number expected)");
    return lua_error(L);
  }
  lua_Integer id = lua_tointeger(L, -1);
  lua_pop(L, 1);
  claim.id = id;

  if ((typ = lua_getfield(L, 2, "name")) != LUA_TSTRING) {
    lua_pop(L, 1);
    lua_pushstring(L, "invalid type name (string expected)");
    return lua_error(L);
  }
  const char *name = lua_tostring(L, -1);
  lua_pop(L, 1);
  strcpy((char *)claim.name, name);

  claim.exp = time(0) + 1800; // 30 min

  crypto_auth_hmacsha256(h, (const unsigned char *)&claim,
                         sizeof(struct kauth_user), (const unsigned char *)key);

  sodium_bin2base64((char *)token, kauth_token_claim_BYTES,
                    (const unsigned char *)&claim, sizeof(struct kauth_user),
                    sodium_base64_VARIANT_URLSAFE_NO_PADDING);

  sodium_bin2base64((char *)(token + kauth_token_claim_BYTES),
                    kauth_token_sign_BYTES, h, crypto_auth_hmacsha256_BYTES,
                    sodium_base64_VARIANT_URLSAFE_NO_PADDING);

  token[kauth_token_claim_BYTES - 1] = '.';

  lua_pushlstring(L, (char *)token, kauth_token_BYTES);

  return 1;
}

static int decode(lua_State *L) {
  struct kauth_user claim;
  const char name[129];
  const unsigned char h[crypto_auth_hmacsha256_BYTES];

  memset(&claim, 0, sizeof(struct kauth_user));
  memset((void *)name, 0, sizeof(name));
  memset((void *)h, 0, sizeof(h));

  size_t keylen = 0;
  const char *key = luaL_checklstring(L, 1, &keylen);
  if (keylen != crypto_auth_hmacsha256_BYTES) {
    lua_pushstring(L, "invalid key len");
    return lua_error(L);
  }

  size_t tokenlen = 0;
  const char *token = luaL_checklstring(L, 2, &tokenlen);
  if (tokenlen != kauth_token_BYTES) {
    lua_pushstring(L, "invalid token len");
    return lua_error(L);
  }

  if (token[kauth_token_claim_BYTES - 1] != '.') {
    lua_pushstring(L, "invalid token");
    return lua_error(L);
  }

  size_t clen = 0;
  const char *b64_end = NULL;
  if (sodium_base642bin((unsigned char *)&claim, sizeof(struct kauth_user),
                        token, kauth_token_claim_BYTES, NULL, &clen, &b64_end,
                        sodium_base64_VARIANT_URLSAFE_NO_PADDING) != 0) {

    lua_pushstring(L, "invalid token: failed to decode claim");
    return lua_error(L);
  }
  strncpy((char *)name, claim.name, sizeof(name));

  clen = 0;
  b64_end = NULL;
  if (sodium_base642bin((unsigned char *)h, crypto_auth_hmacsha256_BYTES,
                        token + kauth_token_claim_BYTES, kauth_token_sign_BYTES,
                        NULL, &clen, &b64_end,
                        sodium_base64_VARIANT_URLSAFE_NO_PADDING) != 0) {
    lua_pushstring(L, "invalid token: failed to decode hash");
    return lua_error(L);
  }

  if (crypto_auth_hmacsha256_verify(h, (const unsigned char *)&claim,
                                    sizeof(struct kauth_user),
                                    (const unsigned char *)key) != 0) {
    lua_pushstring(L, "invalid token: failed to verify");
    return lua_error(L);
  }

  if (claim.exp <= time(0)) {
    lua_pushstring(L, "invalid token: expired");
    return lua_error(L);
  }

  lua_newtable(L);

  lua_pushstring(L, name);
  lua_setfield(L, -2, "name");

  lua_pushinteger(L, claim.id);
  lua_setfield(L, -2, "id");
  return 1;
}

static const struct luaL_Reg luakauth_lib[] = {
    {"encode", encode},
    {"decode", decode},

    {NULL, NULL},
};

LUALIB_API int luaopen_kauth(lua_State *L) {
  if (sodium_init() == -1) {
    lua_pushstring(L, "crypto init failed");
    return lua_error(L);
  }

  luaL_newlib(L, luakauth_lib);

  return 1;
}