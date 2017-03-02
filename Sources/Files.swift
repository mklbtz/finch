import Foundation

/// Provides access to a file as a String of YAML.
public struct YamlFile {
  fileprivate let file: DataFile

  public init(at path: String) {
    self.file = DataFile(at: path)
  }

  public var path: String {
    return file.path
  }

  public func read() throws -> String {
    let data = try file.read()
    guard let yaml = String(data: data, encoding: .utf8)
    else { throw "Could not decode data \(data)" }
    return yaml
  }

  public func write(yaml: String) throws {
    let data = yaml.data(using: .utf8)!
    try file.write(data: data)
  }
}

/// Provides access to a file as Data.
public struct DataFile {
  public var path: String

  public init(at path: String) {
    self.path = path
  }

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
