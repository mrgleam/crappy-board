import app/models/item.{type Item}
import app/pages/home
import app/pages/signin
import app/pages/signup

pub fn home(items: List(Item)) {
  home.root(items)
}

pub fn signup(error: String) {
  signup.root(error)
}

pub fn signin(error: String) {
  signin.root(error)
}
