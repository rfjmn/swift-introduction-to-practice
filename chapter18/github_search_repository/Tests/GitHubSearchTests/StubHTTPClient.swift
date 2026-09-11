import Foundation
import GitHubSearch

/*
 スタブ可能なHTTPクライアント
 */
class StubHTTPClient: HTTPClient {
    var result: Result<(Data, HTTPURLResponse), Error> = .success((
        Data(),
        HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    ))
    
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [unowned self] in
            completion(self.result)
        }
    }
}
