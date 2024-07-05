import app/error.{type AppError}
import beecrypt
import gleam/dynamic
import gleam/io
import gleam/pgo.{type Connection}
import gleam/result

pub type User {
  User(id: BitArray, email: String, password: String)
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
