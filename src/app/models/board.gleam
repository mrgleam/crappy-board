import app/error.{type AppError}
import gleam/dynamic
import gleam/io
import gleam/pgo.{type Connection}
import gleam/result

pub type Board {
  Board(id: BitArray, owner: BitArray)
}

pub fn create_board(
  user_id: String,
  db: Connection,
) -> Result(BitArray, AppError) {
  let sql =
    "
        INSERT INTO boards
          (owner_id)
        VALUES
          ($1)
        RETURNING
          id
      "
  use returned <- result.then(
    pgo.execute(
      sql,
      db,
      [pgo.text(user_id)],
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
