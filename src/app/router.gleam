import app/models/item
import app/pages
import app/pages/layout.{layout}
import app/routes/item_routes
import app/routes/user_routes
import app/web.{type Context}
import gleam/http
import lustre/element
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req, ctx)

  case wisp.path_segments(req) {
    [] -> {
      use ctx <- web.authenticate(req, ctx)
      home(ctx)
    }
    ["signup"] -> signup(req, ctx)
    ["signin"] -> signin(req, ctx)
    ["signout"] -> {
      use <- wisp.require_method(req, http.Post)
      user_routes.post_sign_out()
    }
    ["items", "create"] -> {
      use ctx <- web.authenticate(req, ctx)
      use <- wisp.require_method(req, http.Post)
      item_routes.post_create_item(req, ctx)
    }
    ["items", id] -> {
      use ctx <- web.authenticate(req, ctx)
      use <- wisp.require_method(req, http.Delete)
      item_routes.post_delete_item(ctx, id)
    }
    ["items", id, "todo"] -> {
      use ctx <- web.authenticate(req, ctx)
      use <- wisp.require_method(req, http.Patch)
      item_routes.patch_todo(ctx, id)
    }
    ["items", id, "doing"] -> {
      use ctx <- web.authenticate(req, ctx)
      use <- wisp.require_method(req, http.Patch)
      item_routes.patch_doing(ctx, id)
    }
    ["items", id, "done"] -> {
      use ctx <- web.authenticate(req, ctx)
      use <- wisp.require_method(req, http.Patch)
      item_routes.patch_done(ctx, id)
    }

    // All the empty responses
    ["internal-server-error"] -> wisp.internal_server_error()
    ["unprocessable-entity"] -> wisp.unprocessable_entity()
    ["method-not-allowed"] -> wisp.method_not_allowed([])
    ["entity-too-large"] -> wisp.entity_too_large()
    ["bad-request"] -> wisp.bad_request()
    _ -> wisp.not_found()
  }
}

fn home(ctx: Context) -> Response {
  let items = item.list_items(ctx.db)
  [pages.home(items)]
  |> layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

fn signup(req: Request, ctx: Context) -> Response {
  case req.method {
    http.Get -> get_signup_form()
    http.Post -> user_routes.post_create_user(req, ctx)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn get_signup_form() -> Response {
  [pages.signup("")]
  |> layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}

fn signin(req: Request, ctx: Context) -> Response {
  case req.method {
    http.Get -> get_signin_form()
    http.Post -> user_routes.post_signin_user(req, ctx)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn get_signin_form() -> Response {
  [pages.signin("")]
  |> layout
  |> element.to_document_string_builder
  |> wisp.html_response(200)
}
