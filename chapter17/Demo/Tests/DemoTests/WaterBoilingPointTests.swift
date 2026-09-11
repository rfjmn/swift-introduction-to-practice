import XCTest
@testable import Demo

final class WaterBoilingPointTests: XCTestCase{
    
    func testWaterBoilingPoint() {
        let temperature = Temperature.waterBoilingPoint
        XCTAssertEqual(temperature.celsius, 100)
        XCTAssertEqual(temperature.fahrenheit, 212)
    }
}
