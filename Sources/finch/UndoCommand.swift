import Commandant
import Foundation
import TaskManagement
import Result

struct UndoCommand: CommandProtocol {
  let verb = "undo"
  let function = "Un-complete tasks by ID"
  var manager: () throws -> TaskManager

  init(manager: @autoclosure @escaping () throws -> TaskManager) {
    self.manager = manager
  }

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      var manager = try self.manager()
      let update = { (task: Task) in
        task.updating(done: false)
      }

      if options.markAll {
        try manager.update(by: update)
      }
      else {
        try manager.update(ids: options.ids, by: update)
      }

      manager.outstanding.forEach { print($0) }
    }
  }

  struct Options: OptionsProtocol {
    let ids: [Int]
    let markAll: Bool

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return curry(Options.init)
        <*> m <| Argument<[Int]>(usage: "A list of task IDs")
        <*> m <| Switch(flag: "a", key: "all", usage: "Complete all tasks")
    }
  }
}

