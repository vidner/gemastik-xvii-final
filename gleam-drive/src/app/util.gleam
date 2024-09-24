import app/config
import gleam/http
import gleam/int
import gleam/option
import gleam/result
import simplifile
import wisp

pub fn path_exists(path: String) -> Bool {
  result.unwrap(simplifile.is_directory(path), True)
  || result.unwrap(simplifile.is_file(path), True)
  || result.unwrap(simplifile.is_symlink(path), True)
}

pub fn upload_file(src: String, dest: String) -> Result(String, String) {
  case !path_exists(dest) && config.max_file_size > get_file_size(src) {
    True -> {
      result.unwrap(simplifile.copy_file(src, dest), Nil)
      Ok("File uploaded")
    }
    False -> Error("Failed to upload file")
  }
}

pub fn get_file_size(path: String) -> Int {
  case simplifile.file_info(path) {
    Ok(info) -> info.size
    Error(_) -> 0
  }
}

pub fn get_base_url(req: wisp.Request) -> String {
  let scheme = http.scheme_to_string(req.scheme)
  let host = req.host
  let port = int.to_string(option.unwrap(req.port, 80))
  scheme <> "://" <> host <> ":" <> port
}
