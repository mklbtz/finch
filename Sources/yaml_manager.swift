import Foundation
import Yams

public struct YamlManager {
  fileprivate let manager: DataFile

  public init(filePath: String) {
    self.manager = DataFile(at: filePath)
  }

  public var filePath: String {
    return manager.path
  }
}

extension YamlManager {
  public func read() throws -> String {
    let data = try manager.read()
    guard let yaml = String(data: data, encoding: .utf8)
    else { throw "Could not decode data \(data)" }
    return yaml
  }


  public func write(yaml: String) throws {
    let data = yaml.data(using: .utf8)!
    try manager.write(data: data)
  }
}

extension YamlManager {
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

extension YamlManager {
  public static var `default` = YamlManager(filePath: defaultFilePath)

  public static var defaultFilePath: String {
    return FileManager.default.currentDirectoryPath + "/.todo"
  }
}
