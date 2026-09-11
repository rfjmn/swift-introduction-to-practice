import Foundation
import GitHubSearch

/*
 スタブ可能なHTTPクライアント
 */
final class StubHTTPClient: HTTPClient {
    var result: Result<(Data, HTTPURLResponse), Error> = .success((
        Data(),
        HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    ))
    
    let cancellation = CancellationSpy()

    @discardableResult
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPRequestCancelling {
        completion(result)
        return cancellation
    }
}

final class CancellationSpy: HTTPRequestCancelling {
    private(set) var isCancelled = false
    func cancel() { isCancelled = true }
}
