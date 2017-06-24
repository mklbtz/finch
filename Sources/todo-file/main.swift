import Commandant
import TaskManagement

var jsonStorage: Storage<String> {
  return StringStorage(atPath: TaskStorage().path)
}

let commands = CommandRegistry<String>()

commands.register(ReadCommand())
commands.register(WriteCommand())
commands.register(PathCommand())
commands.register(HelpCommand(registry: commands))

commands.main(defaultVerb: "help") { error in
  print(error)
}

