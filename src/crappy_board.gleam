import app/router
import app/web.{Context}
import dot_env
import dot_env/env
import gleam/erlang/process
import gleam/int
import gleam/option.{Some}
import gleam/pgo
import mist
import wisp

pub fn main() {
  wisp.configure_logger()

  dot_env.load()
  let assert Ok(secret_key_base) = env.get("SECRET_KEY_BASE")
  let assert Ok(pg_host) = env.get("PG_HOST")
  let assert Ok(pg_port_string) = env.get("PG_PORT")
  let assert Ok(pa_port) = int.parse(pg_port_string)
  let assert Ok(pg_user) = env.get("PG_USER")
  let assert Ok(pg_password) = env.get("PG_PASSWORD")

  // Start a database connection pool.
  // Typically you will want to create one pool for use in your program
  let db =
    pgo.connect(
      pgo.Config(
        ..pgo.default_config(),
        host: pg_host,
        port: pa_port,
        database: "crappy",
        user: pg_user,
        password: Some(pg_password),
        pool_size: 15,
      ),
    )

  let ctx = Context(static_directory: static_directory(), db: db)

  let handler = router.handle_request(_, ctx)

  let assert Ok(_) =
    wisp.mist_handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn static_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("crappy_board")
  priv_directory <> "/static"
}
