import Foundation
import Yams

public struct Transcoder<Input, Output> {
  let encoder: (Input) throws -> Output
  let decoder: (Output) throws -> (Input)

  public func encode(_ input: Input) throws -> Output {
    return try encoder(input)
  }

  public func decode(_ output: Output) throws -> Input{
    return try decoder(output)
  }
}

public func + <A,B,C>(lhs: Transcoder<A,B>, rhs: Transcoder<B,C>) -> Transcoder<A,C> {
  return .init(encoder: { (a: A) -> C in try rhs.encode(lhs.encode(a)) },
               decoder: { (c: C) -> A in try lhs.decode(rhs.decode(c)) })
}

extension Transcoder {
  public static var taskToYaml: Transcoder<[Task], String> {
    return taskToNodes + nodeListToNode + nodeToString
  }

  public static var stringToData: Transcoder<String, Data> {
    return .init(encoder: { $0.data(using: .utf8) ?? Data() },
                 decoder: { String(data: $0, encoding: .utf8) ?? "" })
  }
}

// Implementation for coding between Tasks and Yaml Strings.
extension Transcoder {
  static var taskToNodes: Transcoder<[Task], [Node]> {
    return .init(encoder: { try $0.map { task in try task.represented() } },
                 decoder: { $0.flatMap(Task.init(from:)) })
  }

  static var nodeListToNode: Transcoder<[Node], Node> {
    return .init(encoder: { try $0.represented() },
                 decoder: { node in
                   switch node {
                   case .sequence(let list, _, _):
                     return list
                   case .scalar("null", _, _):
                     return []
                   default:
                     return [node]
                   }
                 })
  }

  static var nodeToString: Transcoder<Node, String> {
    return .init(encoder: { try Yams.dump(object: $0) },
                 decoder: { try Yams.load(yaml: $0).represented() })
  }
}

extension Transcoder {
  public static var taskToJson: Transcoder<[Task], [[String:Any]]> {
    return .init(encoder: { $0.map { $0.jsonObject() } } as ([Task]) -> [[String:Any]],
                 decoder: { $0.flatMap(Task.init(from:)) })
  }

  public static var jsonToData: Transcoder<[[String:Any]], Data> {
    return .init(encoder: { try JSONSerialization.data(withJSONObject: $0) },
                 decoder: {
                  if let object = try JSONSerialization.jsonObject(with: $0) as? [[String:Any]] {
                    return object
                  } else {
                    throw "Data was not in expected format"
                  }
                })
  }
}
