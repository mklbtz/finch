import Commander
import Foundation

public final class DefaultableGroup: Group {
  var defaultCommand: CommandType? = nil

  open func defaultCommand(_ closure: @escaping () throws -> ()) {
    self.defaultCommand = Commander.command { try closure() }
  }


  override public func run(_ parser: ArgumentParser) throws {
    do {
      try super.run(parser)
    } catch GroupError.noCommand(let path, let group) {
      guard let command = self.defaultCommand
      else { throw GroupError.noCommand(path, group) }
      try command.run(parser)
    }
  }
}
