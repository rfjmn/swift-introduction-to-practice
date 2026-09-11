import Foundation

// モジュール外から使用可能な型
open class SomeOpenClass{}

// モジュール外から使用可能だが、モジュール外で継承不可能な型
public class SomePublicClass {
    // モジュール内でのみ使用可能なプロパティ
    internal let someInternalConstant = 1
    
    // 同一ソースファイル内でのみ使用可能なプロパティ
    fileprivate var someFileprivateVariable = 1
    
    // SomePublicClass内でのみ使用可能なメソッド
    private func somePrivateMethod() {}
}


// SomeStruct型自身のアクセスレベルはpublic
public struct SomeStruct {
    // idプロパティやsomeMethod()メソッドのアクセスレベルはデフォルトのinternal
    // idプロパティ、someMethod()メソッドはモジュール外からは見えない
    var id: Int
    func someMethod() {}
    
    // メンバーワイズイニシャライザのアクセスレベルもデフォルトのinternal
    // モジュール外に公開されたイニシャライザが存在しないため、モジュール外からインスタンス化を行えない
    // 明治的にアクセスレベルを指定すれば、デフォルト以外のアクセスレベルにできる
}

public struct SomeStruct2 {
    public var id: Int
    
    public init(id: Int) {
        self.id = id
    }
    
    public func someMethod(){}
}

struct SomeStruct3 {
    private var a: Int
    private var b: Int
}

extension SomeStruct3: Equatable {
    static func == (_ lhs: SomeStruct3, _ rhs: SomeStruct3) -> Bool {
        // 元の型でprivateとして宣言されている要素にエクステンションからアクセスできる
        return lhs.a == rhs.a && lhs.b == rhs.b
    }
}

// モジュールヘッダに記述される情報
public struct SomeStruct4 {
    public let id: Int
    public let name: String
    
    public init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int, let name = dictionary["name"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = SomeStruct4.decorate(name: name)
    }
    
    // モジュールヘッダには、以下の情報は表示されない
    private static func decorate(name: String) -> String {
        return "【\(name)】"
    }
}

// コメント

/*
 *コメント
 */

/// ドキュメントコメントの記法を示す、処理を持たないサンプルメソッド。
///
/// **太字**や[リンク](https://example.com/)を記述できます。
///
/// - Parameters:
///   - arg1: 1つ目の入力文字列。この例では使用しません。
///   - arg2: 2つ目の入力文字列。この例では使用しません。
func someMethod(arg1: String, arg2: String){}

/*
 DocCの記法: Parametersは引数、Returnsは戻り値、Throwsは送出するエラーを説明する。
 このsomeMethodはVoidを返す非throwing関数なので、ReturnsとThrowsは記載しない。
 */
