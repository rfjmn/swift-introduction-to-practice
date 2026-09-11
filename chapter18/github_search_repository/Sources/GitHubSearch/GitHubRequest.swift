import Foundation

/*
 ベースURL：相対パスの基準となるURL
 リポジトリ検索APIのURL：https://api.github.com/search/repositories
 GitHub APIのベースURL：https://api.github.com
 
 baseURLプロパティはすべてのリクエストに共通なものであるため、
 プロトコルエクステンションにbaseURLプロパティのデフォルト実装を定義
 デフォルト実装によって、GitHubRequestプロトコルのプロパティbaseURLの値が
 一元管理できるようになるだけでなく、リクエストの型がGitHubRequestプロトコルに準拠するたびに同じ定義を繰り返し記述する必要がなくなる
 
 Web APIでは、リクエストに応じてレスポンスの構造があらかじめ決められている
 今回は、レスポンスの型はDecodableプロトコルに準拠していたが、
 レスポンスの型をリクエストの型に紐づけて、リクエストの型から決定できるようにする
 
 
 【リクエストを表す型のURLRequest型へのマッピング】
 GitHubRequest型に準拠した型をURLRequest型に変換するため、
 GitHubRequestプロトコルのエクステンションにbuildURLRequest()メソッドを実装
 
 URLComponents型：FoundationではURL型の構成要素を表現する型
 */
public protocol GitHubRequest {
    
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    // HTTPボディのためのプロパティは追加しないが、必要な場合は以下のようにEncodableプロパティに準拠したプロパティとして用意すると良い
    // var body: Encodable? { get }
}

// プロトコルエクステンションによるbaseURLのデフォルト実装
public extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    func buildURLRequest() -> URLRequest {
        // baseURLとpathを結合
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: true
        )
        
       
        /*
         HTTP MethodがGETであれば、GitHubRequestプロトコルのqueryItemsプロパティの
         値をURLComponents型のqueryItemsプロパティにセットする。
         こうすることで、URLComponents型の値からURL型の値を生成する際に、
         適切なエンコードを施したクエリ文字列が得られる
         */
        switch method {
        case .get:
            components?.queryItems = queryItems
            
        default:
            fatalError("Unsupported method \(method)")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
   
    /*
     URLSessionクラスを通じてサーバから受け取ったData型とHTTPURLResponse型の値をもとに
     レスポンス型を表す関連型Responseを生成する
     
     JSONとして解釈可能なData型は、JSONDecoderクラスを使用してResponse型へと変換できる
     HTTPURLResponse型の値を確認することで、サーバから受け取った値をどのように解釈するべきかを決定できる
     
     HTTPURLResponse型の値から取得できるHTTPステータスコードに応じて処理を分岐する
     1. HTTPステータスコードが200番台（成功）の場合は正常なレスポンスが返ってきているので、JSONDecoderクラスのdecode(_:from:)メソッドを使用してResponse型の値をインスタンス化し、戻り値として返す
     
     2. HTTPステータスコードが200番台ではない場合はエラーレスポンスが返ってきていることが想定されるので、同じくJSONDecoderクラスのdecode(_:from:)メソッドを使用してGitHubAPIErrorを発生させる
     */
    func response(from data: Data, urlResponse: HTTPURLResponse) throws -> Response {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if(200..<300).contains(urlResponse.statusCode) {
            // JSONからモデルをインスタンス化
            return try decoder.decode(Response.self, from: data)
        } else {
            // JSONからAPIエラーをインスタンス化
            throw try decoder.decode(GitHubAPIError.self, from: data)
        }
    }
}
