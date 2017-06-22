import Commandant
import Foundation
import TaskManagement
import Result

struct AddCommand: CommandProtocol {
  let verb = "add"
  let function = "Create a new task"

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      guard !options.title.isEmpty
        else { throw "Provide a non-empty title for the task" }
      var manager = try TaskManager()
      let task = try manager.add(title: options.title)
      print(task)
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
