import Commandant
import TaskManagement

let commands = CommandRegistry<String>()

commands.register(ReadCommand(with: StringStorage()))
commands.register(WriteCommand(with: StringStorage()))
commands.register(PathCommand(with: StringStorage()))
commands.register(HelpCommand(registry: commands))

commands.main(defaultVerb: "help") { error in
  print(error)
}
