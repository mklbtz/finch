import Commandant
import Foundation
import TaskManagement
import Result

struct AddCommand: CommandProtocol {
  let verb = "add"
  let function = "Create a new task"
  var manager: () throws -> TaskManager

  init(manager: @autoclosure @escaping () throws -> TaskManager) {
    self.manager = manager
  }

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      try validateTitle(options.title)
      var manager = try self.manager()
      let task = try manager.add(title: options.title)
      print(task)
    }
  }

  private func validateTitle(_ title: String) throws -> Void {
    guard !title.isEmpty else {
      throw "Provide a non-empty title for the task"
    }
  }

  struct Options: OptionsProtocol {
    let title: String

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return Options.init
        <*> m <|* Argument<String>(usage: "The title for the new task")
    }
  }
}
