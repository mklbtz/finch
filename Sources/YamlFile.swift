import Foundation
import Yams

public struct YamlFile {
  fileprivate let file: DataFile

  public init(at path: String) {
    self.file = DataFile(at: path)
  }

  public var path: String {
    return file.path
  }
}

extension YamlFile {
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

extension YamlFile {
  public func readAny() throws -> Any {
    return try load(yaml: read()) as Any
  }

  @discardableResult
  public func write(object: Any?) throws -> String {
    let yaml = try dump(object: object)
    try write(yaml: yaml)
    return yaml
  }
}

extension YamlFile {
  public static var `default` = YamlFile(at: defaultFilePath)

  public static var defaultFilePath: String {
    return FileManager.default.currentDirectoryPath + "/.todo"
  }
}
