extension String: Error {
  public func print(terminator: String = "") {
    Swift.print(self, terminator: terminator)
  }
}

public protocol Stored {
  var id: Int { get }
}

extension Task: Stored {}

extension Array where Element: Stored {
  public func nextId() -> Int {
    let max = self.max(by: { $0.id < $1.id })?.id ?? 0
    return 1 + max
  }

  public func index(id: Int) throws -> Index {
    if let index = index(where: { id == $0.id }) {
      return index
    } else {
      throw "Could not find id: \(id)."
    }
  }

  public func find(id: Int) throws -> Element {
    return try self[index(id: id)]
  }

  mutating
  public func remove(id: Int) throws -> Element {
        return try remove(at: index(id: id))
  }

  mutating
  public func update(id: Int, by change: (inout Element) throws -> ()) throws {
    let index = try self.index(id: id)
    var task = self[index]
    try change(&task)
    self[index] = task
  }
}

