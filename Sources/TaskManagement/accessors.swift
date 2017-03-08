import Foundation
import Yams

public let todoDataFile = DataFile(at: ".todo")

public let todoYamlFile =
  FileTransform(file: todoDataFile,
                reader: { String(data: $0, encoding: .utf8) ?? "" },
                writer: { $0.data(using: .utf8) ?? Data() })

public let todoNodeFile =
  FileTransform(file: todoYamlFile,
                reader: { string in
                  let node = try Yams.load(yaml: string).represented()
                  if case .sequence(let nodeList, _, _) = node {
                    return nodeList
                  } else {
                    throw "Expected sequence but got: \(node)"
                  }
                },
                writer: { (nodeList: [Node]) in
                  try Yams.dump(object: nodeList.represented())
                })


public let taskListFile =
  FileTransform(file: todoNodeFile,
                reader: { $0.flatMap(Task.init(from:)) },
                writer: { try $0.map { task in try task.represented() } })
