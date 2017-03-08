import XCTest
import TaskManagement
import Yams

class TaskTests: XCTestCase {
  func testInit() {
    let task = buildTask()
    XCTAssertEqual(task.id, 0)
    XCTAssertEqual(task.title, "default")
    XCTAssertEqual(task.done, false)
  }

  func testRepresented() throws {
    let node = try buildTask().represented()
    XCTAssertEqual(0, node["id"]?.int)
    XCTAssertEqual("default", node["title"]?.string)
    XCTAssertEqual(false, node["done"]?.bool)
  }

  func testInitFromNode() throws {
    let node = try ["id": 0, "title": "default", "done": false].represented()
    let task = Task(from: node)
    XCTAssertEqual(task, .some(buildTask()))
  }
}
