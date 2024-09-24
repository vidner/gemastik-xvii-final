import gleam/dynamic
import gleam/json.{int, object, string}

pub type User {
  User(email: String, password: String)
}

pub type Session {
  Session(email: String, expired_at: Int)
}

pub type Upload {
  Upload(email: String, filename: String, filesize: Int, timestamp: String)
}

pub type Shared {
  Shared(filepath: String, recepient: String)
}

pub fn session_to_json(session: Session) -> String {
  object([
    #("email", string(session.email)),
    #("expired_at", int(session.expired_at)),
  ])
  |> json.to_string
}

pub fn session_from_json(data: String) -> Result(Session, json.DecodeError) {
  let session_decoder =
    dynamic.decode2(
      Session,
      dynamic.field("email", of: dynamic.string),
      dynamic.field("expired_at", of: dynamic.int),
    )
  json.decode(from: data, using: session_decoder)
}

pub fn shared_to_json(shared: Shared) -> String {
  object([
    #("filepath", string(shared.filepath)),
    #("recepient", string(shared.recepient)),
  ])
  |> json.to_string
}

pub fn shared_from_json(data: String) -> Result(Shared, json.DecodeError) {
  let shared_decoder =
    dynamic.decode2(
      Shared,
      dynamic.field("filepath", of: dynamic.string),
      dynamic.field("recepient", of: dynamic.string),
    )
  json.decode(from: data, using: shared_decoder)
}
