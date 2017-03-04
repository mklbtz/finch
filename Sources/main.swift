import Commander
import Foundation
import Yams

func readAllLines() -> AnyIterator<String> {
  return AnyIterator { return readLine(strippingNewline: false) }
}

Group { root in
  root.command("add") { (title: String) in
    var taskList = try TaskStore.default.load()
    let task = Task(id: taskList.count, title: title)
    taskList.append(task)
    dump(task)
    try TaskStore.default.save(taskList)
  }

  root.command("rm") { (id: Int) in
    var taskList = try TaskStore.default.load()
    guard let index = taskList.index(where: { $0.id == id })
    else { exit(1) }

    let removed = taskList.remove(at: index)
    dump(removed)
    try TaskStore.default.save(taskList)
  }

  root.command("ls") {
    let taskList = try TaskStore.default.load()
    dump(taskList)
  }

  root.group("yaml") { group in
    group.command("read") {
      let file = YamlFile(at: TaskStore.defaultFilePath)
      print(try file.read())
    }

    group.command("write") {
      let file = YamlFile(at: TaskStore.defaultFilePath)
      let yaml = readAllLines().joined()
      try file.write(yaml: yaml)
    }
  }
}.run()
