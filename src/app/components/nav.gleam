import gleam/list
import lustre/attribute
import lustre/element
import lustre/element/html

pub fn nav_bar() -> element.Element(t) {
  html.div([attribute.id("nav-bar")], [
    nav_toggle(),
    nav_header(),
    nav_content(),
    nav_footer_toggle(),
    nav_footer(),
  ])
}

fn nav_toggle() -> element.Element(t) {
  html.input([
    attribute.id("nav-toggle"),
    attribute.type_("checkbox"),
    attribute.checked(True),
  ])
}

fn nav_header() -> element.Element(t) {
  html.div([attribute.id("nav-header")], [
    html.a([attribute.id("nav-title"), attribute.href("#")], [
      element.text("CR"),
      html.i([attribute.class("fa-brands fa-accessible-icon")], []),
      element.text("PPY "),
      html.i([attribute.class("fa-solid fa-person-chalkboard")], []),
    ]),
    html.label([attribute.for("nav-toggle")], [
      html.span([attribute.id("nav-toggle-burger")], []),
    ]),
    html.hr([]),
  ])
}

fn nav_content() -> element.Element(t) {
  html.div([attribute.id("nav-content")], [
    nav_button("fas fa-solid fa-user-plus", "Invite", "GET", "/invite", True),
    // nav_button("fas fa-images", "Assets", "GET", "#"),
    // nav_button("fas fa-thumbtack", "Pinned Items", "GET", "#"),
    html.hr([]),
    // nav_button("fas fa-heart", "Following", "GET", "#"),
    nav_button("fas fa-chart-line", "Trending", "GET", "#", False),
    // nav_button("fas fa-fire", "Challenges", "GET", "#"),
    // nav_button("fas fa-magic", "Spark", "GET", "#"),
    nav_button("fas fa-solid fa-gear", "Setting", "GET", "#", False),
    html.hr([]),
    nav_button(
      "fas fa-solid fa-arrow-right-from-bracket",
      "Sign Out",
      "POST",
      "/signout",
      False,
    ),
  ])
}

fn nav_button(
  icon_class: String,
  text: String,
  method: String,
  link: String,
  open_new_tabe: Bool,
) -> element.Element(t) {
  let form_attributes = [attribute.method(method), attribute.action(link)]

  let form_attributes = case open_new_tabe {
    True -> list.prepend(form_attributes, attribute.target("_blank"))
    False -> form_attributes
  }

  html.div([attribute.class("nav-button")], [
    html.i([attribute.class(icon_class)], []),
    html.form(form_attributes, [html.button([], [element.text(text)])]),
  ])
}

fn nav_footer_toggle() -> element.Element(t) {
  html.input([attribute.id("nav-footer-toggle"), attribute.type_("checkbox")])
}

fn nav_footer() -> element.Element(t) {
  html.div([attribute.id("nav-footer")], [
    nav_footer_heading(),
    nav_footer_content(),
  ])
}

fn nav_footer_heading() -> element.Element(t) {
  html.div([attribute.id("nav-footer-heading")], [
    html.div([attribute.id("nav-footer-avatar")], [
      html.img([
        attribute.src(
          "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y",
        ),
      ]),
    ]),
    html.div([attribute.id("nav-footer-titlebox")], [
      html.a(
        [
          attribute.id("nav-footer-title"),
          attribute.href("/profile"),
          attribute.target("_blank"),
        ],
        [element.text("unknown")],
      ),
      html.span([attribute.id("nav-footer-subtitle")], [element.text("User")]),
    ]),
    html.label([attribute.for("nav-footer-toggle")], [
      html.i([attribute.class("fas fa-caret-up")], []),
    ]),
  ])
}

fn nav_footer_content() -> element.Element(t) {
  html.div([attribute.id("nav-footer-content")], [element.text("")])
}
