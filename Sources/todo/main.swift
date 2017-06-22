import Commandant
import Foundation
import TaskManagement

let commands = CommandRegistry<String>()

commands.register(ListCommand())
commands.register(AddCommand())
commands.register(RemoveCommand())
commands.register(DoCommand())
commands.register(EditCommand())
commands.register(FileCommand())
commands.register(HelpCommand(registry: commands))

commands.main(defaultVerb: ListCommand().verb) { error in
  print(error)
}
