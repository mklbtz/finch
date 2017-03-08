import Foundation

public protocol FileAccessor {
  associatedtype Format

  func read() throws -> Format
  func write(_: Format) throws
}
