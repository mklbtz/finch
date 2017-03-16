import Commander
import Foundation

public final class DefaultGroup: Group {
  var theDefaultCommand: SubCommand? = nil

  /// Set the named default command
  open func setDefaultCommand(_ name: String, _ command: CommandType) {
    theDefaultCommand = SubCommand(name: name, description: nil, command: command)
  }

  /// Set the named default command with a description
  open func setDefaultCommand(_ name: String, _ description: String?, _ command: CommandType) {
    theDefaultCommand = SubCommand(name: name, description: description, command: command)
  }

  override public func run(_ parser: ArgumentParser) throws {
    do {
      try super.run(parser)
    }
    catch GroupError.noCommand(let path, let group) {
      if parser.isEmpty, let command = self.theDefaultCommand?.command {
        try command.run(parser)
      }
      else {
        throw GroupError.noCommand(path, group)
      }
    }
  }
}

extension DefaultGroup {
  public func defaultCommand(_ name: String, description:String? = nil, _ closure:@escaping () throws -> ()) {
    setDefaultCommand(name, description, Commander.command(closure))
  }
}
