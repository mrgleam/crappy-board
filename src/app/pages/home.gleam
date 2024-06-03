import lustre/attribute.{attribute, autofocus, class, name, placeholder, rows}
import lustre/element.{type Element}
import lustre/element/html.{form, textarea}

pub fn root() -> Element(t) {
  html.div([attribute.class("flex")], [
    html.div([attribute.class("flex-1")], [
      html.div(
        [attribute.class("text-2xl text-center bg-orange-700 rounded-md m-1")],
        [element.text("To Do")],
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
          todo_input(),
        ]),
      ]),
    ]),
    html.div([attribute.class("flex-1")], [
      html.div(
        [attribute.class("text-2xl text-center bg-cyan-700 rounded-md m-1")],
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
        [attribute.class("text-2xl text-center bg-green-700 rounded-md m-1")],
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

fn todo_input() -> Element(t) {
  html.li([], [
    html.a([attribute.href("#")], [
      form([attribute.method("POST"), attribute.action("/items/create")], [
        html.div([class("flex flex-col")], [
          textarea(
            [
              class("todo_input"),
              rows(4),
              attribute("maxlength", "50"),
              name("todo_input"),
              placeholder("What needs to be done?"),
              autofocus(True),
            ],
            "",
          ),
          html.button(
            [
              class(
                "bg-blue-500 hover:bg-blue-700 text-white font-bold px-4 rounded",
              ),
            ],
            [element.text("OK")],
          ),
        ]),
      ]),
    ]),
  ])
}
