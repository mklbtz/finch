import XCTest
import TaskManagement

class FileTests: XCTestCase {
  func testSaveAndLoad() throws {
    let file = try buildFile()
    let data = "test data".data(using: .utf8)!
    try file.save(data) // should not throw
    XCTAssertEqual(data, try file.load())
  }
}
