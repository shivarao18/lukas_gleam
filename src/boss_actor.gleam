import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor

pub type Msg {
  Assign(start: Int, stop: Int, reply_with: Subject(List(Int)))
  Result(result: List(Int))
  Done
}

pub type State {
  State(remaining: Int, results: List(Int), client: Subject(List(Int)))
}

pub fn handle_message(state: State, msg: Msg) -> actor.Next(State, Msg) {
  case msg {
    Assign(_, _, _) -> actor.continue(state)

    // boss doesn’t process Assign itself
    Result(r) -> {
      let new_results = list.append(state.results, r)
      let new_state =
        State(
          remaining: state.remaining,
          results: new_results,
          client: state.client,
        )
      actor.continue(new_state)
    }

    Done -> {
      let remaining = state.remaining - 1
      case remaining == 0 {
        True -> {
          // All workers finished → reply to client
          process.send(state.client, state.results)
          actor.stop()
        }
        False -> {
          let new_state =
            State(
              remaining: remaining,
              results: state.results,
              client: state.client,
            )
          actor.continue(new_state)
        }
      }
    }
  }
}
