import Foundation
import XCTest
import GitHubSearch

class SearchResponseTests: XCTestCase {
    func testDecodeRepositories() throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let data = SearchResponse<Repository>.exampleJSON.data(using: .utf8)!
        let response = try jsonDecoder.decode(SearchResponse<Repository>.self, from: data)
        
        XCTAssertEqual(response.totalCount, 141722)
        XCTAssertEqual(response.items.count, 3)
        
        let firstRepository = response.items.first
        XCTAssertEqual(firstRepository?.name, "swift")
        XCTAssertEqual(firstRepository?.fullName, "apple/swift")
    }
}
