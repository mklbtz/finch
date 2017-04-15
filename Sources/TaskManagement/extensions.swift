extension String: Error {
  public func print(terminator: String = "") {
    Swift.print(self, terminator: terminator)
  }
}

extension MutableCollection {
  public mutating func transform(by transforming: (Iterator.Element) throws -> Iterator.Element) rethrows {
    var i = startIndex
    while i != endIndex {
      self[i] = try transforming(self[i])
      i = index(after: i)
    }
  }

  public mutating func transform<S: Sequence>(at indices: S, by transforming: (Iterator.Element) throws -> Iterator.Element) rethrows
  where Index == S.Iterator.Element {
    for index in indices {
      self[index] = try transforming(self[index])
    }
  }
}

extension Array {
  public mutating func remove<C: Collection>(at selected: C) -> Array
  where C.Iterator.Element == Index {
    var removed: [Element] = []
    var kept: [Element] = []
    for (i, e) in self.enumerated() {
      if selected.contains(i) {
        removed.append(e)
      }
      else {
        kept.append(e)
      }
    }
    self = kept
    return removed
  }
}
