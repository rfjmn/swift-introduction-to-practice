/*
 この型は独自のCodingKeysを持たない。GitHubRequest.responseのJSONDecoderで
 convertFromSnakeCaseを指定し、full_nameをfullNameへ対応させる。
 単独でデコードする呼び出し元も、同じkeyDecodingStrategyを設定する必要がある。
 */
public struct Repository: Decodable {
    public var id: Int
    public var name: String
    public var fullName: String
    public var owner: User // User型もDecodableプロトコルに準拠している必要がある
}
