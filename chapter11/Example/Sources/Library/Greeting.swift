// モジュール外へ公開する最小限のインタフェース。
public struct Greeting {
    public init() {}
    public func message(for name: String) -> String {
        "Hello, \(name)!"
    }
}
