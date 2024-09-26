import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn root(confirmation_link: String) -> Element(t) {
  html.div([attribute.class("email-container")], [
    html.h1([], [element.text("Email Confirmation")]),
    html.p([], [
      element.text(
        "Thank you for registering! Please confirm your email by clicking the button below.",
      ),
    ]),
    html.a([attribute.href(confirmation_link)], [element.text("Confirm Email")]),
    html.p([], [
      element.text("If you didn’t create an account, ignore this email."),
    ]),
    html.footer([], [element.text("© 2024 Planktonsoft. All rights reserved.")]),
  ])
}
