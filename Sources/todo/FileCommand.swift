import Commandant
import Foundation
import TaskManagement
import Result

struct FileCommand: CommandProtocol {
  let verb = "file"
  let function = "List outstanding tasks"

  func run(_ options: Options) -> Result<Void, String> {
    return Result {
      if options.writing {
        let input = readAllLines().joined(separator: "\n")
        try jsonStorage.save(input)
      } else if options.getPath {
        print(jsonStorage.path)
      } else {
        try jsonStorage.load().print()
      }
    }
  }

  private var jsonStorage: Storage<String> {
    return StringStorage(atPath: TaskStorage().path)
  }

  private func readAllLines() -> AnyIterator<String> {
    return AnyIterator { return readLine() }
  }

  struct Options: OptionsProtocol {
    let writing: Bool
    let getPath: Bool

    static func evaluate(_ m: CommandMode) -> Result<Options, CommandantError<String>> {
      return curry(Options.init)
        <*> m <| Switch(key: "write", usage: "Write stdin to file instead")
        <*> m <| Switch(key: "path", usage: "Print path to file instead")
    }
  }
}
