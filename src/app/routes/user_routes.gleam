import app/error
import app/helpers/uuid
import app/models/board.{create_board}
import app/models/board_user.{create_board_user}
import app/models/user.{create_user, signin_user}
import app/pages
import app/pages/layout.{layout}
import app/web.{type Context, Context, uid_cookie}
import gleam/http.{Http}
import gleam/http/cookie
import gleam/http/response
import gleam/list
import gleam/option
import gleam/result
import lustre/element
import wisp.{type Request}

pub fn post_create_user(req: Request, ctx: Context) {
  use form <- wisp.require_form(req)

  let result = {
    use user_email <- result.try(
      list.key_find(form.values, "email")
      |> result.map_error(fn(_) { error.BadRequest }),
    )

    use user_password <- result.try(
      list.key_find(form.values, "password")
      |> result.map_error(fn(_) { error.BadRequest }),
    )

    use user_id <- result.try(
      create_user(user_email, user_password, ctx.db)
      |> result.map(fn(user_id) {
        uuid.cast(user_id) |> result.map_error(fn(_) { error.BadRequest })
      })
      |> result.flatten,
    )

    use board_id <- result.try(
      create_board(user_id, ctx.db)
      |> result.map(fn(board_id) {
        uuid.cast(board_id) |> result.map_error(fn(_) { error.BadRequest })
      })
      |> result.flatten,
    )

    create_board_user(board_id, user_id, ctx.db)
  }
  case result {
    Ok(_) -> {
      [pages.signup_success()]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
    Error(_) -> {
      [pages.signup("The email you entered is incorrect")]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
  }
}

pub fn post_signin_user(req: Request, ctx: Context) {
  use form <- wisp.require_form(req)

  let result = {
    use user_email <- result.try(
      list.key_find(form.values, "email")
      |> result.map_error(fn(_) { error.BadRequest }),
    )

    use user_password <- result.try(
      list.key_find(form.values, "password")
      |> result.map_error(fn(_) { error.BadRequest }),
    )
    use user <- result.try(
      signin_user(user_email, user_password, ctx.db)
      |> result.map_error(fn(_) { error.BadRequest }),
    )
    uuid.cast(user.id) |> result.map_error(fn(_) { error.BadRequest })
  }
  case result {
    Ok(user_id) -> {
      wisp.redirect("/")
      |> wisp.set_cookie(req, uid_cookie, user_id, wisp.Signed, 60 * 60)
    }
    Error(_) -> {
      [pages.signin("The email or password you entered is incorrect")]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
  }
}

pub fn post_sign_out() {
  let attributes =
    cookie.Attributes(..cookie.defaults(Http), max_age: option.Some(0))
  wisp.redirect("/")
  |> response.set_cookie(uid_cookie, "", attributes)
}
