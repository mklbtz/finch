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

// Reading and Writing NodeRepresentable Objects
extension ObjectStore {
  public func load() throws -> [Node] {
    let node = try Yams.load(yaml: file.read()).represented()
    switch node {
    case .sequence(let nodeList, _, _):
      return nodeList
    default:
      throw "Expected to read sequence but got: \(node)"
    }
  }

  @discardableResult
  public func save<T: NodeRepresentable>(_ objects: [T]) throws -> String {
    let yaml = try Yams.dump(object: objects.represented())
    try file.write(yaml: yaml)
    return yaml
  }
}
