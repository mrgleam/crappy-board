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
          [element.text("Submit Forgot Password Successful!")],
        ),
      ]),
      html.div([attribute.class("mt-10 sm:mx-auto sm:w-full sm:max-w-sm")], [
        html.div([attribute.class("text-center")], [
          element.text("Check your email to reset your password"),
        ]),
      ]),
      html.div([attribute.class("mt-10 sm:mx-auto sm:w-full sm:max-w-sm")], [
        html.div([attribute.class("text-center")], [
          html.form([], [
            html.button(
              [
                attribute.attribute("formaction", "/signin"),
                attribute.class(
                  "flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600",
                ),
              ],
              [element.text("Sign in")],
            ),
          ]),
        ]),
      ]),
    ],
  )
}
