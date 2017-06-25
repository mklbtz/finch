import Commandant
import TaskManagement

func FileStorage() -> Storage<String> {
  return StringStorage()
}

let commands = CommandRegistry<String>()

commands.register(ReadCommand())
commands.register(WriteCommand())
commands.register(PathCommand())
commands.register(HelpCommand(registry: commands))

commands.main(defaultVerb: "help") { error in
  print(error)
}

