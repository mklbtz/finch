public struct TaskManager {
  public private(set) var all: [Task]
  private let storage = TaskStorage()

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

  public func find(ids: [Int]) -> [Task] {
    return all.filter { ids.contains($0.id) }
  }

  public mutating func add(title: String) throws -> Task {
    let id = nextId()
    let task = Task(id: id, title: title)
    all.append(task)
    try storage.save(all)
    return task
  }

  @discardableResult
  public mutating func removeAll() throws -> [Task] {
    let removed = all
    all = []
    try storage.save(all)
    return removed
  }

  @discardableResult
  public mutating func remove(ids: [Int]) throws -> [Task] {
    let removed = all.remove(at: indices(ids: ids))
    try storage.save(all)
    return removed
  }

  @discardableResult
  public mutating func update(ids: [Int], by changing: (Task) -> (Task)) throws {
    guard !ids.isEmpty else { return }
    let indices = self.indices(ids: ids)
    all.transform(at: indices, by: changing)
    try storage.save(all)
  }

  @discardableResult
  public mutating func update(by changing: (Task) -> (Task)) throws {
    all.transform(by: changing)
    try storage.save(all)
  }

  private func nextId() -> Int {
    let max = all.max(by: { $0.id < $1.id })?.id ?? 0
    return 1 + max
  }

  private func index(id: Int) throws -> Int {
    if let index = all.index(where: { id == $0.id }) {
      return index
    }
    else {
      throw "Could not find id: \(id)."
    }
  }

  private func indices(ids: [Int]) -> [Int] {
    var indices: [Int] = []
    for (index, task) in all.enumerated() {
      if ids.contains(task.id) {
        indices.append(index)
      }
    }
    return indices
  }
}
