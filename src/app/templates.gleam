import app/templates/forgot_password_confirmation
import app/templates/signup_confirmation

pub fn signup_confirmation(confirmation_link: String) {
  signup_confirmation.root(confirmation_link)
}

pub fn forgot_password_confirmation(reset_password_link: String) {
  forgot_password_confirmation.root(reset_password_link)
}
