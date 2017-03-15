import XCTest
import TaskManagement

class TranscoderTests: XCTestCase {
  func testStringToData() throws {
    let subject = Transcoder<String, Data>.stringToData
    let original = "test"
    let encoded = original.data(using: .utf8)!

    XCTAssertEqual(try subject.encode(original), encoded)
    XCTAssertEqual(try subject.decode(encoded), original)
  }

  func testJsonToData() throws {
    let subject = Transcoder<[[String:Any]], Data>.jsonToData
    let original = [["key":"value"]]
    let encoded = try JSONSerialization.data(withJSONObject: original)

    XCTAssertEqual(try subject.encode(original), encoded)

    if let value = try subject.decode(encoded).first?["key"] as? String {
      XCTAssertEqual(value, original.first?["key"])
    }
    else {
      XCTFail("json was not decoded correctly")
    }
  }

  func testTaskToJson() throws {
    let subject = Transcoder<[Task], [[String:Any]]>.taskToJson
    let original = [buildTask()]
    let encoded = original.map { $0.jsonObject() }

    XCTAssertEqual(try subject.decode(encoded), original)

    if let jsonObject = try subject.encode(original).first,
       let task = Task(from: jsonObject) {
        XCTAssertEqual(task, original.first)
    }
    else {
      XCTFail("json was not encoded correctly")
    }
  }
}
