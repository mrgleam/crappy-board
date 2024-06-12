import app/helpers/uuid
import app/models/item.{type Item}
import gleam/list
import gleam/result
import lustre/attribute.{attribute, autofocus, class, name, placeholder, rows}
import lustre/element.{type Element}
import lustre/element/html.{button, form, svg, textarea}
import lustre/element/svg

pub fn root(items: List(Item)) -> Element(t) {
  html.div([attribute.class("flex")], [
    html.div([attribute.class("flex-1")], [
      html.div(
        [attribute.class("text-2xl text-center bg-orange-700 rounded-md m-1.5")],
        [element.text("To Do")],
      ),
      todos(items),
    ]),
    html.div([attribute.class("flex-1")], [
      html.div(
        [attribute.class("text-2xl text-center bg-cyan-700 rounded-md m-1.5")],
        [element.text("Doing")],
      ),
      html.div([], [
        html.ul([], [
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #1")]),
              html.p([], [element.text("Text Content #1")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #2")]),
              html.p([], [element.text("Text Content #2")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #3")]),
              html.p([], [element.text("Text Content #3")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #4")]),
              html.p([], [element.text("Text Content #4")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #5")]),
              html.p([], [element.text("Text Content #5")]),
            ]),
          ]),
        ]),
      ]),
    ]),
    html.div([attribute.class("flex-1")], [
      html.div(
        [attribute.class("text-2xl text-center bg-green-700 rounded-md m-1.5")],
        [element.text("Done")],
      ),
      html.div([], [
        html.ul([], [
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #1")]),
              html.p([], [element.text("Text Content #1")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #2")]),
              html.p([], [element.text("Text Content #2")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #3")]),
              html.p([], [element.text("Text Content #3")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #4")]),
              html.p([], [element.text("Text Content #4")]),
            ]),
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #5")]),
              html.p([], [element.text("Text Content #5")]),
            ]),
          ]),
        ]),
      ]),
    ]),
  ])
}

fn todos(items: List(Item)) -> Element(t) {
  html.div([], [
    html.ul(
      [],
      items
        |> list.map(item)
        |> list.append([todo_input()]),
    ),
  ])
}

fn item(item: Item) -> Element(t) {
  html.li([], [
    html.a([attribute.href("#")], [
      html.div([class("flex flex-row justify-between navigate")], [
        form(
          [
            attribute.method("POST"),
            attribute.action(
              "/items/"
              <> result.unwrap(uuid.cast(item.id), "")
              <> "/todo?_method=PATCH",
            ),
          ],
          [button([], [svg_icon_angle_left()])],
        ),
        form(
          [
            attribute.method("POST"),
            attribute.action(
              "/items/"
              <> result.unwrap(uuid.cast(item.id), "")
              <> "?_method=DELETE",
            ),
          ],
          [button([], [svg_icon_delete()])],
        ),
        form(
          [
            attribute.method("POST"),
            attribute.action(
              "/items/"
              <> result.unwrap(uuid.cast(item.id), "")
              <> "/doing?_method=PATCH",
            ),
          ],
          [button([], [svg_icon_angle_right()])],
        ),
      ]),
      html.p([], [element.text(item.content)]),
    ]),
  ])
}

fn todo_input() -> Element(t) {
  html.li([], [
    html.a([attribute.href("#")], [
      form([attribute.method("POST"), attribute.action("/items/create")], [
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
          html.button([class("bg-black text-white font-bold px-4 rounded")], [
            element.text("OK"),
          ]),
        ]),
      ]),
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
