import boss_actor
import gleam/erlang/process.{type Subject}
import gleam/float
import gleam/int
import gleam/list
import gleam/otp/actor

pub type Msg {
  Work(start: Int, stop: Int, k: Int, boss: Subject(boss_actor.Msg))
}

fn is_square(n: Int) -> Bool {
  let assert Ok(root) = int.square_root(n)
  let floor_root = float.floor(root)
  let int_root = float.round(floor_root)
  int_root * int_root == n
}

fn sum_of_squares(start: Int, k: Int) -> Int {
  list.range(start, start + k - 1)
  |> list.map(fn(x) { x * x })
  |> list.fold(0, fn(x, acc) { x + acc })
}

pub fn handle_message(_state: Nil, msg: Msg) -> actor.Next(Nil, Msg) {
  case msg {
    Work(start, stop, k, boss) -> {
      let results =
        list.range(start, stop)
        |> list.filter(fn(n) { is_square(sum_of_squares(n, k)) })

      // Send results back to boss
      process.send(boss, boss_actor.Result(results))
      process.send(boss, boss_actor.Done)

      actor.continue(Nil)
    }
  }
}
