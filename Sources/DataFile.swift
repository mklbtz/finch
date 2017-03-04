import Foundation

public struct DataFile {
  public var path: String

  public init(at path: String) {
    self.path = path
  }
}

extension DataFile: FileAccessor {
  public func read() -> Data {
    return FileManager.default.contents(atPath: path) ?? Data()
  }

  public func write(_ data: Data) throws {
    guard FileManager.default.createFile(atPath: path, contents: data)
    else { throw "Could not write data (\(data)) to file \(path)" }
  }
}
