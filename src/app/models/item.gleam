import app/error.{type AppError}
import gleam/dynamic
import gleam/io
import gleam/option.{type Option}
import gleam/pgo.{type Connection}
import gleam/result

pub type State =
  Option(Item)

pub type ItemStatus {
  Todo
  Doing
  Done
}

pub type Item {
  Item(id: BitArray, content: String, status: String)
}

/// Decode an item from a database row.
///
pub fn item_row_decoder() -> dynamic.Decoder(Item) {
  dynamic.decode3(
    Item,
    dynamic.element(0, dynamic.bit_array),
    dynamic.element(1, dynamic.string),
    dynamic.element(2, dynamic.string),
  )
}

/// Insert a new item for a given user.
///
pub fn create_item(
  board_id: String,
  content: String,
  db: Connection,
) -> Result(BitArray, AppError) {
  let sql =
    "
      INSERT INTO tasks
        (content, status, board_id) 
      VALUES 
        ($1, 'TODO', $2)
      RETURNING
        id
    "
  use returned <- result.then(
    pgo.execute(
      sql,
      db,
      [pgo.text(content), pgo.text(board_id)],
      dynamic.element(0, dynamic.bit_array),
    )
    |> result.map_error(fn(error) {
      io.debug(error)
      case error {
        pgo.ConstraintViolated(_, _, _) -> error.ContentRequired
        _ -> error.BadRequest
      }
    }),
  )

  let assert [id] = returned.rows
  Ok(id)
}

pub fn list_items(board_id: String, db: Connection) -> List(Item) {
  let sql =
    "
      SELECT
        id,
        content,
        status
      FROM
        tasks
      WHERE board_id = $1
      ORDER BY
        created_at asc
    "

  let assert Ok(returned) =
    pgo.execute(sql, db, [pgo.text(board_id)], item_row_decoder())

  returned.rows
}

pub fn delete_item(
  board_id: String,
  item_id: String,
  db: Connection,
) -> Result(Int, AppError) {
  let sql =
    "
      DELETE FROM tasks WHERE id = $1 AND board_id = $2
    "
  use returned <- result.then(
    pgo.execute(sql, db, [pgo.text(item_id), pgo.text(board_id)], dynamic.int)
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

pub fn patch_item(
  board_id: String,
  item_id: String,
  status: ItemStatus,
  db: Connection,
) {
  let sql =
    "
      UPDATE tasks SET status = $1, updated_at = NOW() WHERE id = $2 AND board_id = $3
    "
  use returned <- result.then(
    pgo.execute(
      sql,
      db,
      [
        pgo.text(item_status_to_string(status)),
        pgo.text(item_id),
        pgo.text(board_id),
      ],
      dynamic.int,
    )
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

pub fn item_status_to_string(status: ItemStatus) -> String {
  case status {
    Todo -> "TODO"
    Doing -> "DOING"
    Done -> "DONE"
  }
}

pub fn string_to_item_status(status: String) -> ItemStatus {
  case status {
    "TODO" -> Todo
    "DOING" -> Doing
    "DONE" -> Done
    _ -> Todo
  }
}

pub fn prev_status(status: ItemStatus) -> ItemStatus {
  case status {
    Todo -> Todo
    Doing -> Todo
    Done -> Doing
  }
}

pub fn next_status(status: ItemStatus) -> ItemStatus {
  case status {
    Todo -> Doing
    Doing -> Done
    Done -> Done
  }
}
