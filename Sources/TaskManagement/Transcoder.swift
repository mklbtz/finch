import Foundation

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
  public static var stringToData: Transcoder<String, Data> {
    return .init(encoder: { $0.data(using: .utf8) ?? Data() },
                 decoder: { String(data: $0, encoding: .utf8) ?? "" })
  }

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
