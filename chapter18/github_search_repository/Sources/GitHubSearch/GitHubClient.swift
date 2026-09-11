//
//  File.swift
//
//
//  Created by 藤門莉生 on 2023/02/02.
//

import Foundation

/*
 GitHubClientクラスの内部で使用できるように、
 イニシャライザの引数にHTTP Clientプロトコルに準拠した型をとり、
 ストアドプロパティで保持する


 APIクライアントは、リクエストの型から実際のHTTPリクエストを作成し、
 非同期的に通信を行う。
 結果を受け取ったら、それらをレスポンスの型へと変換して、呼び出しもとに渡す
 */
public final class GitHubClient {
    private let httpClient: HTTPClient

    public init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    /*
     このメソッドでは、非同期的に発生するエラーに対処する必要があるため
     エラー処理の方法として、Result<Success, Failure>型を採用している。

     コールバックのクロージャの引数の型は、Result<Request.Response, GitHubClientError>になっており、
     成功時には型引数Requestの連想型Responseの値を受け取ることができる

     従って、send(request:completion:)メソッドに渡すリクエストの型に応じて、
     クロージャの引数の型も変わる

     (ex)
     GitHubAPI.SearchRepositories型 -> クロージャの引数の型は、Result<SearchResponse<Repository>, GitHubClientError>

     GitHubAPI.SearchUsers型 -> クロージャの引数の型は、Result<SearchResponse<User>, GitHubClientError>

     コールバックのクロージャの型を型引数の連想型で表すことで、
     リクエストを渡してからモデルのインスタンスを受け取るまで一連の処理を
     型情報を保ったまま全て1つのメソッドで行える
     */
    public func send<Request: GitHubRequest>(
        request: Request,
        completion: @escaping(Result<Request.Response, GitHubClientError>) -> Void
    ) {
        let urlRequest = request.buildURLRequest()

        httpClient.sendRequest(urlRequest) { result in

            switch result {
            case .success((let data, let urlResponse)):
                /*
                 GitHubRequestプロトコルのresponse(from:urlResponse:)メソッドのデフォルト実装では、
                 HTTPステータスコードの200番台であれば、モデルRequest.Response型を返す
                 それ以外であれば、GitHubAPIError型のエラーを発生させる

                 従って、response(from:urlResponse:)メソッド内で発生する
                 可能性のあるエラーの型は、GitHubAPIError型とそれ以外の型に分類

                 .apiError(error)と.responseParseError(error)いずれの場合も
                 内部で発生したエラーを連想値に指定することで、具体的に何が起きたのか
                 呼び出しもとに伝えることができる

                 APIクライアントでは様々なタイミングでエラーが発生する可能性があるが、
                 いずれのエラーもResult<Request.Response, GitHubClientError>型の
                 ケース.failure(GitHubClientError)としてクロージャに渡される
                 */
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
