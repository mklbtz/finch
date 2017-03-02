import Commander
import Foundation
import Yams

func readAllLines() -> AnyIterator<String> {
  return AnyIterator { return readLine(strippingNewline: false) }
}

Group { root in
  root.command("add") { (title: String) in
    let task = Task(id: 0, title: title)
    let yaml = try ObjectStore.default.write(objects: [task])
    print(yaml)
  }

  root.command("rm") { (id: Int) in
    if id == 1 {
      print("Removed task 1.")
    }
    else {
      print("No task 1.")
    }
  }

  root.command("ls") {
    let objects: [Node] = try ObjectStore.default.read()
    for (index, node) in objects.enumerated() {
      print("\(index): \(node)")
    }
  }

  root.group("yaml") { group in
    group.command("read") {
      let file = YamlFile(at: ObjectStore.defaultFilePath)
      print(try file.read())
    }

    group.command("write") {
      let file = YamlFile(at: ObjectStore.defaultFilePath)
      let yaml = readAllLines().joined()
      try file.write(yaml: yaml)
    }
  }
}.run()
