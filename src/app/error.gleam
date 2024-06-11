import gleam/pgo

pub type AppError {
  NotFound
  MethodNotAllowed
  UserNotFound
  BadRequest
  UnprocessableEntity
  ContentRequired
  DatabaseError(pgo.QueryError)
}
