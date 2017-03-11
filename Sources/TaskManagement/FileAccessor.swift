import Foundation

public protocol FileAccessor {
  associatedtype Format

  func read() throws -> Format
  func write(_: Format) throws
}

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

public struct FileTransform<File, OutputFormat> where File: FileAccessor {
  let file: File
  let reader: (File.Format) throws -> OutputFormat
  let writer: (OutputFormat) throws -> (File.Format)
}

extension FileTransform: FileAccessor {
  public func read() throws -> OutputFormat {
    return try reader(file.read())
  }

  public func write(_ object: OutputFormat) throws {
    try file.write(writer(object))
  }
}
