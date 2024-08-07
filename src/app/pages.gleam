import app/models/item.{type Item}
import app/pages/home
import app/pages/signin
import app/pages/signup
import app/pages/signup_success

pub fn home(board_id: String, items: List(Item)) {
  home.root(board_id, items)
}

pub fn signup(error: String) {
  signup.root(error)
}

pub fn signup_success() {
  signup_success.root()
}

pub fn signin(error: String) {
  signin.root(error)
}
