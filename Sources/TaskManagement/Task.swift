import Yams

public struct Task {
  public let id: Int
  public var title: String
  public var done: Bool = false

  public init(id: Int, title: String, done: Bool = false) {
    self.id = id
    self.title = title
    self.done = done
  }
}

extension Task: NodeRepresentable {
  public func represented() throws -> Node {
    return try jsonObject().represented()
  }

  public init?(from node: Node) {
    guard let id = node["id"]?.int,
          let title = node["title"]?.string,
          let done = node["done"]?.bool
    else { return nil }
    self.init(id: id, title: title, done: done)
  }
}

extension Task {
  public func jsonObject() -> [String:Any] {
    return [
      "id": id,
      "title": title,
      "done": done
    ]
  }

  public init?(from json: [String:Any]) {
    guard let id = json["id"] as? Int,
          let title = json["title"] as? String,
          let done = json["done"] as? Bool
    else { return nil }
    self.init(id: id, title: title, done: done)
  }
}

extension Task: Equatable {
  public static func ==(lhs: Task, rhs: Task) -> Bool {
    return lhs.id == rhs.id && lhs.title == rhs.title && lhs.done == rhs.done
  }
}
