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
    let taskList = try taskListFile.read()
    for task in taskList {
      TaskFormatter(for: task).print()
    }
  }
  root.command("add") { (title: String) in
    var taskList = try taskListFile.read()
    let id = taskList.nextId()
    let task = Task(id: id, title: title)
    taskList.append(task)
    try taskListFile.write(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("rm") { (id: Int) in
    var taskList = try taskListFile.read()
    let task = try taskList.remove(id: id)
    try taskListFile.write(taskList)
    TaskFormatter(for: task).print()
  }

  root.command("ls") {
    let taskList = try taskListFile.read()
    for task in taskList {
      TaskFormatter(for: task).print()
    }
  }

  root.command("done") { (id: Int) in
    var taskList = try taskListFile.read()
    try taskList.update(id: id) { task in
      task.done = true
      TaskFormatter(for: task).print()
    }
    try taskListFile.write(taskList)
  }

  root.group("yaml") { group in
    group.command("read") {
      try todoYamlFile.read().print()
    }

    group.command("write") {
      let yaml = readAllLines().joined()
      try todoYamlFile.write(yaml)
    }
  }
}.run()
