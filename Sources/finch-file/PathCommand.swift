import Commandant
import Result
import TaskManagement

struct PathCommand: CommandProtocol {
  typealias Options = NoOptions<String>

  let verb = "path"
  let function = "Print path to task storage file"
  var fileStorage: () -> Storage<String>

  init(with storage: @autoclosure @escaping () -> Storage<String>) {
    fileStorage = storage
  }

  func run(_ options: Options) -> Result<Void, String> {
    print(fileStorage().path)
    return .success(())
  }
}
