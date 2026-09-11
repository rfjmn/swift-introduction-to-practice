//
//  StatusFetcher.swift
//
//
//  Created by 藤門莉生 on 2023/01/31.
//

import Foundation

final class StatusFetcher {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func fetchStatus(of url: URL, completion: @escaping(Result<Int, Error>) -> Void) {
        let task = self.urlSession.dataTask(with: url) { data, urlResponse, error in
            switch(data, urlResponse, error) {
            case(_,let urlResponse as HTTPURLResponse, _):
                completion(.success(urlResponse.statusCode))

            case (_, _, let error?):
                completion(.failure(error))

            default:
                completion(.failure(URLError(.badServerResponse)))
            }
        }

        task.resume()
    }
}
