import gleam/int
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

// MODEL
//
pub type Card {
  Card(content: String, length: Int, max: Int)
}

pub fn init(_flags) -> Card {
  Card(content: "", length: 0, max: 100)
}

// UPDATE
//
pub opaque type Msg {
  UserUpdatedMessage(content: String)
  UserResetMessage
}

pub fn update(card: Card, msg: Msg) -> Card {
  case msg {
    UserUpdatedMessage(content) -> {
      let length = string.length(content)

      case length <= card.max {
        True -> Card(..card, content: content, length: length)
        False -> card
      }
    }
    UserResetMessage -> Card(..card, content: "", length: 0)
  }
}

// VIEW
//
pub fn view(card: Card) -> Element(Msg) {
  let length = int.to_string(card.length)
  let max = int.to_string(card.max)

  html.div([], [
    html.ul([], [
      html.li([], [
        html.a([attribute.href("#")], [
          html.h2([], [element.text("Title #1")]),
          html.p([], [
            html.textarea([event.on_input(UserUpdatedMessage)], card.content),
          ]),
          html.p([attribute.class("word-counter")], [
            element.text(length <> "/" <> max),
          ]),
        ]),
      ]),
    ]),
  ])
}
