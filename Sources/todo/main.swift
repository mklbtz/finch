import Commander
import Foundation
import TaskManagement

DefaultGroup {
  let root = $0 as! DefaultGroup

  root.defaultCommand("ls") {
    try TaskManager().outstanding.forEach { print($0) }
  }

  root.command(
    "ls",
    Flag.all("Include done tasks"),
    description: "List tasks")
  { showAll in
    let manager = try TaskManager()
    (showAll ? manager.all : manager.outstanding).forEach { print($0) }
  }

  root.command("add", description: "Add new task") { (title: String) in
    var manager = try TaskManager()
    let task = try manager.add(title: title)
    print(task)
  }

  root.command(
    "rm",
    Int.Args.ids(),
    Flag.all("Remove all tasks"),
    description: "Remove tasks by ID")
  { (ids, removeAll) in
    var manager = try TaskManager()
    let tasks: [Task]

    if removeAll {
      tasks = try manager.removeAll()
    }
    else {
      tasks = try manager.remove(ids: ids)
    }

    tasks.forEach { print($0) }
  }

  root.command(
    "do",
    Int.Args.ids(),
    Flag.all("Mark all tasks as done"),
    description: "Complete tasks by ID")
  { (ids, markAll) in
    var manager = try TaskManager()
    let update: ((Task) -> (Task)) throws -> ()

    if markAll {
      update = { try manager.update(by: $0) }
    }
    else {
      update = { try manager.update(ids: ids, by: $0) }
    }

    try update { task in
      var task = task
      task.done = true
      print(task)
      return task
    }
  }

  root.command(
    "edit",
    Int.Arg.id(),
    String.Arg.title(),
    description: "Change the title of a task.")
  { (id, title) in
    var manager = try TaskManager()
    try manager.update(ids: [id]) {
      let updated = $0.updating(title: title)
      print(updated)
      return updated
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
