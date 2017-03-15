import Commander
import Foundation
import TaskManagement

func readAllLines() -> AnyIterator<String> {
  return AnyIterator { return readLine(strippingNewline: false) }
}

DefaultableGroup {
  let root = $0 as! DefaultableGroup

  root.defaultCommand {
    try TaskManager().outstanding.forEach { print($0) }
  }

  root.command("ls", Flag("all", flag: "a")) { showAll in
    let manager = try TaskManager()
    (showAll ? manager.all : manager.outstanding).forEach { print($0) }
  }

  root.command("add") { (title: String) in
    var manager = try TaskManager()
    let task = try manager.add(title: title)
    print(task)
  }

  root.command("rm") { (id: Int) in
    var manager = try TaskManager()
    let task = try manager.remove(id: id)
    print(task)
  }

  root.command("done") { (id: Int) in
    var manager = try TaskManager()
    try manager.update(id: id) { task in
      task.done = true
      print(task)
    }
  }

  root.group("file") { group in
    var jsonStorage: StringStorage {
      return stringStorage(atPath: taskStorage().path)
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
