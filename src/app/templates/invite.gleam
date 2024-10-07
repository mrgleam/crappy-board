import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn root(invite_link: String) -> Element(t) {
  html.div([attribute.class("email-container")], [
    html.h1([], [element.text("You got invitation")]),
    html.p([], [element.text("Please click the button below.")]),
    html.a([attribute.href(invite_link)], [element.text("Join")]),
    html.p([], [
      element.text("If you didn’t want to join, ignore this email."),
    ]),
    html.footer([], [element.text("© 2024 Planktonsoft. All rights reserved.")]),
  ])
}
