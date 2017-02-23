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
}

main.run()

