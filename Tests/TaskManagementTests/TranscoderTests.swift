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

  // TODO: Figure out how to compare [[String: Any]]

  // func testJsonToData() throws {
  //   let subject = Transcoder<[[String:Any]], Data>.jsonToData
  //   let original: [[String: Any]] = [["key":"value"]]
  //   let encoded = JSONSerialization.data(withJSONObject: original)

  //   XCTAssertEqual(try subject.encode(original), encoded)
  //   XCTAssertEqual(try subject.decode(encoded), original)
  // }

  // func testTaskToJson() throws {
  //   let subject = Transcoder<[Task], [[String:Any]]>.taskToJson
  //   let original = [buildTask()]
  //   let encoded = original.flatMap { $0.jsonObject() }

  //   XCTAssertEqual(try subject.encode(original), encoded)
  //   XCTAssertEqual(try subject.decode(encoded), original)
  // }
}
