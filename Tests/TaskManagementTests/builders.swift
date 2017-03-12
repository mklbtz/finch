import Foundation
import TaskManagement

func buildTask(id: Int = 0, title: String = "default", done: Bool = false) -> Task {
  return Task(id: id, title: title, done: done)
}

func buildFile() throws -> File {
  let path = try tempDesktop().appendingPathComponent("test_file").path
  return File(atPath: path)
}

func desktop() throws -> URL {
  return try FileManager.default.url(for: .desktopDirectory,
                                      in: .userDomainMask,
                          appropriateFor: nil,
                                  create: false)
}

func tempDesktop() throws -> URL {
  return try FileManager.default.url(for: .itemReplacementDirectory,
                                      in: .userDomainMask,
                          appropriateFor: desktop(),
                                  create: true)
}
