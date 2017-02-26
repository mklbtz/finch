import Foundation

public struct DataManager {
  public var dataPath: String

  public
  init(dataPath: String = defaultDataPath) {
    self.dataPath = dataPath
  }

  public
  func read() throws -> Data {
    guard let data = FileManager.default.contents(atPath: dataPath)
    else { throw "Could not read file \(dataPath)" }
    return data
  }

  public
  func write(data: Data) throws {
    guard FileManager.default.createFile(atPath: dataPath, contents: data)
    else { throw "Could not write data (\(data)) to file \(dataPath)" }
  }
}

extension DataManager {
  fileprivate
  static var defaultDataPath: String {
    return FileManager.default.currentDirectoryPath + "/.todo"
  }
}
