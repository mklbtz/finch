import Foundation

public struct Storage<Stored> {
  public let path: String
  public let defaultValue: Stored?
  let transcoder: Transcoder<Stored, Data>

  public init(atPath path: String, default: Stored? = nil, transcoder: Transcoder<Stored, Data>) {
    self.path = path
    self.transcoder = transcoder
    self.defaultValue = `default`
  }
}

extension Storage {
  public func load() throws -> Stored {
    return try withNiceErrors {
      do {
        let input = try file.load()
        return try transcoder.decode(input)
      }
      catch File.Error.couldNotRead(let file) {
        if let defaultValue = defaultValue {
          return defaultValue
        } else {
          throw File.Error.couldNotRead(file)
        }
      }
    }
  }

  public func save(_ stored: Stored) throws {
    return try withNiceErrors {
      let output = try transcoder.encode(stored)
      try file.save(output)
    }
  }

  var file: File {
    return File(atPath: path)
  }

  private func withNiceErrors<A>(_ run: () throws -> A) rethrows -> A {
    do {
      return try run()
    }
    catch let error as NSError {
      print("caught NSError")
      throw error.localizedDescription
    }
  }
}

public func TaskStorage() -> Storage<[Task]> {
  return .init(atPath: ".todo", default: [], transcoder: JSONTranscoder())
}

public func StringStorage(atPath path: String) -> Storage<String> {
  return .init(atPath: path, transcoder: StringTranscoder())
}
