import app/error
import app/models/user.{create_user, signin_user}
import app/pages
import app/pages/layout.{layout}
import app/web.{type Context, Context}
import gleam/list
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
    create_user(user_email, user_password, ctx.db)
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
    signin_user(user_email, user_password, ctx.db)
  }
  case result {
    Ok(_) -> {
      wisp.redirect("/")
    }
    Error(_) -> {
      [pages.signin("The email or password you entered is incorrect")]
      |> layout
      |> element.to_document_string_builder
      |> wisp.html_response(200)
    }
  }
}
