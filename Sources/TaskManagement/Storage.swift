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
    return try transcoder.decode(file.load())
  }

  public func save(_ stored: Stored) throws {
    return try file.save(transcoder.encode(stored))
  }

  var file: File { return File(atPath: path) }
}

public typealias TaskStorage = Storage<[Task]>

public func taskStorage() -> TaskStorage {
  return TaskStorage(atPath: ".todo", transcoder: .taskToYaml + .stringToData)
}

public typealias TaskJSONStorage = Storage<[Task]>

public func taskJSONStorage() -> TaskJSONStorage {
  return TaskJSONStorage(atPath: ".todo.json", transcoder: .taskToJson + .jsonToData)
}

public typealias StringStorage = Storage<String>

public func stringStorage(atPath path: String) -> StringStorage {
  return StringStorage(atPath: path, transcoder: .stringToData)
}
