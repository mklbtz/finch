import Commandant
import Foundation
import TaskManagement
import Result

struct EditCommand: CommandProtocol {
  let verb = "edit"
  let function = "Change the title of a task."
  var manager: () throws -> TaskManager

  init(manager: @autoclosure @escaping () throws -> TaskManager) {
    self.manager = manager
  }

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      var manager = try self.manager()
      try manager.update(ids: [options.id]) {
        let updated = $0.updating(title: options.title)
        print(updated)
        return updated
      }
    }
  }

  struct Options: OptionsProtocol {
    let id: Int
    let title: String

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return curry(Options.init)
        <*> m <| Argument<Int>(usage: "The task ID")
        <*> m <|* Argument<String>(usage: "The title for the new task")
    }
  }
}

