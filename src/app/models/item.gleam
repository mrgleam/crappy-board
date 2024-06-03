import gleam/option.{type Option}
import wisp

pub type ItemStatus {
  Todo
  Doing
  Done
}

pub type Item {
  Item(id: String, content: String, status: ItemStatus)
}

pub fn create_item(id: Option(String), content: String) -> Item {
  let id = option.unwrap(id, wisp.random_string(64))
  Item(id, content, Todo)
}

pub fn toggle_item(item: Item, new_status: ItemStatus) -> Item {
  Item(..item, status: new_status)
}

pub fn item_status_to_string(status: ItemStatus) -> String {
  case status {
    Todo -> "Todo"
    Doing -> "Doing"
    Done -> "Done"
  }
}
