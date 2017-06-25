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
  public static var taskToData: Transcoder<[Task], Data> {
    return .init(encoder: JSONEncoder(), decoder: JSONDecoder())
  }

  public static var stringToData: Transcoder<String, Data> {
    return .init(encoder: { $0.data(using: .utf8) ?? Data() },
                 decoder: { String(data: $0, encoding: .utf8) ?? "" })
  }

  public static var taskToJson: Transcoder<[Task], [[String:Any]]> {
    return .init(encoder: { $0.map { $0.jsonObject() } } as ([Task]) -> [[String:Any]],
                 decoder: { $0.flatMap(Task.init(from:)) })
  }

  public static var jsonToData: Transcoder<[[String:Any]], Data> {
    return .init(encoder: JSONEncoder(), decoder: JSONDecoder())
  }
}

extension Transcoder {
  public func around(encode wrapper: @escaping (() throws -> Output) throws -> Output) -> Transcoder<Input, Output> {
    return .init(encoder: { input in
      try wrapper { try self.encoder(input) }
    }, decoder: self.decoder)
  }

  public func around(decode wrapper: @escaping (() throws -> Input) throws -> Input) -> Transcoder<Input, Output> {
    return .init(encoder: self.encoder, decoder: { output in
      try wrapper { try self.decoder(output) }
    })
  }
}

protocol Encoder {
  func encode<T>(_ value: T) throws -> Data where T : Encodable
}

protocol Decoder {
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONEncoder: Encoder {}
extension JSONDecoder: Decoder {}
extension PropertyListEncoder: Encoder {}
extension PropertyListDecoder: Decoder {}

extension Transcoder where Input: Codable, Output == Data {
  /// It is an error to use different format types here.
  init<E: Encoder, D: Decoder>(encoder: E, decoder: D) {
    self.encoder = encoder.encode
    self.decoder = { try decoder.decode(Input.self, from: $0) }
  }
}
