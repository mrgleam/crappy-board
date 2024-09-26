import gleam/pgo
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
