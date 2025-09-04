import boss.{
  type BossMsg, type WorkerMsg, Shutdown, Work, WorkerDone, WorkerReady,
}
import gleam/erlang/process
//import gleam/int
//import gleam/io
import gleam/otp/actor
import gleam/result
//import gleam/string
import squares

pub type State {
  State(boss: process.Subject(BossMsg), self: process.Subject(WorkerMsg))
}

/// Start a worker linked to the given boss subject.
pub fn start(
  boss: process.Subject(BossMsg),
) -> Result(process.Subject(WorkerMsg), actor.StartError) {
  // Initialiser sends WorkerReady to boss and returns state containing boss + self
  actor.new_with_initialiser(100, fn(self_subject) {
    process.send(boss, WorkerReady(self_subject))
    let state = State(boss, self_subject)
    let init = actor.initialised(state)
    let init2 = actor.returning(init, self_subject)
    Ok(init2)
  })
  |> actor.on_message(handle)
  |> actor.start
  |> result.map(fn(started) { started.data })
}

fn handle(state: State, msg: WorkerMsg) -> actor.Next(State, WorkerMsg) {
  let State(boss, self) = state
  case msg {
    Work(start, end_, k) -> {
      //let pid_str = string.inspect(process.self())
      //io.println("Worker " <> pid_str <> " processing " <> int.to_string(start) <> ".." <> int.to_string(end_))
      let solutions = squares.scan_range(start, end_, k)
      process.send(boss, WorkerDone(solutions, self))
      // ask for more work
      process.send(boss, WorkerReady(self))
      actor.continue(state)
    }
    Shutdown -> actor.stop()
  }
}
