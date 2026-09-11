/*
 GitHub APIのエラーレスポンスのJSONは、共通してmessageプロパティを持つ
 
 リクエストが不正な場合には、errorsプロパティから、リクエストの誤りに関する詳細な情報を取得可能
 */

public struct GitHubAPIError: Decodable, Error {
    public struct Error: Decodable {
        public var resource: String
        public var field: String
        public var code: String
    }
    
    public var message: String
    public var errors: [GitHubAPIError.Error]
}
