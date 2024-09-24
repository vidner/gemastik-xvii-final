import app/config
import sqlight
import wisp

pub type Context {
  Context(db: sqlight.Connection)
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  handle_request(req |> wisp.set_max_files_size(config.max_file_size))
}
