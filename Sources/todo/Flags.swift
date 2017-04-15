import Commander

extension Flag {
  static func all(_ description: String? = nil) -> Flag {
    return Flag("all", flag: "a", description: description)
  }
}

extension Argument {
  public static func id() -> Argument<T> {
    return .init("id", description: "A task ID number")
  }

  public static func title() -> Argument<T> {
    return .init("title", description: "A title for the task")
  }
}

extension VariadicArgument {
  public static func ids() -> VariadicArgument<T> {
    return VariadicArgument<T>("ids", description: "A list of task ID numbers")
  }
}

extension Int {
  public typealias Arg = Argument<Int>
  public typealias Args = VariadicArgument<Int>
  public typealias Opt = Option<Int>
  public typealias Opts = Options<Int>
}

extension Double {
  public typealias Arg = Argument<Double>
  public typealias Args = VariadicArgument<Double>
  public typealias Opt = Option<Double>
  public typealias Opts = Options<Double>
}

extension Float {
  public typealias Arg = Argument<Float>
  public typealias Args = VariadicArgument<Float>
  public typealias Opt = Option<Float>
  public typealias Opts = Options<Float>
}

extension String {
  public typealias Arg = Argument<String>
  public typealias Args = VariadicArgument<String>
  public typealias Opt = Option<String>
  public typealias Opts = Options<String>
}
