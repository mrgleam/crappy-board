import lustre/attribute
import lustre/element
import lustre/element/html

pub fn layout(elements: List(element.Element(t))) -> element.Element(t) {
  html.html([], [
    html.head([], [
      html.title([], "Crappy Board"),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1"),
      ]),
      html.link([
        attribute.rel("shortcut icon"),
        attribute.href("/static/favicon.ico"),
      ]),
      html.link([attribute.rel("stylesheet"), attribute.href("/static/app.css")]),
      html.link([attribute.rel("stylesheet"), attribute.href("/static/nav.css")]),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href(
          "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css",
        ),
      ]),
    ]),
    html.body([attribute.class("bg-gray-900")], elements),
  ])
}
