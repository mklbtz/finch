import Commandant
import Result

struct PathCommand: CommandProtocol {
  typealias Options = NoOptions<String>

  let verb = "path"
  let function = "Print path to task storage file"

  func run(_ options: Options) -> Result<Void, String> {
    print(FileStorage().path)
    return .success(())
  }
}
