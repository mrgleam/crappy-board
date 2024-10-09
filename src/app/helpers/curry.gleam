import gleam/result

pub fn then() {
  fn(a) { fn(b) { result.try(a, b) } }
}
