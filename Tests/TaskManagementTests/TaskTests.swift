import XCTest
import TaskManagement

class TaskTests: XCTestCase {
  func testInit() {
    let task = buildTask()
    XCTAssertEqual(task.id, 0)
    XCTAssertEqual(task.title, "default")
    XCTAssertEqual(task.done, false)
  }

  func testJsonObject() throws {
    let node = buildTask().jsonObject()
    XCTAssertEqual(0, node["id"] as? Int)
    XCTAssertEqual("default", node["title"] as? String)
    XCTAssertEqual(false, node["done"] as? Bool)
  }

  func testInitFromJson() throws {
    let json = ["id": 0, "title": "default", "done": false] as [String : Any]
    let task = Task(from: json)
    XCTAssertEqual(task, .some(buildTask()))
  }

  func testDescription() {
    var description = buildTask().description
    XCTAssertEqual(description, " ◦ 0. default")

    description = buildTask(done: true).description
    XCTAssertEqual(description, " ✓ 0. default")
  }
}
