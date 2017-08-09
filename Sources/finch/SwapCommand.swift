import Commandant
import Foundation
import TaskManagement
import Result

struct SwapCommand: CommandProtocol {
  let verb = "swap"
  let function = "Swap the IDs of two tasks."
  var manager: () throws -> TaskManager

  init(manager: @autoclosure @escaping () throws -> TaskManager) {
    self.manager = manager
  }

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      var manager = try self.manager()
      var a = try find(id: options.a, in: manager)
      var b = try find(id: options.b, in: manager)
      (a.id, b.id) = (b.id, a.id)
      try manager.upsert(a)
      try manager.upsert(b)
      [a, b].sorted().forEach { print($0) }
    }
  }

  private func find(id: Int, in manager: TaskManager) throws -> Task {
    if let task = manager.find(id: id) {
      return task
    } else {
      throw "Not a valid ID: \(id)"
    }
  }

  struct Options: OptionsProtocol {
    let a: Int
    let b: Int

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return curry(Options.init)
        <*> m <| Argument<Int>(usage: "The ID for task A")
        <*> m <| Argument<Int>(usage: "The ID for task B")
    }
  }
}

