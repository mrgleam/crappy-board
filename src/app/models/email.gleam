import app/error.{type AppError}
import app/templates
import app/templates/layout.{layout}
import gleam/function.{curry2}
import gleam/httpc
import gleam/io
import gleam/result
import lustre/element
import zeptomail.{type ApiData, Addressee}

pub fn send_verify_user(
  email_api_key: String,
  to: String,
  confirmation_link: String,
) -> Result(ApiData, AppError) {
  // Create an email to send

  let body =
    [templates.signup_confirmation(confirmation_link)]
    |> curry2(layout)("Account Confirmation")
    |> element.to_string

  let email =
    zeptomail.Email(
      from: Addressee("Planktonsoft", "noreply@planktonsoft.com"),
      to: [Addressee(to, to)],
      reply_to: [],
      cc: [],
      bcc: [],
      body: zeptomail.HtmlBody(body),
      subject: "Crappy Board: Account Confirmation",
    )

  // Prepare an API request that sends the email
  let request = zeptomail.email_request(email, email_api_key)

  // Send the API request using `gleam_httpc`
  let assert Ok(response) = httpc.send(request)

  // Parse the API response to verify success
  use data <- result.then(
    zeptomail.decode_email_response(response)
    |> result.map_error(fn(error) {
      io.debug(error)
      case error {
        _ -> error.ApiError(error)
      }
    }),
  )

  Ok(data)
}
