//// UUID helper module for encoding a bit_string into a regular string
//// Most code translated from elixir here: 
//// https://github.com/elixir-ecto/ecto/blob/30311c21cb40f39dbbc148e58ff1ed3cac951ea1/lib/ecto/uuid.ex#L179-L188

import gleam/bit_array

/// Casts a bit_string into a regular string
/// 
/// ### Examples
/// 
/// ```gleam
/// cast(<<73, 159, 108, 135, 102, 203, 67, 106, 159, 57, 176, 178, 81, 149, 27, 34>>)
/// Ok("499f6c87-66cb-436a-9f39-b0b251951b22")
/// 
/// cast(<<0, 1, 2, 3>>)
/// Error(Nil)
/// ```
pub fn cast(binary: BitArray) -> Result(String, Nil) {
  case binary {
    <<
      a1:4,
      a2:4,
      a3:4,
      a4:4,
      a5:4,
      a6:4,
      a7:4,
      a8:4,
      b1:4,
      b2:4,
      b3:4,
      b4:4,
      c1:4,
      c2:4,
      c3:4,
      c4:4,
      d1:4,
      d2:4,
      d3:4,
      d4:4,
      e1:4,
      e2:4,
      e3:4,
      e4:4,
      e5:4,
      e6:4,
      e7:4,
      e8:4,
      e9:4,
      e10:4,
      e11:4,
      e12:4,
    >> ->
      <<
        e(a1),
        e(a2),
        e(a3),
        e(a4),
        e(a5),
        e(a6),
        e(a7),
        e(a8),
        45,
        e(b1),
        e(b2),
        e(b3),
        e(b4),
        45,
        e(c1),
        e(c2),
        e(c3),
        e(c4),
        45,
        e(d1),
        e(d2),
        e(d3),
        e(d4),
        45,
        e(e1),
        e(e2),
        e(e3),
        e(e4),
        e(e5),
        e(e6),
        e(e7),
        e(e8),
        e(e9),
        e(e10),
        e(e11),
        e(e12),
      >>
      |> bit_array.to_string()

    _ -> Error(Nil)
  }
}

fn e(i: Int) {
  case i {
    0 -> 48
    1 -> 49
    2 -> 50
    3 -> 51
    4 -> 52
    5 -> 53
    6 -> 54
    7 -> 55
    8 -> 56
    9 -> 57
    10 -> 97
    11 -> 98
    12 -> 99
    13 -> 100
    14 -> 101
    15 -> 102
    _ -> 0
  }
}
