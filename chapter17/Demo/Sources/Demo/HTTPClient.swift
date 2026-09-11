import Foundation

/*
 依存先のプロトコル化
 まず、URLSessionクラスが担っている通信機能をスタブ化することを考える
 
 StatusFetcherクラスが使っているURLSessionクラスの機能は、URL型の値を使用して、
 非同期的にData?型とHTTPResponse?型とError?型の値を取得するものである。
 
 通信が成功すればData型とHTTPResponse型の値が存在し、失敗すればError型の値が存在するため
 これは、Result<(Data, HTTPURLResponse), Error>型として表せる
 */

public protocol HTTPClient {
    func fetchContents(of url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}
