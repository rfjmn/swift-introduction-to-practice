// @testable に頼らず、モジュール外から公開APIを利用できることを検証する。
import XCTest
import Library
import AnotherLibrary

final class ModuleTests: XCTestCase {
    func testPublicAPIWorksAcrossModuleBoundary() {
        XCTAssertEqual(AnotherLibrary.Greeting().welcome("Swift"), "Hello, Swift!")
    }

    func testSameTypeNameCanBeQualifiedByModule() {
        XCTAssertEqual(Library.Greeting().message(for: "莉生"), "Hello, 莉生!")
        XCTAssertEqual(AnotherLibrary.Greeting().welcome("莉生"), "Hello, 莉生!")
    }
}
