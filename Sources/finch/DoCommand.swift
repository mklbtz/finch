import Commandant
import Foundation
import TaskManagement
import Result

struct DoCommand: CommandProtocol {
  let verb = "do"
  let function = "Complete tasks by ID"
  var manager: () throws -> TaskManager

  init(manager: @autoclosure @escaping () throws -> TaskManager) {
    self.manager = manager
  }

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      var manager = try self.manager()
      let update: ((Task) -> (Task)) throws -> ()

      if options.markAll {
        update = { try manager.update(by: $0) }
      }
      else {
        update = { try manager.update(ids: options.ids, by: $0) }
      }

      try update { task in
        var task = task
        task.done = true
        print(task)
        return task
      }
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
