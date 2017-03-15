public struct TaskManager {
  public private(set) var all: [Task]
  private let storage = taskStorage()

  public init() throws {
    self.all = try storage.load()
  }

  public var outstanding: [Task] {
    return all.filter { !$0.done }
  }

  public var done: [Task] {
    return all.filter { $0.done }
  }

  public func find(id: Int) throws -> Task {
    return try all[index(id: id)]
  }

  public mutating func add(title: String) throws -> Task {
    let id = nextId()
    let task = Task(id: id, title: title)
    all.append(task)
    try storage.save(all)
    return task
  }

  @discardableResult
  public mutating func remove(id: Int) throws -> Task {
    let removed = try all.remove(at: index(id: id))
    try storage.save(all)
    return removed
  }

  @discardableResult
  public mutating func update(id: Int, change: (inout Task) -> ()) throws -> Task {
    let index = try self.index(id: id)
    var task = all[index]
    change(&task)
    all[index] = task
    try storage.save(all)
    return task
  }

  private func nextId() -> Int {
    let max = all.max(by: { $0.id < $1.id })?.id ?? 0
    return 1 + max
  }

  private func index(id: Int) throws -> Int {
      if let index = all.index(where: { id == $0.id }) {
        return index
      } else {
        throw "Could not find id: \(id)."
      }
    }
}
