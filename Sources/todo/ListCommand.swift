import Commandant
import Foundation
import TaskManagement
import Result

struct ListCommand: CommandProtocol {
  let verb = "ls"
  let function = "List outstanding tasks"

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      let manager = try TaskManager()
      let tasks = options.showAll ? manager.all : manager.outstanding
      tasks.forEach { print($0) }
    }
  }

  struct Options: OptionsProtocol {
    let showAll: Bool

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return Options.init <*> m <| all
    }

    static var all: Switch {
      return Switch(flag: "a", key: "all", usage: "Include completed tasks")
    }
  }
}

