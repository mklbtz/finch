import XCTest
import TaskManagement
import Yams

class TaskTests: XCTestCase {
  func defaultTask(id: Int = 0, title: String = "default", done: Bool = false) -> Task {
    return Task(id: id, title: title, done: done)
  }

  func testInit() {
    let task = defaultTask()
    XCTAssertEqual(task.id, 0)
    XCTAssertEqual(task.title, "default")
    XCTAssertEqual(task.done, false)
  }

  func testRepresented() throws {
    let node = try defaultTask().represented()
    XCTAssertEqual(0, node["id"]?.int)
    XCTAssertEqual("default", node["title"]?.string)
    XCTAssertEqual(false, node["done"]?.bool)
  }

  func testInitFromNode() throws {

  }
}
