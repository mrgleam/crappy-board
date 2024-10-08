import gleam/io
import gleam/pgo
import gleam/result
import zeptomail.{type ApiError}

pub type AppError {
  NotFound
  MethodNotAllowed
  UserNotFound
  BadRequest
  UnprocessableEntity
  ContentRequired
  DatabaseError(pgo.QueryError)
  ApiError(ApiError)
}

pub fn map_bad_request(r: Result(a, b)) -> Result(a, AppError) {
  r
  |> result.map_error(fn(error) {
    io.debug(error)
    case error {
      _ -> BadRequest
    }
  })
}

pub fn try_bad_request(
  result: Result(a, e1),
  apply fun: fn(a) -> Result(b, e2),
) -> Result(b, AppError) {
  case result {
    Ok(x) -> map_bad_request(fun(x))
    Error(_) -> Error(BadRequest)
  }
}
