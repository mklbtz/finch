import Commander
import Foundation
import Yams

Group {
  $0.command("add") { (title: String) in
    let task = Task(id: 0, title: title)
    let yaml = try YamlManager.default.write(object: [task])
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
    let sequence: Any = try YamlManager.default.readAny()
    print(sequence)
    // for node in sequence {
    //   print(node)
    // }
  }

  $0.command("read") {
    let manager = DataFile(at: YamlManager.defaultFilePath)
    do {
      let data = try manager.read()
      print("Read data:", data)
    }
    catch let error {
      print(error)
    }
  }

  $0.command("write") {
    let manager = DataFile(at: YamlManager.defaultFilePath)
    let data = Data(bytes: [1,2,3,4,5])
    do { try manager.write(data: data) }
    catch let error { print(error) }
  }
}.run()
