import Foundation
import XCTest
import GitHubSearch

class GitHubAPIErrorTests: XCTestCase {
    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        let data = GitHubAPIError.exampleJSON.data(using: .utf8)!
        let error = try jsonDecoder.decode(GitHubAPIError.self, from: data)
        
        XCTAssertEqual(error.message, "Validation Failed")
        
        let firstError = error.errors.first
        XCTAssertEqual(firstError?.field, "q")
        XCTAssertEqual(firstError?.code, "missing")
        XCTAssertEqual(firstError?.resource, "Search")
    }
}
