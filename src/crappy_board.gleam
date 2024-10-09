import app/helpers/constant
import app/router
import app/web.{Context}
import dot_env
import dot_env/env
import gleam/erlang/process
import gleam/int
import gleam/option.{Some}
import gleam/pgo
import mist
import radish
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()

  dot_env.load_default()
  let assert Ok(base_url) = env.get_string("BASE_URL")
  let assert Ok(email_api_key) = env.get_string("EMAIL_API_KEY")
  let assert Ok(secret_key_base) = env.get_string("SECRET_KEY_BASE")
  let assert Ok(redis_host) = env.get_string("REDIS_HOST")
  let assert Ok(pg_host) = env.get_string("PG_HOST")
  let assert Ok(pg_port_string) = env.get_string("PG_PORT")
  let assert Ok(pa_port) = int.parse(pg_port_string)
  let assert Ok(pg_db) = env.get_string("PG_DB")
  let assert Ok(pg_user) = env.get_string("PG_USER")
  let assert Ok(pg_password) = env.get_string("PG_PASSWORD")

  // Start a database connection pool.
  // Typically you will want to create one pool for use in your program
  let db =
    pgo.connect(
      pgo.Config(
        ..pgo.default_config(),
        host: pg_host,
        port: pa_port,
        database: pg_db,
        user: pg_user,
        password: Some(pg_password),
        pool_size: 15,
      ),
    )

  let assert Ok(redis) =
    radish.start(redis_host, 6379, [radish.Timeout(constant.timeout)])

  let ctx =
    Context(
      static_directory: static_directory(),
      base_url: base_url,
      db: db,
      redis: redis,
      email_api_key: email_api_key,
      user_id: "",
      board_ids: [],
    )

  let handler = router.handle_request(_, ctx)

  let assert Ok(_) =
    wisp_mist.handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

fn static_directory() {
  let assert Ok(priv_directory) = wisp.priv_directory("crappy_board")
  priv_directory <> "/static"
}
