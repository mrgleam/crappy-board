import app/error.{type AppError}
import app/helpers/constant
import beecrypt
import gleam/dynamic
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/order
import gleam/pgo.{type Connection}
import gleam/result
import gleam/string
import radish.{type Message}

pub type User {
  User(id: BitArray, email: String, password: String, is_verified: Bool)
}

/// Decode an item from a database row.
///
pub fn user_row_decoder() -> dynamic.Decoder(User) {
  dynamic.decode4(
    User,
    dynamic.element(0, dynamic.bit_array),
    dynamic.element(1, dynamic.string),
    dynamic.element(2, dynamic.string),
    dynamic.element(3, dynamic.bool),
  )
}

pub fn create_user(
  email: String,
  password: String,
  db: Connection,
) -> Result(BitArray, AppError) {
  let sql =
    "
        INSERT INTO users
          (email, password)
        VALUES
          ($1, $2)
        RETURNING
          id
      "
  use returned <- result.then(
    pgo.execute(
      sql,
      db,
      [pgo.text(email), pgo.text(beecrypt.hash(password))],
      dynamic.element(0, dynamic.bit_array),
    )
    |> result.map_error(fn(error) {
      io.debug(error)
      case error {
        _ -> error.BadRequest
      }
    }),
  )

  let assert [id] = returned.rows
  Ok(id)
}

pub fn signin_user(
  email: String,
  password: String,
  db: Connection,
) -> Result(User, AppError) {
  let sql =
    "
      SELECT
        id,
        email,
        password,
        is_verified
      FROM
        users
      WHERE email = $1
    "

  use returned <- result.then(
    pgo.execute(sql, db, [pgo.text(email)], user_row_decoder())
    |> result.map_error(fn(error) {
      io.debug(error)
      case error {
        _ -> error.BadRequest
      }
    }),
  )

  let assert [user] = returned.rows

  case beecrypt.verify(password, user.password) && user.is_verified {
    True -> Ok(user)
    False -> Error(error.BadRequest)
  }
}

pub fn activate_user(
  user_id: String,
  req_token: String,
  db: Connection,
  redis: Subject(Message),
) {
  use token <- result.try(
    radish.get(redis, user_id, constant.timeout)
    |> result.map_error(fn(_) { error.BadRequest }),
  )

  case string.compare(req_token, token) {
    order.Eq -> {
      let sql =
        "
          UPDATE users SET is_verified = true, updated_at = NOW() WHERE id = $1
        "
      use returned <- result.then(
        pgo.execute(sql, db, [pgo.text(user_id)], dynamic.int)
        |> result.map_error(fn(error) {
          io.debug(error)
          case error {
            pgo.ConstraintViolated(_, _, _) -> error.ContentRequired
            _ -> error.BadRequest
          }
        }),
      )

      let count = returned.count
      Ok(count)
    }
    _ -> {
      Error(error.BadRequest)
    }
  }
}
