import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn layout(title: String, elements: List(Element(t))) -> Element(t) {
  let email_styles =
    "
      body { font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333333; }
      .email-container { max-width: 600px; margin: 0 auto; background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }
      h1 { color: #4CAF50; }
      a { padding: 10px 20px; background-color: #4CAF50; color: #fff; text-decoration: none; border-radius: 5px; }
      footer { font-size: 12px; color: #999999; text-align: center; }
    "

  html.html([], [
    html.head([], [
      html.title([], title),
      html.meta([attribute.attribute("charset", "UTF-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1"),
      ]),
      html.style([], email_styles),
    ]),
    html.body([], elements),
  ])
}
