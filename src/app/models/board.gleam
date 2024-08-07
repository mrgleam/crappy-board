import app/error.{type AppError}
import app/helpers/uuid
import gleam/dynamic
import gleam/io
import gleam/list
import gleam/pgo.{type Connection}
import gleam/result

pub type Board {
  Board(id: BitArray, owner: BitArray)
}

/// Decode a board from a database row.
///
pub fn board_row_decoder() -> dynamic.Decoder(Board) {
  dynamic.decode2(
    Board,
    dynamic.element(0, dynamic.bit_array),
    dynamic.element(1, dynamic.bit_array),
  )
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

pub fn first(boards: List(Board)) {
  boards |> list.first
}

pub fn get_string_id(board: Result(Board, Nil)) {
  case board {
    Ok(b) -> b.id |> uuid.cast |> fn(x) { result.unwrap(x, "") }
    Error(_) -> ""
  }
}
