import XCTest

class FailTests: XCTestCase {
    func test() {
        let optionalValue = Optional(3)
        // let optionalValue: Int? = nil
        guard let value = optionalValue else {
            XCTFail()
            return
        }
        
        // valueを使ったコード
    }
}
