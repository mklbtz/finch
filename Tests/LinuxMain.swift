import XCTest
@testable import TaskManagementTests

XCTestMain([
  testCase(DataFileTests.allTests),
  testCase(FileAccessorTests.allTests),
  testCase(FileTransformTests.allTests),
  testCase(TaskFormatterTests.allTests),
  testCase(TaskTests.allTests),
])
