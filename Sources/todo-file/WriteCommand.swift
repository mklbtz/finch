import Commandant
import Result

struct WriteCommand: CommandProtocol {
  typealias Options = NoOptions<String>

  let verb = "write"
  let function = "Write stdin to task storage file"

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      let input = readAllLines().joined(separator: "\n")
      try jsonStorage.save(input)
    }
  }

  private func readAllLines() -> AnyIterator<String> {
    return AnyIterator { return readLine() }
  }
}
