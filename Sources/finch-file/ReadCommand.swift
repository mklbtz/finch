import Commandant
import Result

struct ReadCommand: CommandProtocol {
  typealias Options = NoOptions<String>

  let verb = "read"
  let function = "Read task storage file"

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      try FileStorage().load().print()
    }
  }
}

