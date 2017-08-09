public struct TaskManager {
  public private(set) var all: [Task]
  private let storage = TaskStorage()

  public init() throws {
    self.all = try storage.load()
  }

  public var outstanding: [Task] {
    return all.outstanding()
  }

  public var done: [Task] {
    return all.done()
  }

  public func find(id: Int) -> Task? {
    return all.find(id: id)
  }

  public func find(ids: [Int]) -> [Task] {
    return all.find(ids: ids)
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
    all.removeAll()
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
  public mutating func update(ids: [Int], by changing: (Task) -> (Task)) throws -> [Task] {
    guard !ids.isEmpty else { return [] }
    let indices = self.indices(ids: ids)
    all.transform(at: indices, by: changing)
    try storage.save(all)
    return all.filter { ids.contains($0.id) }
  }

  @discardableResult
  public mutating func update(by changing: (Task) -> (Task)) throws -> [Task] {
    all.transform(by: changing)
    try storage.save(all)
    return all
  }

  private func nextId() -> Int {
    let max = all.max(by: { $0.id < $1.id })?.id ?? 0
    return 1 + max
  }

  private func indices(ids: [Int]) -> [Int] {
    return all.enumerated()
              .filter { _, task in ids.contains(task.id) }
              .map { index, _ in index }
  }
}
