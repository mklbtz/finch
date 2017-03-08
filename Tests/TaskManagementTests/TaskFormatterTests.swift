import XCTest
import TaskManagement

class TaskFormatterTests: XCTestCase {
  func testDescription() {
    var description = TaskFormatter(for: buildTask()).description
    XCTAssertEqual(description, " ◦ 0. default")

    description = TaskFormatter(for: buildTask(done: true)).description
    XCTAssertEqual(description, " ✓ 0. default")

    description = TaskFormatter(for: buildTask(), padding: 3).description
    XCTAssertEqual(description, "    ◦ 0. default")
  }
}
