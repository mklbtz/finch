extension String: Error {
  public func print(terminator: String = "") {
    Swift.print(self, terminator: terminator)
  }
}

extension MutableCollection {
  public mutating func transform(by transforming: (Element) throws -> Element) rethrows {
    var i = startIndex
    while i != endIndex {
      self[i] = try transforming(self[i])
      i = index(after: i)
    }
  }

  public mutating func transform<S: Sequence>(at indices: S, by transforming: (Element) throws -> Element) rethrows
  where Index == S.Element {
    for index in indices {
      self[index] = try transforming(self[index])
    }
  }
}

extension RangeReplaceableCollection {
  public mutating func remove<C: RandomAccessCollection>(at indices: C) -> Self
    where C.Element == Index {
      let indices = indices.sorted(by: >)
      var removed = Self()
      for index in indices {
        let element = remove(at: index)
        removed.append(element)
      }
      return removed
  }
}

extension Sequence where Element == Task {
  public func outstanding() -> [Element] {
    return filter { !$0.done }
  }

  public func done() -> [Element] {
    return filter { $0.done }
  }
}

extension Collection where Element == Task {
  public func index(id: Int) -> Index? {
    return index(where: { id == $0.id })
  }

  public func find(id: Int) -> Task? {
    guard let index = index(id: id)
      else { return nil }
    return self[index]
  }

  public func find(ids: [Int]) -> [Task] {
    return filter { ids.contains($0.id) }
  }
}

extension BidirectionalCollection where Element == Task {
  public func sorted() -> [Task] {
    return sorted { $0.id < $1.id }
  }
}
