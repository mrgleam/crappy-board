import app/models/item.{type Item}
import app/pages/home
import app/pages/signup

pub fn home(items: List(Item)) {
  home.root(items)
}

pub fn signup() {
  signup.root()
}
