import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn root() -> Element(t) {
  html.div(
    [
      attribute.class(
        "flex min-h-full flex-col justify-center px-6 py-12 lg:px-8",
      ),
    ],
    [
      html.div([attribute.class("sm:mx-auto sm:w-full sm:max-w-sm")], [
        html.h2(
          [
            attribute.class(
              "mt-10 text-center text-2xl font-bold leading-9 tracking-tight",
            ),
          ],
          [element.text("Invitation Successful!")],
        ),
      ]),
      html.div([attribute.class("mt-10 sm:mx-auto sm:w-full sm:max-w-sm")], [
        html.div([attribute.class("text-center")], [
          element.text("Please notify members to check their email"),
        ]),
      ]),
    ],
  )
}
