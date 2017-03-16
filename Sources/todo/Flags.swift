import Commander

extension Flag {
  static func all(_ description: String? = nil) -> Flag {
    return Flag("all", flag: "a", description: description)
  }
}
