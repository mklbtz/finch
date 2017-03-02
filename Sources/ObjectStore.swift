import Foundation
import Yams

/// Provides access to a yaml file of NodeRepresentable objects.
public struct ObjectStore {
  fileprivate let file: YamlFile

  public init(at path: String) {
    self.file = YamlFile(at: path)
  }

  public var path: String {
    return file.path
  }
}

// Default Store and Location
extension ObjectStore {
  public static var `default` = ObjectStore(at: defaultFilePath)

  public static var defaultFilePath: String {
    return FileManager.default.currentDirectoryPath + "/.todo"
  }
}

// Reading and Writing NodeRepresentable Objects
extension ObjectStore {
  public func read() throws -> [Node] {
    let node = try load(yaml: file.read()).represented()
    switch node {
    case .sequence(let nodeList, _, _):
      return nodeList
    default:
      throw "Expected to read sequence but got: \(node)"
    }
  }

  @discardableResult
  public func write<T: NodeRepresentable>(objects: [T]) throws -> String {
    let yaml = try dump(object: objects.represented())
    try file.write(yaml: yaml)
    return yaml
  }
}
