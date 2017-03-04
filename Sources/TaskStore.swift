import Foundation

public struct TaskStore {
  fileprivate let store: ObjectStore

  public init(at path: String) {
    self.store = ObjectStore(at: path)
  }

  public var path: String {
    return store.path
  }
}

// Default Store and Location
extension TaskStore {
  public static var `default` = TaskStore(at: defaultFilePath)

  public static var defaultFilePath: String {
    return FileManager.default.currentDirectoryPath + "/.todo"
  }
}

// Reading and Writing NodeRepresentable Objects
extension TaskStore {
  public func load() throws -> [Task] {
    return try store.load().flatMap(Task.init(from:))
  }

  @discardableResult
  public func save(_ tasks: [Task]) throws -> String {
    return try store.save(tasks)
  }
}
