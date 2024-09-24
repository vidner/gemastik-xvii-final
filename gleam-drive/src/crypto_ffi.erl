-module(crypto_ffi).
-export([encrypt/2, decrypt/2, hash/1]).

encrypt(Key, Data) ->
    crypto:crypto_one_time(aes_128_ecb, Key, Data, true).

decrypt(Key, Data) ->
    crypto:crypto_one_time(aes_128_ecb, Key, Data, false).

hash(Data) ->
    binary:encode_hex(crypto:hash(sha256, Data), uppercase).
