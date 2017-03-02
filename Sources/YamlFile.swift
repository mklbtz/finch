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
