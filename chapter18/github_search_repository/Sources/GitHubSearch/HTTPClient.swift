import Foundation

/// 開始済みのHTTP通信をキャンセルするためのハンドル。
public protocol HTTPRequestCancelling {
    func cancel()
}

extension URLSessionTask: HTTPRequestCancelling {}

/// HTTP応答またはエラーを返す通信境界。通知スレッドは実装に従います。
public protocol HTTPClient {
    @discardableResult
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPRequestCancelling
}

extension URLSession: HTTPClient {
    /// 通信を開始し、個別にキャンセルできるタスクを返します。
    /// 非HTTPの応答や欠落した本文は `URLError.badServerResponse` として通知します。
    @discardableResult
    public func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPRequestCancelling {
        let task = dataTask(with: urlRequest) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(URLError(.badServerResponse)))
            }
        }
        task.resume()
        return task
    }
}
