import Yams

public struct Task {
  public let id: Int
  public let title: String
  public let done: Bool = false
}

extension Task: NodeRepresentable {
  public func represented() throws -> Node {
    return try [
      "id": id,
      "title": title,
      "done": done
      ].represented()
  }
}
