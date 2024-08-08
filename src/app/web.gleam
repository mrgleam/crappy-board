import gleam/bool
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/option
import gleam/pgo.{type Connection}
import gleam/result
import gleam/string_builder
import wisp.{type Request, type Response}

pub type Context {
  Context(
    static_directory: String,
    db: Connection,
    user_id: String,
    board_ids: List(String),
  )
}

pub const uid_cookie = "uid"

pub const bids_cookie = "bids"

pub fn authenticate(
  req: Request,
  ctx: Context,
  next: fn(Context) -> Response,
) -> Response {
  let id = wisp.get_cookie(req, uid_cookie, wisp.Signed) |> option.from_result

  case id {
    option.None -> wisp.redirect("/signin")
    option.Some(id) -> {
      let context = Context(..ctx, user_id: id)
      next(context)
    }
  }
}

pub fn authorized(
  req: Request,
  ctx: Context,
  next: fn(Context) -> Response,
) -> Response {
  let ids = wisp.get_cookie(req, bids_cookie, wisp.Signed) |> option.from_result

  case ids {
    option.None -> wisp.redirect("/signin")
    option.Some(ids) -> {
      let board_ids =
        json.decode(ids, dynamic.list(of: dynamic.string))
        |> fn(ids) { result.unwrap(ids, []) }
      let context = Context(..ctx, board_ids: board_ids)
      next(context)
    }
  }
}

pub fn guard(ctx: Context, board_id: String, next: fn() -> Response) -> Response {
  use <- bool.guard(!list.contains(ctx.board_ids, board_id), wisp.response(403))

  next()
}

pub fn middleware(
  req: Request,
  ctx: Context,
  handle_request: fn(Request) -> Response,
) -> Response {
  let req = wisp.method_override(req)
  use <- wisp.serve_static(req, under: "/static", from: ctx.static_directory)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  use <- default_response

  handle_request(req)
}

pub fn default_response(handle_request: fn() -> Response) -> Response {
  let response = handle_request()

  use <- bool.guard(when: response.body != wisp.Empty, return: response)

  case response.status {
    404 | 405 ->
      "<h1>Not Found</h1>"
      |> string_builder.from_string
      |> wisp.html_body(response, _)

    400 | 422 ->
      "<h1>Bad request</h1>"
      |> string_builder.from_string
      |> wisp.html_body(response, _)

    413 ->
      "<h1>Request entity too large</h1>"
      |> string_builder.from_string
      |> wisp.html_body(response, _)

    500 ->
      "<h1>Internal server error</h1>"
      |> string_builder.from_string
      |> wisp.html_body(response, _)

    _ -> response
  }
}
