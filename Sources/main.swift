import Foundation
import Commander

let main = Group {
  $0.command("add") { (title: String) in
    print("Added task: 1. \(title)")
  }

  $0.command("rm") { (id: Int) in
    if id == 1 {
      print("Removed task 1.")
    } else {
      print("No task 1.")
    }
  }

  $0.command("read") {
    let manager = DataManager()
    do {
      let data = try manager.read()
      print("Read data: ", data)
    } catch let error {
      print(error)
    }
  }

  $0.command("write") {
    let manager = DataManager()
    let data = Data(bytes: [1,2,3,4,5])
    do { try manager.write(data: data) }
    catch let error { print(error) }
  }
}

main.run()
