import Foundation

final class StatusFetcher2 {
    private let httpClient: HTTPClient

    // StatusFetcher2クラス内部で行われている通信機能が差し替え可能
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    func fetchStatus(of url: URL, completion: @escaping(Result<Int, Error>) -> Void) {
        httpClient.fetchContents(of: url) { result in

            switch result {
            case .success((_, let urlResponse)):
                completion(.success(urlResponse.statusCode))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
