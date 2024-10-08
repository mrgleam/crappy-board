import app/error.{type AppError}
import app/helpers/constant
import app/models/board.{type Board, board_row_decoder}
import gleam/dynamic
import gleam/erlang/process.{type Subject}
import gleam/io
import gleam/json
import gleam/pgo.{type Connection}
import gleam/result
import radish.{type Message}

pub type BoardUser {
  BoardUser(board_id: BitArray, user_id: BitArray)
}

pub type Join {
  Join(board_id: String, user_id: String)
}

pub fn join_decoder() -> dynamic.Decoder(Join) {
  dynamic.decode2(
    Join,
    dynamic.field("board_id", of: dynamic.string),
    dynamic.field("user_id", of: dynamic.string),
  )
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
    pgo.execute(sql, db, [pgo.text(board_id), pgo.text(user_id)], dynamic.int)
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

pub fn list_board_user(user_id: String, db: Connection) -> List(Board) {
  let sql =
    "
      SELECT
        board_id as id,
        boards.owner_id
      FROM
        boards_users
      INNER JOIN boards ON boards_users.board_id=boards.id
      WHERE
        boards_users.user_id = $1
      ORDER BY
        boards.created_at asc
    "

  let assert Ok(returned) =
    pgo.execute(sql, db, [pgo.text(user_id)], board_row_decoder())

  returned.rows
}

pub fn count_board_user(user_id: String, db: Connection) -> Int {
  let sql =
    "
      SELECT
        count(*)
      FROM
        boards_users
      WHERE
        user_id = $1
    "

  let assert Ok(returned) =
    pgo.execute(sql, db, [pgo.text(user_id)], dynamic.element(0, dynamic.int))

  let assert [count] = returned.rows

  count
}

pub fn join(req_token: String, db: Connection, redis: Subject(Message)) {
  use data <- result.try(
    radish.get(redis, req_token, constant.timeout)
    |> result.map(fn(obj) {
      json.decode(obj, join_decoder())
      |> result.map_error(fn(error) {
        io.debug(error)
        error.BadRequest
      })
    })
    |> result.map_error(fn(error) {
      io.debug(error)
      error.BadRequest
    })
    |> result.flatten,
  )

  io.debug(data)

  create_board_user(data.board_id, data.user_id, db)
}

pub fn validate_board_user(
  user_id: String,
  db: Connection,
) -> Result(Int, AppError) {
  case count_board_user(user_id, db) {
    a if a >= 10 -> {
      Error(error.BadRequest)
    }
    a -> {
      Ok(a)
    }
  }
}
