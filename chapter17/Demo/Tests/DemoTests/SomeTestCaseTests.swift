//
//  File.swift
//  
//
//  Created by 藤門莉生 on 2023/01/31.
//

import XCTest

class SomeTestCaseTests: XCTestCase {
    func testWithNil() throws {
        try XCTSkipUnless(
            ProcessInfo.processInfo.environment["RUN_CRASH_EXAMPLE"] == "1",
            "意図的にクラッシュする教材。実行方法はこのパッケージのREADMEを参照。"
        )
        let optionalValue: Int! = nil
        XCTAssertNotNil(optionalValue)
        XCTAssertEqual(optionalValue+7, 10)
    }
}
