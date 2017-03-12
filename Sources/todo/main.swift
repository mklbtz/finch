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
    let taskList = try taskStorage().load()
    for task in taskList {
      TaskFormatter(for: task).print()
    }
  }
  root.command("add") { (title: String) in
    var taskList = try taskStorage().load()
    let id = taskList.nextId()
    let task = Task(id: id, title: title)
    taskList.append(task)
    try taskStorage().save(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("rm") { (id: Int) in
    var taskList = try taskStorage().load()
    let task = try taskList.remove(id: id)
    try taskStorage().save(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("ls") {
    let taskList = try taskStorage().load()
    for task in taskList {
      TaskFormatter(for: task).print()
    }
  }

  root.command("done") { (id: Int) in
    var taskList = try taskStorage().load()
    try taskList.update(id: id) { task in
      task.done = true
      TaskFormatter(for: task).print()
    }
    try taskStorage().save(taskList)
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
