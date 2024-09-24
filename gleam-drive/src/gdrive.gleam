import app/repository
import app/router
import app/web
import gleam/erlang/process
import mist
import sqlight
import wisp

pub fn main() {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  use db <- sqlight.with_connection("gdrive.db")
  let assert Ok(Nil) = repository.init(db)
  let context = web.Context(db: db)
  let handler = router.handle_request(_, context)
  let assert Ok(_) =
    wisp.mist_handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_https("cert.pem", "key.pem")

  process.sleep_forever()
}
