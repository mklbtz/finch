extension String: Error {
  public func print(terminator: String = "") {
    Swift.print(self, terminator: terminator)
  }
}

extension Array {
  public mutating func transform(by transforming: (Element) throws -> Element) rethrows {
    for index in 0..<count {
      self[index] = try transforming(self[index])
    }
  }

  public mutating func transform<S: Sequence>(at indices: S, by transforming: (Element) throws -> Element) rethrows
  where Index == S.Iterator.Element {
    for index in indices {
      self[index] = try transforming(self[index])
    }
  }

  public mutating func remove(at indices: [Index]) -> [Element] {
    var removed: [Element] = []
    for index in indices {
      removed.append(remove(at: index))
    }
    return removed
  }
}
