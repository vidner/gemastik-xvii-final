import app/crypto
import app/model
import gleam/dynamic
import gleam/int
import gleam/list
import sqlight

pub fn init(db: sqlight.Connection) {
  let assert Ok(Nil) =
    sqlight.exec(
      "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, email TEXT, password TEXT)",
      db,
    )

  let assert Ok(Nil) =
    sqlight.exec(
      "CREATE TABLE IF NOT EXISTS uploads (id INTEGER PRIMARY KEY, email TEXT, filename TEXT, filesize INTEGER, timestamp TEXT)",
      db,
    )

  let assert Ok(Nil) =
    sqlight.exec(
      "CREATE INDEX IF NOT EXISTS uploads_owner_index ON uploads (email)",
      db,
    )
}

pub fn login(db: sqlight.Connection, email: String, password: String) -> Bool {
  let sql = "SELECT * FROM users WHERE email = ? AND password = ?"
  let user_decoder = dynamic.tuple3(dynamic.int, dynamic.string, dynamic.string)
  let assert Ok(users) =
    sqlight.query(
      sql,
      on: db,
      with: [
        sqlight.text(crypto.encode(email)),
        sqlight.text(crypto.hash(password)),
      ],
      expecting: user_decoder,
    )
  list.length(users) > 0
}

pub fn create_user(
  db: sqlight.Connection,
  email: String,
  password: String,
) -> Result(String, String) {
  let sql =
    "INSERT INTO users (email, password) VALUES ('"
    <> crypto.encode(email)
    <> "', '"
    <> crypto.hash(password)
    <> "')"

  case sqlight.exec(sql, db) {
    Ok(_) -> Ok("User created")
    Error(_) -> Error("Failed to create user")
  }
}

pub fn user_exists(db: sqlight.Connection, email: String) -> Bool {
  let sql = "SELECT * FROM users WHERE email = ?"
  let user_decoder = dynamic.tuple3(dynamic.int, dynamic.string, dynamic.string)
  let assert Ok(users) =
    sqlight.query(
      sql,
      on: db,
      with: [sqlight.text(crypto.encode(email))],
      expecting: user_decoder,
    )
  list.length(users) > 0
}

pub fn create_upload(
  db: sqlight.Connection,
  email: String,
  filename: String,
  filesize: Int,
) {
  let sql =
    "INSERT INTO uploads (email, filename, filesize, timestamp) VALUES ('"
    <> crypto.encode(email)
    <> "', '"
    <> crypto.encode(filename)
    <> "', "
    <> int.to_string(filesize)
    <> ", datetime('now'))"
  let assert Ok(Nil) = sqlight.exec(sql, db)
}

pub fn list_uploads(db: sqlight.Connection, email: String) -> List(model.Upload) {
  let sql = "SELECT * FROM uploads WHERE email = ?"
  let upload_decoder =
    dynamic.tuple5(
      dynamic.int,
      dynamic.string,
      dynamic.string,
      dynamic.int,
      dynamic.string,
    )
  let assert Ok(uploads) =
    sqlight.query(
      sql,
      on: db,
      with: [sqlight.text(crypto.encode(email))],
      expecting: upload_decoder,
    )
  list.map(uploads, fn(upload) {
    model.Upload(
      crypto.decode(upload.1),
      crypto.decode(upload.2),
      upload.3,
      upload.4,
    )
  })
}

pub fn find_file(
  db: sqlight.Connection,
  email: String,
  filename: String,
) -> Result(model.Upload, String) {
  let sql = "SELECT * FROM uploads WHERE email = ? AND filename = ?"
  let upload_decoder =
    dynamic.tuple5(
      dynamic.int,
      dynamic.string,
      dynamic.string,
      dynamic.int,
      dynamic.string,
    )
  let assert Ok(uploads) =
    sqlight.query(
      sql,
      on: db,
      with: [
        sqlight.text(crypto.encode(email)),
        sqlight.text(crypto.encode(filename)),
      ],
      expecting: upload_decoder,
    )
  case list.first(uploads) {
    Ok(upload) ->
      Ok(model.Upload(
        crypto.decode(upload.1),
        crypto.decode(upload.2),
        upload.3,
        upload.4,
      ))
    Error(_) -> Error("File not found")
  }
}
