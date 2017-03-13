import Commander
import Foundation
import TaskManagement

func readAllLines() -> AnyIterator<String> {
  return AnyIterator { return readLine(strippingNewline: false) }
}

DefaultableGroup {
  let root = $0 as! DefaultableGroup

  root.defaultCommand {
    let taskList = try taskStorage().load().filter { !$0.done }
    for task in taskList {
      TaskFormatter(for: task).print()
    }
  }
  root.command("add") { (title: String) in
    var taskList: [Task]
    do {
      taskList = try taskStorage().load()
    } catch File.Error.couldNotRead(_) {
      taskList = []
    }
    let id = taskList.nextId()
    let task = Task(id: id, title: title)
    taskList.append(task)
    try taskStorage().save(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("rm") { (id: Int) in
    var taskList: [Task]
    do {
      taskList = try taskStorage().load()
    } catch File.Error.couldNotRead(_) {
      taskList = []
    }
    let task = try taskList.remove(id: id)
    try taskStorage().save(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("ls", Flag("all", flag: "a", description: "show all tasks")) { showAll in
    let taskList: [Task]
    do {
      taskList = try taskStorage().load().filter { showAll || !$0.done }
    } catch File.Error.couldNotRead(_) {
      taskList = []
    }

    for task in taskList {
      TaskFormatter(for: task).print()
    }
  }

  root.command("done") { (id: Int) in
    var taskList: [Task]
    do {
      taskList = try taskStorage().load()
    } catch File.Error.couldNotRead(_) {
      taskList = []
    }
    try taskList.update(id: id) { task in
      task.done = true
      TaskFormatter(for: task).print()
    }
    try taskStorage().save(taskList)
  }

  root.group("file") { group in
    var jsonStorage: StringStorage {
      return stringStorage(atPath: ".todo.json")
    }

    group.command("read") {
      try jsonStorage.load().print()
    }

    group.command("write") {
      let input = readAllLines().joined()
      try jsonStorage.save(input)
    }
  }
}.run()
