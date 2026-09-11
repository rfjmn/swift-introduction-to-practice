import XCTest
@testable import Demo

class GetIntAsyncTests: XCTestCase {
    func testAsync() {
        let asyncExpectation = expectation(description: "async")
        
        var optionalValue: Int?
        
        getIntAsync { value in
            optionalValue = value
            asyncExpectation.fulfill()
        }
      
        wait(for: [asyncExpectation], timeout: 3)
        // 非同期処理が完了する前に実行されるので、失敗する
        XCTAssertEqual(optionalValue, 4)
    }
}
