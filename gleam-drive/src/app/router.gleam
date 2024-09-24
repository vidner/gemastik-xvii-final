import app/config
import app/model
import app/service
import app/util
import app/view
import app/web
import birl
import filepath
import gleam/http.{Get, Post}
import gleam/io
import gleam/list
import gleam/result
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use req <- web.middleware(req)
  let session_cookie = case wisp.get_cookie(req, "session", wisp.PlainText) {
    Ok(cookie) -> cookie
    Error(_) -> ""
  }

  let session = service.extract_session_token(session_cookie)
  case session.expired_at > birl.to_unix(birl.now()) {
    True -> handle_protected_routes(req, ctx, session)
    False -> handle_routes(req, ctx)
  }
}

pub fn handle_routes(req: Request, ctx: web.Context) -> Response {
  case wisp.path_segments(req) {
    [] -> show_home(req)
    ["login"] ->
      case req.method {
        Post -> handle_login(req, ctx)
        _ -> show_login()
      }
    ["register"] ->
      case req.method {
        Post -> handle_register(req, ctx)
        _ -> show_register()
      }
    ["error"] -> show_error(req)
    _ -> wisp.redirect("/login")
  }
}

pub fn handle_protected_routes(
  req: Request,
  ctx: web.Context,
  session: model.Session,
) -> Response {
  case wisp.path_segments(req) {
    ["drive"] ->
      case req.method {
        Post -> handle_upload(req, ctx, session)
        _ -> show_drive(ctx, session)
      }
    ["share"] -> handle_share(req, ctx, session)
    ["details"] -> handle_details(req, ctx, session)
    ["download"] -> handle_download(req, session)
    ["logout"] -> destroy_session(req)
    ["error"] -> show_error(req)
    _ -> wisp.redirect("/drive")
  }
}

fn destroy_session(req: Request) -> Response {
  let resp = wisp.redirect("/login")
  wisp.set_cookie(resp, req, "session", "", wisp.PlainText, 0)
}

fn create_session(req: Request, token: String) -> Response {
  let resp = wisp.redirect("/drive")
  wisp.set_cookie(resp, req, "session", token, wisp.PlainText, 30 * 60)
}

fn error_response(message: String) -> Response {
  wisp.redirect("/error?message=" <> message)
}

fn show_share(download_link: String) -> Response {
  view.render_share_html(download_link)
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn send_file(shared: model.Shared, session: model.Session) -> Response {
  case shared.recepient == session.email {
    True -> {
      wisp.ok()
      |> wisp.set_header("content-type", "application/octet-stream")
      |> wisp.file_download(
        named: filepath.base_name(shared.filepath),
        from: shared.filepath,
      )
    }
    False -> error_response("Invalid token")
  }
}

fn show_details(upload: model.Upload, token: String) -> Response {
  view.render_detail_html(upload, token)
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn handle_details(
  req: Request,
  ctx: web.Context,
  session: model.Session,
) -> Response {
  let query = wisp.get_query(req)
  let filename = case list.key_find(query, "filename") {
    Ok(value) -> value
    Error(_) -> ""
  }

  case service.find_upload(ctx.db, session, filename) {
    Ok(upload) -> {
      let filepath =
        filepath.join(filepath.join(config.upload_dir, session.email), filename)
      let token =
        service.generate_shared_token(model.Shared(filepath, upload.email))
      show_details(upload, token)
    }
    Error(message) -> error_response(message)
  }
}

fn handle_download(req: Request, session: model.Session) -> Response {
  let query = wisp.get_query(req)
  case list.key_find(query, "token") {
    Ok(token) -> {
      case service.extract_shared_token(token) {
        Ok(shared) -> send_file(shared, session)
        Error(message) -> error_response(message)
      }
    }
    Error(_) -> error_response("Invalid token")
  }
}

fn handle_share(
  req: Request,
  ctx: web.Context,
  session: model.Session,
) -> Response {
  use forms <- wisp.require_form(req)
  let query = wisp.get_query(req)

  let payload = {
    use recepient <- result.try(list.key_find(forms.values, "recepient"))
    use filename <- result.try(list.key_find(query, "filename"))
    Ok(#(recepient, filename))
  }

  case payload {
    Ok(payload) -> {
      case service.share(ctx.db, payload.0, payload.1, session) {
        Ok(token) ->
          show_share(util.get_base_url(req) <> "/download?token=" <> token)
        Error(message) -> error_response(message)
      }
    }
    Error(_) -> wisp.bad_request()
  }
}

fn show_error(req: Request) -> Response {
  let query = wisp.get_query(req)
  let message = case list.key_find(query, "message") {
    Ok(value) -> value
    Error(_) -> "Unknown error"
  }
  view.render_error_html(message)
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn show_home(req: Request) -> Response {
  use <- wisp.require_method(req, Get)
  view.index_html
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn show_login() -> Response {
  view.login_html
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn handle_login(req: Request, ctx: web.Context) -> Response {
  use form <- wisp.require_form(req)
  let payload = {
    use email <- result.try(list.key_find(form.values, "email"))
    use password <- result.try(list.key_find(form.values, "password"))
    Ok(model.User(email, password))
  }
  case payload {
    Ok(user) -> {
      case service.login(ctx.db, user) {
        Ok(token) -> create_session(req, token)
        Error(message) -> error_response(message)
      }
    }
    Error(_) -> wisp.bad_request()
  }
}

fn show_register() -> Response {
  view.register_html
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn handle_register(req: Request, ctx: web.Context) -> Response {
  use form <- wisp.require_form(req)
  let payload = {
    use email <- result.try(list.key_find(form.values, "email"))
    use password <- result.try(list.key_find(form.values, "password"))
    Ok(model.User(email, password))
  }
  case payload {
    Ok(user) -> {
      case service.register(ctx.db, user) {
        Ok(_) -> wisp.redirect("/login")
        Error(message) -> error_response(message)
      }
    }
    Error(_) -> wisp.bad_request()
  }
}

fn show_drive(ctx: web.Context, session: model.Session) -> Response {
  let drives = service.list_uploads(ctx.db, session)

  view.render_drives_html(drives)
  |> string_builder.from_string
  |> wisp.html_response(200)
}

fn handle_upload(
  req: Request,
  ctx: web.Context,
  session: model.Session,
) -> Response {
  use form <- wisp.require_form(req)
  let payload = {
    use file <- result.try(list.key_find(form.files, "uploaded-file"))
    Ok(file)
  }

  case payload {
    Ok(file) -> {
      case service.upload(ctx.db, file, session) {
        Ok(_) -> wisp.redirect("/drive")
        Error(message) -> error_response(message)
      }
    }
    Error(_) -> {
      io.debug("Failed to upload file")
      wisp.bad_request()
    }
  }
}
