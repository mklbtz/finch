import Foundation
import Yams

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
