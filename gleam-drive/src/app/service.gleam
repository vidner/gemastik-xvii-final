import app/config
import app/crypto
import app/model
import app/repository
import app/util
import birl
import birl/duration
import filepath
import gleam/result
import simplifile
import sqlight
import wisp

pub fn login(db: sqlight.Connection, user: model.User) -> Result(String, String) {
  case repository.login(db, user.email, user.password) {
    True -> Ok(generate_session_token(user.email))
    False -> Error("Invalid credentials")
  }
}

pub fn register(
  db: sqlight.Connection,
  user: model.User,
) -> Result(String, String) {
  let user_dir = filepath.join(config.upload_dir, user.email)
  case repository.user_exists(db, user.email) || util.path_exists(user_dir) {
    True -> Error("User already exists")
    False -> {
      result.unwrap(simplifile.create_directory_all(user_dir), Nil)
      repository.create_user(db, user.email, user.password)
    }
  }
}

pub fn list_uploads(
  db: sqlight.Connection,
  session: model.Session,
) -> List(model.Upload) {
  repository.list_uploads(db, session.email)
}

pub fn find_upload(
  db: sqlight.Connection,
  session: model.Session,
  filename: String,
) -> Result(model.Upload, String) {
  repository.find_file(db, session.email, filename)
}

pub fn upload(
  db: sqlight.Connection,
  file: wisp.UploadedFile,
  session: model.Session,
) -> Result(String, String) {
  let user_dir = filepath.join(config.upload_dir, session.email)
  let filepath = filepath.join(user_dir, file.file_name)
  let filesize = util.get_file_size(file.path)
  case repository.create_upload(db, session.email, file.file_name, filesize) {
    Ok(_) -> util.upload_file(file.path, filepath)
    Error(_) -> Error("Failed to upload file")
  }
}

pub fn share(
  db: sqlight.Connection,
  recepient: String,
  filename: String,
  session: model.Session,
) -> Result(String, String) {
  let drive = repository.find_file(db, session.email, filename)
  let user_dir = filepath.join(config.upload_dir, session.email)
  let shared_file = filepath.join(user_dir, filename)
  case drive {
    Ok(_) -> Ok(generate_shared_token(model.Shared(shared_file, recepient)))
    Error(_) -> Error("File not found")
  }
}

pub fn extract_session_token(token: String) -> model.Session {
  let key = config.aes_key()
  case model.session_from_json(crypto.decrypt(key, token)) {
    Ok(session) -> session
    Error(_) -> model.Session("", 0)
  }
}

pub fn extract_shared_token(token: String) -> Result(model.Shared, String) {
  let key = config.aes_key()
  case model.shared_from_json(crypto.decrypt(key, token)) {
    Ok(shared) -> Ok(shared)
    Error(_) -> Error("Invalid token")
  }
}

pub fn generate_shared_token(data: model.Shared) -> String {
  let key = config.aes_key()
  crypto.encrypt(key, model.shared_to_json(data))
}

fn generate_session_token(email: String) -> String {
  let key = config.aes_key()
  crypto.encrypt(
    key,
    model.session_to_json(model.Session(
      email,
      birl.to_unix(birl.add(birl.now(), duration.minutes(30))),
    )),
  )
}
