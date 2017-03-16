import Commander
import Foundation
import TaskManagement

DefaultGroup {
  let root = $0 as! DefaultGroup

  root.defaultCommand("ls") {
    try TaskManager().outstanding.forEach { print($0) }
  }

  root.command("ls", Flag.all("Include completed tasks"), description: "List tasks") { showAll in
    let manager = try TaskManager()
    (showAll ? manager.all : manager.outstanding).forEach { print($0) }
  }

  root.command("add", description: "Add new task") { (title: String) in
    var manager = try TaskManager()
    let task = try manager.add(title: title)
    print(task)
  }

  root.command("rm", description: "Remove a task by ID") { (id: Int) in
    var manager = try TaskManager()
    let task = try manager.remove(id: id)
    print(task)
  }

  root.command("do", description: "Mark a task as complete") { (id: Int) in
    var manager = try TaskManager()
    try manager.update(id: id) { task in
      task.done = true
      print(task)
    }
  }

  // Subgroup for accessing file contents directly.
  root.group("file") { group in
    var jsonStorage: Storage<String> {
      return StringStorage(atPath: TaskStorage().path)
    }

    func readAllLines() -> AnyIterator<String> {
      return AnyIterator { return readLine(strippingNewline: false) }
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
