import Foundation

/// リクエストの型に応じたレスポンスを返す、HTTPクライアントを差し替え可能なAPIクライアント。
public final class GitHubClient {
    private let httpClient: HTTPClient

    /// 通信を担当する実装を受け取ります。テストではスタブを渡せます。
    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    /// リクエストを送信し、対応する `Response` 型へ変換した結果を通知します。
    ///
    /// 通信失敗は `connectionError`、APIが返すエラーは `apiError`、それ以外の変換失敗は
    /// `responseParseError` に分類します。コールバックのスレッドは注入したHTTPClientに従います。
    /// - Parameters:
    ///   - request: URLの構築とレスポンスの変換方法を定義するリクエスト。
    ///   - completion: 通信と変換が終わった時点の結果を受け取るクロージャ。
    @discardableResult
    public func send<Request: GitHubRequest>(
        request: Request,
        completion: @escaping(Result<Request.Response, GitHubClientError>) -> Void
    ) -> HTTPRequestCancelling {
        let urlRequest = request.buildURLRequest()

        return httpClient.sendRequest(urlRequest) { result in

            switch result {
            case .success((let data, let urlResponse)):
                // 関連型によってリクエストとレスポンスの対応を維持し、変換時のエラーを分類します。
                do {
                    let response = try request.response(from: data, urlResponse: urlResponse)
                    completion(Result.success(response))
                } catch let error as GitHubAPIError {
                    completion(Result.failure(.apiError(error)))
                } catch {
                    completion(Result.failure(.responseParseError(error)))
                }

            case .failure(let error):
                completion(.failure(.connectionError(error)))
            }
        }
    }
}
