import Commander
import Foundation
import Yams

Group {
  $0.command("add") { (title: String) in
    let task = Task(id: 0, title: title)
    let yaml = try ObjectStore.default.write(objects: [task])
    print(yaml)
  }

  $0.command("rm") { (id: Int) in
    if id == 1 {
      print("Removed task 1.")
    }
    else {
      print("No task 1.")
    }
  }

  $0.command("ls") {
    let objects: [Node] = try ObjectStore.default.read()
    for (index, node) in objects.enumerated() {
      print("\(index): \(node)")
    }
  }

  $0.command("read") {
    let file = DataFile(at: ObjectStore.defaultFilePath)
    do {
      let data = try file.read()
      print("Read data:", data)
    }
    catch let error {
      print(error)
    }
  }

  $0.command("write") {
    let file = DataFile(at: ObjectStore.defaultFilePath)
    let data = Data(bytes: [1,2,3,4,5])
    do { try file.write(data: data) }
    catch let error { print(error) }
  }
}.run()
