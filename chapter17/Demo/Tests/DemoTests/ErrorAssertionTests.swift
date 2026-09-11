import XCTest
@testable import Demo

final class ErrorAssertionTests: XCTestCase {
    func test() {
        XCTAssertThrowsError(try throwableFunction(throwsError: true))
        XCTAssertNoThrow(try throwableFunction(throwsError: false))
    }
}
