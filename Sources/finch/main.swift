import Commandant
import Foundation
import TaskManagement

let commands = CommandRegistry<String>()

commands.register(ListCommand(manager: try TaskManager()))
commands.register(AddCommand(manager: try TaskManager()))
commands.register(RemoveCommand(manager: try TaskManager()))
commands.register(DoCommand(manager: try TaskManager()))
commands.register(UndoCommand(manager: try TaskManager()))
commands.register(EditCommand(manager: try TaskManager()))
commands.register(SwapCommand(manager: try TaskManager()))
commands.register(HelpCommand(registry: commands))

commands.main(defaultVerb: "ls") { error in
  print(error)
}
