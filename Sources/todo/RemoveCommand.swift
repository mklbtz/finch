import Commandant
import Foundation
import TaskManagement
import Result

struct RemoveCommand: CommandProtocol {
  let verb = "rm"
  let function = "Remove tasks by ID"

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      var manager = try TaskManager()
      let tasks: [Task]

      if options.removeAll {
        tasks = try manager.removeAll()
      }
      else {
        tasks = try manager.remove(ids: options.ids)
      }

      tasks.forEach { print($0) }
    }
  }

  struct Options: OptionsProtocol {
    let ids: [Int]
    let removeAll: Bool

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      let create = curry(Options.init)
      return create
        <*> m <| ids
        <*> m <| Switch(flag: "a", key: "all", usage: "Remove all tasks")
    }

    static var ids: Argument<[Int]> {
      return .init(usage: "A list of task IDs")
    }

    static var removeAll: Switch {
      return .init(flag: "a", key: "all", usage: "Remove all tasks")
    }
  }
}
