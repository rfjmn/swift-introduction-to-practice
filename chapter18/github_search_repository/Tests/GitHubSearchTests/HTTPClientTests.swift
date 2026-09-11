import Foundation
import XCTest
@testable import GitHubSearch

final class HTTPClientTests: XCTestCase {
    func testNonHTTPResponseReportsErrorWithoutTerminatingProcess() {
        ProtocolStub.responds = true
        let session = makeSession()
        defer { session.invalidateAndCancel() }
        let completed = expectation(description: "invalid response")
        session.sendRequest(URLRequest(url: URL(string: "https://example.com")!)) { result in
            guard case .failure(let error as URLError) = result else { return XCTFail("Expected bad response") }
            XCTAssertEqual(error.code, .badServerResponse)
            completed.fulfill()
        }
        wait(for: [completed], timeout: 3)
    }

    func testCancellationReachesURLSessionAndReportsCancelled() {
        ProtocolStub.responds = false
        let session = makeSession()
        defer { session.invalidateAndCancel() }
        let completed = expectation(description: "cancelled")
        let task = session.sendRequest(URLRequest(url: URL(string: "https://example.com")!)) { result in
            guard case .failure(let error as URLError) = result else { return XCTFail("Expected cancellation") }
            XCTAssertEqual(error.code, .cancelled)
            completed.fulfill()
        }
        task.cancel()
        wait(for: [completed], timeout: 3)
    }

    func testGitHubClientForwardsCancellationHandle() {
        let http = StubHTTPClient()
        let client = GitHubClient(httpClient: http)
        let task = client.send(request: GitHubAPI.SearchRepositories(keyword: "swift")) { _ in }
        task.cancel()
        XCTAssertTrue(http.cancellation.isCancelled)
    }

    private func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ProtocolStub.self]
        return URLSession(configuration: configuration)
    }
}

private final class ProtocolStub: URLProtocol {
    static var responds = true
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        guard Self.responds, let url = request.url else { return }
        client?.urlProtocol(self, didReceive: URLResponse(url: url, mimeType: "text/plain", expectedContentLength: 0, textEncodingName: nil), cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data())
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}
