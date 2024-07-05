import app/error
import app/models/user.{create_user}
import app/web.{type Context, Context}
import gleam/list
import gleam/result
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
      wisp.redirect("/")
    }
    Error(_) -> {
      wisp.bad_request()
    }
  }
}
