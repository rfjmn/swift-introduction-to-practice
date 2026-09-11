import Foundation
import GitHubSearch

print("Enter your query here >", terminator: "")

// 入力された検索クエリの取得
guard let keyword = readLine(strippingNewline: true) else {
    exit(1)
}

// APIクライアントの作成
let client = GitHubClient(httpClient: URLSession.shared)

// リクエストの発行
let request = GitHubAPI.SearchRepositories(keyword: keyword)

// リクエストの送信
client.send(request: request) { result in
    switch result {
    case .success(let response):
        for item in response.items {
            // リポジトリの所有者と名前を出力
            print(item.owner.login + "/" + item.name)
        }
        
        exit(0)
        
    case .failure(let error):
        print(error)
        exit(1)
    }
}

// タイムアウト時間
let timeoutInterval: TimeInterval = 60

// タイムアウトまでメインスレッドを停止
Thread.sleep(forTimeInterval: timeoutInterval)

// タイマアウト後の処理
print("Connection timeout")
exit(1)

