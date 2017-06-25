import Commandant
import Result
import TaskManagement

struct WriteCommand: CommandProtocol {
  typealias Options = NoOptions<String>

  let verb = "write"
  let function = "Write stdin to task storage file"
  var fileStorage: () -> Storage<String>

  init(with storage: @autoclosure @escaping () -> Storage<String>) {
    fileStorage = storage
  }

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      let input = readAllLines().joined(separator: "\n")
      try fileStorage().save(input)
    }
  }

  private func readAllLines() -> AnyIterator<String> {
    return AnyIterator { return readLine() }
  }
}
