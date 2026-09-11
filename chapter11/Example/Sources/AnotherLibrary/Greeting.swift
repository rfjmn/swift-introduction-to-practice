// 同名の型を別モジュールに定義し、名前空間で区別する例。
import Library

public struct Greeting {
    public init() {}
    public func welcome(_ name: String) -> String {
        Library.Greeting().message(for: name)
    }
}
