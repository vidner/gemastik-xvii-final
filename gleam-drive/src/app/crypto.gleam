import gleam/bit_array
import gleam/result
import gleam/string

const block_size = 16

@external(erlang, "crypto_ffi", "encrypt")
pub fn encrypt_ffi(key: BitArray, data: BitArray) -> BitArray

@external(erlang, "crypto_ffi", "decrypt")
pub fn decrypt_ffi(key: BitArray, data: BitArray) -> BitArray

@external(erlang, "crypto_ffi", "hash")
pub fn hash(data: String) -> String

pub fn encrypt(key: String, data: String) -> String {
  let key = bit_array.from_string(key)
  let data = bit_array.from_string(pad(data))
  let ciphertext = encrypt_ffi(key, data)
  bit_array.base16_encode(ciphertext)
}

pub fn decrypt(key: String, data: String) -> String {
  let key = bit_array.from_string(key)
  let data = bit_array.base16_decode(data)
  case data {
    Ok(data) -> {
      let plaintext = decrypt_ffi(key, data)
      unpad(result.unwrap(bit_array.to_string(plaintext), ""))
    }
    Error(_) -> ""
  }
}

pub fn pad(data: String) -> String {
  let remainder = string.byte_size(data) % block_size
  let padding = string.repeat(" ", block_size - remainder)
  string.append(data, padding)
}

pub fn unpad(data: String) -> String {
  string.trim_right(data)
}

pub fn encode(data: String) -> String {
  bit_array.base16_encode(bit_array.from_string(data))
}

pub fn decode(data: String) -> String {
  case bit_array.base16_decode(data) {
    Ok(data) -> result.unwrap(bit_array.to_string(data), "")
    Error(_) -> ""
  }
}
