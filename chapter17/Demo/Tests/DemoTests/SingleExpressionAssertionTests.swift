import XCTest

class SingleExpressionAssertionTests: XCTestCase {

    func testExample() {
        let value = 5
        XCTAssert(value == 5)
        XCTAssertTrue(0 < value)
        XCTAssertFalse(value < 0)
        
        let nilValue = nil as Int?
        XCTAssertNil(nilValue)
        
        let optionalValue = Optional(1)
        XCTAssertNotNil(optionalValue)
    }
}
