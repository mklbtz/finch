import TaskManagement

func buildTask(id: Int = 0, title: String = "default", done: Bool = false) -> Task {
  return Task(id: id, title: title, done: done)
}
