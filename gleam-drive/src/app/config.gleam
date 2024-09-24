import gleam/result
import simplifile

pub const upload_dir = "/tmp/gleam-drive/"

pub const max_file_size = 524_288

pub fn aes_key() -> String {
  result.unwrap(simplifile.read(".aes-key"), "change-me-please")
}
