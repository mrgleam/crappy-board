import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn root(reset_password_link: String) -> Element(t) {
  html.div([attribute.class("email-container")], [
    html.h1([], [element.text("Forgot Password Confirmation")]),
    html.p([], [element.text("Please click the button below.")]),
    html.a([attribute.href(reset_password_link)], [
      element.text("Forgot Password"),
    ]),
    html.p([], [
      element.text("If you didn’t forgot password, ignore this email."),
    ]),
    html.footer([], [element.text("© 2024 Planktonsoft. All rights reserved.")]),
  ])
}
