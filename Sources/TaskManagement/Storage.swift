import Foundation

public struct Storage<Stored> {
  public let path: String
  let transcoder: Transcoder<Stored, Data>

  public init(atPath path: String, transcoder: Transcoder<Stored, Data>) {
    self.path = path
    self.transcoder = transcoder
  }
}

extension Storage {
  public func load() throws -> Stored {
    return try withNiceErrors { try transcoder.decode(file.load()) }
  }

  public func save(_ stored: Stored) throws {
    return try withNiceErrors { try file.save(transcoder.encode(stored)) }
  }

  var file: File {
    return File(atPath: path)
  }

  private func withNiceErrors<A>(_ run: () throws -> A) rethrows -> A {
    do {
      return try run()
    }
    catch let error as NSError {
      throw error.localizedDescription
    }
  }
}

public typealias TaskStorage = Storage<[Task]>

public func taskStorage() -> TaskStorage {
  return TaskStorage(atPath: ".todo.json", transcoder: .taskToJson + .jsonToData)
}

public typealias StringStorage = Storage<String>

public func stringStorage(atPath path: String) -> StringStorage {
  return StringStorage(atPath: path, transcoder: .stringToData)
}
