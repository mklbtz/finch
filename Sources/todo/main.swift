import Commander
import Foundation
import TaskManagement
import Yams

func readAllLines() -> AnyIterator<String> {
  return AnyIterator { return readLine(strippingNewline: false) }
}

DefaultableGroup {
  let root = $0 as! DefaultableGroup

  root.defaultCommand {
    let taskList = try taskJSONStorage().load()
    for task in taskList {
      TaskFormatter(for: task).print()
    }
  }
  root.command("add") { (title: String) in
    var taskList: [Task]
    do {
      taskList = try taskJSONStorage().load()
    } catch File.Error.couldNotRead(_) {
      taskList = []
    }
    let id = taskList.nextId()
    let task = Task(id: id, title: title)
    taskList.append(task)
    try taskJSONStorage().save(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("rm") { (id: Int) in
    var taskList: [Task]
    do {
      taskList = try taskJSONStorage().load()
    } catch File.Error.couldNotRead(_) {
      taskList = []
    }
    let task = try taskList.remove(id: id)
    try taskJSONStorage().save(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("ls") {
    let taskList: [Task]
    do {
      taskList = try taskJSONStorage().load()
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
      taskList = try taskJSONStorage().load()
    } catch File.Error.couldNotRead(_) {
      taskList = []
    }
    try taskList.update(id: id) { task in
      task.done = true
      TaskFormatter(for: task).print()
    }
    try taskJSONStorage().save(taskList)
  }

  root.group("file") { group in
    var yamlFile: YamlStorage {
      return yamlStorage(atPath: ".todo")
    }

    group.command("read") {
      try yamlFile.load().print()
    }

    group.command("write") {
      let input = readAllLines().joined()
      try yamlFile.save(input)
    }
  }
}.run()
