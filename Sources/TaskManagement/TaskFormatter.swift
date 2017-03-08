public struct TaskFormatter {
  let task: Task
  let padCount: UInt

  public init(for task: Task, padding padCount: UInt = 0) {
    self.task = task
    self.padCount = padCount
  }
}

extension TaskFormatter: CustomStringConvertible {
  public func print() {
    Swift.print(description)
  }

  public var description: String {
    return padding + checkbox + id + title
  }

  private var checkbox: String {
    return task.done ? checkmark : whiteCircle
  }

  private var id: String {
    return "\(task.id). "
  }

  private var title: String {
    return task.title
  }

  private var padding: String {
    return String(repeating: " ", count: Int(padCount))
  }

  private var checkmark: String { return " ✓ " }
  private var whiteCircle: String { return " ◦ " }
  private var blackCircle: String { return " ● " }
}

