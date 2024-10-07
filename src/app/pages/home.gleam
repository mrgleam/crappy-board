import app/components/nav
import app/helpers/uuid
import app/models/item.{
  type Item, item_status_to_string, next_status, prev_status,
  string_to_item_status,
}
import gleam/function.{curry2}
import gleam/list
import gleam/result
import gleam/string.{lowercase}
import lustre/attribute.{attribute, autofocus, class, name, placeholder, rows}
import lustre/element.{type Element}
import lustre/element/html.{button, form, svg, textarea}
import lustre/element/svg

pub fn root(board_id: String, items: List(Item)) -> Element(t) {
  html.div([attribute.class("flex flex-col nav-bar-padding-space")], [
    html.div([], [nav.nav_bar(board_id)]),
    html.div([attribute.class("flex")], [
      html.div([attribute.class("flex-1")], [
        html.div(
          [class("text-2xl text-center bg-orange-700 rounded-md m-1.5")],
          [element.text("To Do")],
        ),
        todos(
          board_id,
          list.filter(items, fn(item) {
            item.status |> string_to_item_status == item.Todo
          }),
        ),
      ]),
      html.div([attribute.class("flex-1")], [
        html.div(
          [attribute.class("text-2xl text-center bg-cyan-700 rounded-md m-1.5")],
          [element.text("Doing")],
        ),
        others(
          attribute.attribute("data-testid", "doing-items"),
          board_id,
          list.filter(items, fn(item) {
            item.status |> string_to_item_status == item.Doing
          }),
        ),
      ]),
      html.div([attribute.class("flex-1")], [
        html.div(
          [
            attribute.class(
              "text-2xl text-center bg-green-700 rounded-md m-1.5",
            ),
          ],
          [element.text("Done")],
        ),
        others(
          attribute.attribute("data-testid", "done-items"),
          board_id,
          list.filter(items, fn(item) {
            item.status |> string_to_item_status == item.Done
          }),
        ),
      ]),
    ]),
  ])
}

fn todos(board_id: String, items: List(Item)) -> Element(t) {
  html.div([attribute.attribute("data-testid", "todo-items")], [
    html.ul(
      [],
      items
        |> list.map(curry2(item)(board_id))
        |> list.prepend(todo_input(board_id)),
    ),
  ])
}

fn others(
  attribute: attribute.Attribute(t),
  board_id: String,
  items: List(Item),
) -> Element(t) {
  html.div([attribute], [
    html.ul(
      [],
      items
        |> list.map(curry2(item)(board_id)),
    ),
  ])
}

fn toggle_prev(board_id: String, item: Item) -> Element(t) {
  form(
    [
      attribute.method("POST"),
      attribute.action(
        "/boards/"
        <> board_id
        <> "/items/"
        <> result.unwrap(uuid.cast(item.id), "")
        <> "/"
        <> item.status
        |> string_to_item_status
        |> prev_status
        |> item_status_to_string
        |> lowercase
        <> "?_method=PATCH",
      ),
    ],
    [button([], [svg_icon_angle_left()])],
  )
}

fn toggle_next(board_id: String, item: Item) -> Element(t) {
  form(
    [
      attribute.method("POST"),
      attribute.action(
        "/boards/"
        <> board_id
        <> "/items/"
        <> result.unwrap(uuid.cast(item.id), "")
        <> "/"
        <> item.status
        |> string_to_item_status
        |> next_status
        |> item_status_to_string
        |> lowercase
        <> "?_method=PATCH",
      ),
    ],
    [
      button([attribute.attribute("data-testid", "toggle-next")], [
        svg_icon_angle_right(),
      ]),
    ],
  )
}

fn item(board_id: String, item: Item) -> Element(t) {
  html.li([], [
    html.a([attribute.href("#")], [
      html.div([class("flex flex-row justify-between navigate")], [
        toggle_prev(board_id, item),
        form(
          [
            attribute.method("POST"),
            attribute.action(
              "/boards/"
              <> board_id
              <> "/items/"
              <> result.unwrap(uuid.cast(item.id), "")
              <> "?_method=DELETE",
            ),
          ],
          [
            button([attribute.attribute("data-testid", "delete-todo")], [
              svg_icon_delete(),
            ]),
          ],
        ),
        toggle_next(board_id, item),
      ]),
      html.p([], [element.text(item.content)]),
    ]),
  ])
}

fn todo_input(board_id: String) -> Element(t) {
  html.li([], [
    html.a([attribute.href("#")], [
      form(
        [
          attribute.method("POST"),
          attribute.action("/boards/" <> board_id <> "/items/create"),
        ],
        [
          html.div([class("flex flex-col")], [
            textarea(
              [
                class("todo_input"),
                rows(4),
                attribute("maxlength", "32"),
                name("todo_input"),
                placeholder("What needs to be done?"),
                autofocus(True),
              ],
              "",
            ),
            html.button(
              [
                attribute.attribute("data-testid", "create-todo"),
                class("bg-black text-white font-bold px-4 rounded"),
              ],
              [element.text("OK")],
            ),
          ]),
        ],
      ),
    ]),
  ])
}

fn svg_icon_angle_left() -> Element(t) {
  svg(
    [
      class("w-[18px] h-[18px] text-gray-800 dark:text-black"),
      attribute.attribute("aria-hidden", "true"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute("stroke", "currentColor"),
        attribute.attribute("stroke-linecap", "round"),
        attribute.attribute("stroke-linejoin", "round"),
        attribute.attribute("stroke-width", "2"),
        attribute.attribute("d", "m15 19-7-7 7-7"),
      ]),
    ],
  )
}

fn svg_icon_angle_right() -> Element(t) {
  svg(
    [
      class("w-[18px] h-[18px] text-gray-800 dark:text-black"),
      attribute.attribute("aria-hidden", "true"),
      attribute.attribute("fill", "none"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute("stroke", "currentColor"),
        attribute.attribute("stroke-linecap", "round"),
        attribute.attribute("stroke-linejoin", "round"),
        attribute.attribute("stroke-width", "2"),
        attribute.attribute("d", "m9 5 7 7-7 7"),
      ]),
    ],
  )
}

fn svg_icon_delete() -> Element(t) {
  svg(
    [
      class("w-[18px] h-[18px] text-gray-800 dark:text-black"),
      attribute.attribute("viewBox", "0 0 24 24"),
    ],
    [
      svg.path([
        attribute.attribute("fill", "currentColor"),
        attribute.attribute(
          "d",
          "M9,3V4H4V6H5V19A2,2 0 0,0 7,21H17A2,2 0 0,0 19,19V6H20V4H15V3H9M9,8H11V17H9V8M13,8H15V17H13V8Z",
        ),
      ]),
    ],
  )
}
