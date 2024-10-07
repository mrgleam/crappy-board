import app/models/item.{type Item}
import app/pages/forgot_password
import app/pages/home
import app/pages/invite
import app/pages/reset_password
import app/pages/signin
import app/pages/signup
import app/pages/signup_success
import app/pages/submit_forgot_password
import app/pages/submit_invite

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

pub fn forgot_password(error: String) {
  forgot_password.root(error)
}

pub fn submit_forgot_password() {
  submit_forgot_password.root()
}

pub fn reset_password(token: String, error: String) {
  reset_password.root(token, error)
}

pub fn invite(board_id: String, error: String) {
  invite.root(board_id, error)
}

pub fn submit_invite() {
  submit_invite.root()
}
