import app/error
import app/models/item.{type Item, create_item}
import app/web.{type Context, Context}
import gleam/dynamic
import gleam/json
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import wisp.{type Request, type Response}

pub fn post_create_item(req: Request, ctx: Context) {
  use form <- wisp.require_form(req)

  let result = {
    use item_content <- result.try(
      list.key_find(form.values, "todo_input")
      |> result.map_error(fn(_) { error.BadRequest }),
    )
    create_item(item_content, ctx.db)
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

// fn todos_to_json(items: List(Item)) -> String {
//   "["
//   <> items
//   |> list.map(item_to_json)
//   |> string.join(",")
//   <> "]"
// }

// fn item_to_json(item: Item) -> String {
//   json.object([
//     #("id", json.string(item.id)),
//     #("content", json.string(item.content)),
//     #("status", json.string(item.item_status_to_string(item.status))),
//   ])
//   |> json.to_string
// }
