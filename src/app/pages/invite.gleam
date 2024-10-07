import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html

pub fn root(board_id: String, error: String) -> Element(t) {
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
          [element.text("Invite to your friend")],
        ),
      ]),
      html.div([attribute.class("mt-10 sm:mx-auto sm:w-full sm:max-w-sm")], [
        html.form(
          [
            attribute.class("space-y-6"),
            attribute.method("POST"),
            attribute.action("/boards/" <> board_id <> "/invite"),
          ],
          [
            html.div([], [
              html.div([], [
                html.div([attribute.class("mt-2")], [
                  html.input([
                    attribute.class(
                      "block w-full bg-white/[.05] rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset ring-white/[.1] placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6",
                    ),
                    attribute.id("board"),
                    attribute.name("board"),
                    attribute.type_("hidden"),
                    attribute.value(board_id),
                  ]),
                ]),
              ]),
              html.label(
                [
                  attribute.for("email"),
                  attribute.class("block text-sm font-medium leading-6"),
                ],
                [element.text("Email address")],
              ),
              html.div([attribute.class("mt-2")], [
                html.input([
                  attribute.class(
                    "block w-full bg-white/[.05] rounded-md border-0 py-1.5 shadow-sm ring-1 ring-inset ring-white/[.1] placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6",
                  ),
                  attribute.id("email"),
                  attribute.name("email"),
                  attribute.type_("email"),
                ]),
              ]),
            ]),
            html.div([], [
              html.button(
                [
                  attribute.type_("sumbit"),
                  attribute.class(
                    "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600",
                  ),
                ],
                [element.text("Submit")],
              ),
            ]),
            html.div(
              [attribute.class("text-center text-red-600 font-bold text-lg")],
              [element.text(error)],
            ),
          ],
        ),
      ]),
    ],
  )
}
