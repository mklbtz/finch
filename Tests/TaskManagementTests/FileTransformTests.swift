import XCTest
import TaskManagement

class FileTransformTests: XCTestCase {
  struct ExampleFile: FileAccessor {
    static var writes: [String] = []

    func read() -> String {
      return "Ring! Ring! Ring!"
    }

    func write(_ s: String) {
      ExampleFile.writes.append(s)
    }
  }

  func testRead() throws {
    let transform = FileTransform<ExampleFile, String>(file: ExampleFile(),
                                  reader: { (s: String) in return s + " Banana phone!" },
                                  writer: { (s: String) in return s })
    XCTAssertEqual(transform.read(), "Ring! Ring! Ring! Banana Phone!")
  }

  func testWrite() throws {
    let transform = FileTransform<ExampleFile, String>(file: ExampleFile(),
                                  reader: { (s: String) in return s },
                                  writer: { (s: String) in return s + " Banana phone!" })
    transform.write("Ring! Ring! Ring!")
    XCTAssertEqual(ExampleFile.writes.last, .some("Ring! Ring! Ring! Banana Phone!"))
  }
}
