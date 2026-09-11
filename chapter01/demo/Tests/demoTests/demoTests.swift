import XCTest
@testable import demo

final class demoTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(demo().text, "Hello, World!")
    }
}
