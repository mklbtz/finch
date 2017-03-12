import Foundation

public struct File {
  public let path: String

  public init(atPath path: String) {
    self.path = path
  }

  public func atPath(_ path: String) -> File {
    return File(atPath: path)
  }
}

extension File {
  public func load() throws -> Data {
    if let data = manager.contents(atPath: path) {
      return data
    } else {
      throw Error.couldNotRead(self)
    }
  }

  public func save(_ data: Data) throws {
    guard manager.createFile(atPath: path, contents: data)
    else { throw Error.couldNotCreate(self) }
  }

  private var manager: FileManager {
    return FileManager.default
  }
}

extension File {
  enum Error: Swift.Error {
    case couldNotCreate(File)
    case couldNotRead(File)
  }
}

extension File.Error: CustomStringConvertible {
  public var description: String {
    switch self {
    case .couldNotCreate(let file):
      return "Could not create file at \(file.path)"
    case .couldNotRead(let file):
      return "Could not reaed file at \(file.path)"
    }
  }
}
