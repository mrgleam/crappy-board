import app/error.{type AppError}
import gleam/dynamic
import gleam/io
import gleam/pgo.{type Connection}
import gleam/result

pub type BoardUser {
  BoardUser(board_id: BitArray, user_id: BitArray)
}

pub fn create_board_user(
  board_id: String,
  user_id: String,
  db: Connection,
) -> Result(Int, AppError) {
  let sql =
    "
        INSERT INTO boards_users
          (board_id, user_id)
        VALUES
          ($1, $2)
      "
  use returned <- result.then(
    pgo.execute(
      sql,
      db,
      [pgo.text(board_id), pgo.text(user_id)],
      dynamic.int,
    )
    |> result.map_error(fn(error) {
      io.debug(error)
      case error {
        _ -> error.BadRequest
      }
    }),
  )

  let count = returned.count
  Ok(count)
}
