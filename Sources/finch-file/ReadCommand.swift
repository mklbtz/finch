import Commandant
import Result
import TaskManagement

struct ReadCommand: CommandProtocol {
  typealias Options = NoOptions<String>

  let verb = "read"
  let function = "Read task storage file"
  var fileStorage: () -> Storage<String>

  init(with storage: @autoclosure @escaping () -> Storage<String>) {
    fileStorage = storage
  }

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      try fileStorage().load().print()
    }
  }
}
