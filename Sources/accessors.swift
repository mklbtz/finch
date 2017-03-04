import Foundation
import Yams

let todoDataFile = DataFile(at: ".todo")

let todoYamlFile =
  FileTransform(file: todoDataFile,
                reader: { String(data: $0, encoding: .utf8) ?? "" },
                writer: { $0.data(using: .utf8) ?? Data() })

let todoNodeFile =
  FileTransform(file: todoYamlFile,
                reader: { string in try Yams.load(yaml: string).represented() },
                writer: { node in try Yams.dump(object: node.represented()) })

let todoNodeListFile =
  FileTransform(file: todoNodeFile,
                reader: { (node: Node) -> ([Node]) in
                  guard case .sequence(let list, _, _) = node
                  else { throw "Expected sequence but got: \(node)" }
                  return list
                },
                writer: { (list: [Node]) -> Node in try list.represented() })

let taskListFile =
  FileTransform(file: todoNodeListFile,
                reader: { $0.flatMap(Task.init(from:)) },
                writer: { try $0.map { task in try task.represented() } })
