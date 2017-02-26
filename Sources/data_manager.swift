import Foundation

public struct DataManager {
  public init() {}

  public
  func read() throws -> Data {
    guard let data = fileManager.contents(atPath: dataPath)
    else { throw "Could not read file \(dataPath)" }
    return data
    }

  public
  func write(data: Data) throws {
    guard fileManager.createFile(atPath: dataPath, contents: data)
    else { throw "Could not write data (\(data)) to file \(dataPath)" }
  }
}

extension DataManager {
  fileprivate
  var dataPath: String {
    return currentDirectory + "/.todo"
  }

  fileprivate
  var currentDirectory: String {
    return fileManager.currentDirectoryPath
  }

  fileprivate
  var fileManager: FileManager {
    return FileManager.default
  }
}
