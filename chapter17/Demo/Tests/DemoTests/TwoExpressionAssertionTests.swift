import XCTest

final class TwoExpressionAssertionTests: XCTestCase {
    func testExample() {
        XCTAssertEqual("abc", "abc")
        XCTAssertEqual(0.002, 0.003, accuracy: 0.1)
        XCTAssertNotEqual("abc", "def")
        XCTAssertLessThan(4, 7)
        XCTAssertLessThanOrEqual(7, 7)
        XCTAssertGreaterThan(6, 4)
        XCTAssertGreaterThanOrEqual(4, 4)
    }
}
