import Commandant
import Foundation
import TaskManagement
import Result

struct AddCommand: CommandProtocol {
  let verb = "add"
  let function = "Create a new task"

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      var manager = try TaskManager()
      let task = try manager.add(title: options.title)
      print(task)
    }
  }

  struct Options: OptionsProtocol {
    let title: String

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return Options.init <*> m <|* title
    }

    static var title: Argument<String> {
      return .init(usage: "The title for the new task")
    }
  }
}