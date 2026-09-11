import Foundation
import XCTest
import GitHubSearch

/*
 参考URL: https://stackoverflow.com/questions/55816336/swift-jsondecoder-coding-keys-not-working-with-underscore
 */

class RepositoryTests: XCTestCase {
    func testDecode() throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase // 【重要】public enum CondingKeys: String, CodingKeyでスネークケースを対応させるために必要
        let data = Repository.exampleJSON.data(using: .utf8)!
        let repository = try jsonDecoder.decode(Repository.self, from: data)
        XCTAssertEqual(repository.id, 44838949)
        XCTAssertEqual(repository.name, "swift")
        XCTAssertEqual(repository.fullName, "apple/swift")
        XCTAssertEqual(repository.owner.id, 10639145)
    }
}
