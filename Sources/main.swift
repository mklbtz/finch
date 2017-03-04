import Commander
import Foundation
import Yams

func readAllLines() -> AnyIterator<String> {
  return AnyIterator { return readLine(strippingNewline: false) }
}

Group { root in
  root.command("add") { (title: String) in
    var taskList = try taskListFile.read()
    let task = Task(id: taskList.count, title: title)
    taskList.append(task)
    dump(task)
    try taskListFile.write(taskList)
  }

  root.command("rm") { (id: Int) in
    var taskList = try taskListFile.read()
    guard let index = taskList.index(where: { $0.id == id })
    else { exit(1) }

    let removed = taskList.remove(at: index)
    dump(removed)
    try taskListFile.write(taskList)
  }

  root.command("ls") {
    let taskList = try taskListFile.read()
    dump(taskList)
  }

  root.command("fin") { (id: Int) in
    var taskList = try taskListFile.read()
    guard let index = taskList.index(where: { $0.id == id })
    else { exit(1) }

    var task = taskList[index]
    task.done = true
    dump(task)

    taskList[index] = task
    try taskListFile.write(taskList)
  }

  root.group("yaml") { group in
    group.command("read") {
      print(try todoYamlFile.read())
    }

    group.command("write") {
      let yaml = readAllLines().joined()
      try todoYamlFile.write(yaml)
    }
  }
}.run()
