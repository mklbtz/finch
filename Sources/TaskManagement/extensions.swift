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
