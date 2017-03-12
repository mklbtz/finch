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
