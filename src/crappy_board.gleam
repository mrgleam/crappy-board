import lustre
import lustre/element
import lustre/element/html
import lustre/attribute

pub fn main() {
  let app = lustre.element(
      html.div([], [
        html.ul([], [
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #1")]),
              html.p([], [element.text("Text Content #1")])
            ])
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #2")]),
              html.p([], [element.text("Text Content #2")])
            ])
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #3")]),
              html.p([], [element.text("Text Content #3")])
            ])
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #4")]),
              html.p([], [element.text("Text Content #4")])
            ])
          ]),
          html.li([], [
            html.a([attribute.href("#")], [
              html.h2([], [element.text("Title #5")]),
              html.p([], [element.text("Text Content #5")])
            ])
          ])
        ])
      ])
    )
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
