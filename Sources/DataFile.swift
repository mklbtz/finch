import Foundation

public struct DataFile {
  public var path: String

  public init(at path: String) {
    self.path = path
  }
}

extension DataFile {
  public func read() throws -> Data {
    guard let data = FileManager.default.contents(atPath: path)
    else { throw "Could not read file \(path)" }
    return data
  }

  public func write(data: Data) throws {
    guard FileManager.default.createFile(atPath: path, contents: data)
    else { throw "Could not write data (\(data)) to file \(path)" }
  }
}
