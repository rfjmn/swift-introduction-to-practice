import Foundation

/// URLRequestを送信し、HTTPレスポンスの本文・メタデータまたはエラーを返す通信境界。
///
/// URLSessionとスタブを差し替えるための最小限の抽象です。通知スレッドは実装に委ねます。
public protocol HTTPClient {
    func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

extension URLSession: HTTPClient {
    /// 通信を直ちに開始し、URLSessionのコールバックから結果を通知します。
    ///
    /// エラーがなくても本文とHTTP応答を取り出せない場合は、この教材では実行を停止します。
    /// タスクは返さないため、このAPIを通して個別の通信をキャンセルすることはできません。
    public func sendRequest(_ urlRequest: URLRequest, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        
        let task = dataTask(with: urlRequest) { data, urlResponse, error in
            switch (data, urlResponse, error) {
            case (_, _, let error?):
                completion(Result.failure(error))
                
            case (let data?, let urlResponse as HTTPURLResponse, _):
                completion(Result.success((data, urlResponse)))
               
            /*
             データとHTTP応答を取り出せず、エラーもない場合は、この教材ではfatalErrorで停止する。
             非HTTPの応答などもこの分岐に入るため、「絶対に起きない」とは仮定しない。
             */
            default:
                fatalError("invalid reponse combination \(String(describing: (data, urlResponse, error)))")
            }
        }
        
        task.resume()
    }
}
