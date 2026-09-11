import Foundation
import libkern

/*
 ジェネリクス：型をパラメータとして受け取ることで汎用的なプログラムを記述するための機能
 
 Swiftでのジェネリクス
    - ジェネリック関数
    - ジェネリック型
 */

/*
 汎用的なプログラム
 
 特定の処理を汎用化するには、その処理に対して任意の入力値を与えられるようにする
 
 ジェネリクスを利用すれば、複数の型の間においても汎用的な処理を実装できる。
 ジェネリクスの基本的なコンセプトは、入力値の型も任意にすることによってプログラムの汎用性をさらに高めるというもの
 */

func isEqual() -> Bool {
    return 1 == 1
}

// xとyという任意の引数を取り、x == yを返す関数
// あくまで整数同士の比較においてのみ汎用的
// ほかの型どうしの比較を行うには、型ごとに同様の関数をオーバーロードする必要がある
func isEqual2(_ x: Int, _ y: Int) -> Bool {
    return x == y
}

print(isEqual())
print(isEqual2(1, 1))

// オーバーロード
func isEqual2(_ x: Float, _ y: Float) -> Bool {
    return x == y
}
print(isEqual2(1.1, 1.1))

// ジェネリクスの利用
// <T: Equatable>が意味するのは、「Equatableプロトコルに準拠したあらゆる型」
func isEqual3<T: Equatable>(_ x: T, _ y: T) -> Bool {
    return x == y
}
print(isEqual3("abc", "def"))
print(isEqual3(1.0, 3.14))
print(isEqual3(false, false))

/*
 ジェネリクスの基本
 ジェネエリック関数やジェネリック型を定義するには、通常の定義に型引数を追加する。
 型引数は<>で囲み、複数ある場合は、「,」区切りで<T, U>のように定義する。
 型引数として宣言された型は、ジェネリック関数やジェネリック型の内部で通常の型と同等に扱える
 また、ジェネリック関数の戻り値としても利用できる
 
 ジェネリクスの具体例
    - Optional<Wrapped>
    - Array<Element>
 
 プレースホルダー：型引数の別名
 
 [通常の関数]
 func 関数名(引数名: 型) -> 戻り値の型 {
    // 関数呼び出し時に実行される文
 }
 
 [ジェネリック関数]
 func 関数名<型引数>(引数名: 型引数) -> 戻り値の型 {
    // 関数呼び出し時に実行される文
 }
 */

// ジェネリック関数
func someFunction<T, U>(x: T, y: U) -> U {
    let _: T = x // 型アノテーションとして使用
    let _ = x // 型推論に対応
    let _ = 1 as? T // 型のキャストに使用
    return y
}

/*
 特殊化方法
 ジェネリック関数やジェネリック型の内部では、型引数として型を抽象的に表現できるが、
 実際にジェネリック関数を呼び出したり、ジェネリック型をインスタンス化したりするときには、
 型引数に具体的な型を指定する必要がある
 
 特殊化（specealization）：ジェネリクスを使用して汎用的に定義されたものに対して、具体的な型引数を与えて型を確定させること
 
 特殊化の方法
    - <>内に型引数を明示する方法
    - 型推論によって型引数を推論する方法
 */

// Contentは型引数
struct Container<Content> {
    let content: Content
}

// 型引数がStringであることを明示する
let stringContainer = Container<String>(content: "abc")
print(type(of: stringContainer))

// 型引数を型推論する
let intContainer = Container(content: 1)
print(type(of: intContainer))


/*
 仮型引数と実型引数
 
 関数では、定義時に宣言する引数と関数の呼び出し時に指定する引数を明示的に区別する場合、
 前者を仮引数、後者を実引数という。
 ジェネリクスでも、ジェネリクスの定義時に使用する型引数とジェネリクスの特殊化時に指定する型引数を
 明治的に区別する場合、前者を仮型引数、後者を実型引数という。
 */


/*
 汎用性と型安全性の両立
 ジェネリクスは単なる汎用化ではなく、静的型付けによる型安全性を保ったうえでの汎用化である。
 型引数はジェネリック関数やジェネリック型に保持され続けるため、型引数として与えられた型は
 通常の型と同等の型安全性を持っている。
 */

func identity<T>(_ argument: T) -> T {
    return argument
}

let int = identity(1)
print(type(of: int))

let string = identity("abc")
print(type(of: string))


/*
 Any型との比較
 ジェネリクス：型安全性を保ったうえでの汎用化
 Any型：型安全ではない汎用化
 
 Any型は、すべての型が暗黙的に準拠しているプロトコルである。
 つまり、どのような型でも表現できる
 
 Any型を具体的な型として扱うには、ダウンキャストが必要である。
 
 ジェネリクスを使用した関数の戻り値の型が型引数に応じて変化するのに対し、
 Any型を使った関数の戻り値は常にAny型である。
 つまり、Any型を使った関数の戻り値の型は、すべてAny型へとまとめられてしまい、
 実際の型の情報は失われてしまう
 */

// ジェネリクスを使った関数
func identityWithGenericValue<T>(_ argument: T) -> T {
    return argument
}

let genericInt = identityWithGenericValue(1)
let genericString = identityWithGenericValue("abc")
print(type(of: genericInt))
print(type(of: genericString))

// Anyを使った関数
func identityWithAnyValue(_ argument: Any) -> Any {
    return argument
}

let anyInt = identityWithAnyValue(1)
let anyString = identityWithAnyValue("abc")

if let int = anyInt as? Int {
    // ここでようやくInt型として扱える
    print("anyInt is \(int)")
} else {
    // Int型へのダウンキャストが失敗した場合を考慮する必要がある
    print("The type of anyInt is not Int")
}


/*
 ジェネリック関数：汎用的な関数
 ジェネリック関数：型引数型を持つ関数のこと
 
 [定義方法]
 func 関数名<型引数>(引数) -> 戻り値の型 {
    // 関数呼び出し時に実行される文
 }
 */

// ジェネリック関数の定義
func identity2<T>(_ x: T) -> T {
    return x
}
print(identity2(1))
print(identity2("abc"))


/*
 特殊化方法
 
 ジェネリック関数の実行には、特殊化が必要
 ジェネリック関数を特殊化するには、引数から型推論によって型引数を決定する方法と、戻り値から型推論によって型引数を決定する方法の2つが用意されている
 */

/*
 引数からの型推論による特殊化
 引数からの型推論によって特殊化を行うには、ジェネリック関数の引数のうちの少なくとも1つの型が型引数となる必要がある
 
 型引数が複数の引数や戻り値の値で使用される場合、それらの実際の型は一致する必要がある
 */

func someFunction2<T>(_ argument: T) -> T {
    return argument
}

let int2 = someFunction2(1)
let string2 = someFunction2("abc")
print(type(of: int2))
print(type(of: string2))

// someFunction(_:)にInt型の引数を渡した場合と同等の関数
func someFunction3(_ argument: Int) -> Int {
    return argument
}

let int3 = someFunction3(1)

func someFunction4(_ argument: String) -> String {
    return argument
}

let string3 = someFunction4("abc")

func someFunction5<T>(_ argument1: T, _ argument2: T) {}
someFunction5(1, 2) // OK
someFunction5("abc", "def") // OK
// someFunction5(1, "abc") // bad

/*
 戻り値からの型推論による特殊化
 戻り値からの型推論によって特殊化を行うには、「ジェネリック関数の戻り値の型が型引数」となっていて、
 かつ、「戻り値の代入先の型が決まっている」必要がある
 */

func someFunction6<T>(_ any: Any) -> T? {
    return any as? T
}
let a: String? = someFunction6("abc")
print(type(of: a))
let b: Int? = someFunction6(1)
print(type(of: b))
// Tが決定できず、コンパイルエラー
// let c = someFunction6("abc")

/*
 型制約：型引数に対する制約
 型制約：準拠すべきプロトコルやスーパークラスなど、型引数にはさまざまな制約を設けることができる
    - 型制約を利用することで、ジェネリック関数やジェネリック型をより細かくコントロールできる
    - 型制約がない型引数ではどのような型でも受け取れるため、型の性質を利用した記述ができなかった
    - 型引数に型制約を設けることで、型の性質を利用できる
    - 型引数に必要な十分な型制約を与えると、汎用性と型の性質を利用した具体的な処理とを両立できる
 
 型制約の種類
    - スーパークラスや準拠するプロトコルにに対する制約
    - 関連型のスーパークラスや準拠するプロトコルに対する制約
    - 型どうしの一致を要求する制約
 */

/*
 スーパークラスや準拠するプロトコルに対する制約
 型引数のスーパークラスや準拠するプロトコルに対する制約を指定するには、
 型引数のあと「:」に続けてプロトコル名やスーパークラス名を指定する
 
 [定義]
 func 関数名<型引数名: プロトコル名やスーパークラス名>(引数) {
    // 関数呼び出し時に実行される文
 }
 */

func isEqual4<T: Equatable>(_ x: T, _ y: T) -> Bool {
    return x == y
}
print(isEqual4("abc", "def"))


/*
 関連型のスーパークラスや準拠するプロトコルに対する制約
 型引数にはwhere節を追加でき、where節では型引数の関連型についての型制約を定義できる
 関連型の型制約では、関連型のスーパークラスや準拠すべきプロトコルについての制約と、型どうしの一致を
 要求する制約を設けることもできる
 関連型のスーパークラスや準拠すべきプロトコルについての制約を指定するには、where節内で関連型のあとに
 「:」に続けてプロトコル名やスーパークラス名を指定する。
 
 
 [定義方法]
 func 関数名<型引数: プロトコル>(引数) -> 戻り値の型 where 関連型: プロトコルやスーパークラス {
    // 関数呼び出し時に実行される文
 }
 */

func sorted<T: Collection>(_ argument: T) -> [T.Element] where T.Element: Comparable {
    return argument.sorted()
}
print(sorted([1, 2, 3]))


/*
 型どうしの一致を要求する制約
 「型引数と関連型の一致」や「関連型どうしの一致」を要求する型制約を設けるには、
 where節内で一致すべき型どうしを==演算子で結びつける
 
 [定義]
 func 関数名<型引数1: プロトコル1, 型引数2: プロトコル2>(引数) -> 戻り値の型 where プロトコル1の関連型 == プロトコル2の関連型 {
    // 関数呼び出し時に実行される文
 }
 */

/*
 Set<Element>：数学における集合を表すジェネリック型
    - Set([1, 2, 3])は、Set<Element>型をInt型で特殊化したSet<Int>型となる
*/

func concat<T: Collection, U: Collection>(_ argument1: T, _ argument2: U) -> [T.Element] where T.Element == U.Element {
    return Array(argument1) + Array(argument2)
}

let array = [1, 2, 3]
let set = Set([1, 2, 3])
let result = concat(array, set)
print(result)


/*
 ジェネリック型：汎用的な型
 
 ジェネリック型：型引数を持つクラス、構造体、列挙型のこと
 
 
 [構造体]
 struct 構造体名<型引数> {
    // 構造体の定義
 }
 
 [クラス]
 class クラス名<型引数雨> {
    // クラスの定義
 }
 
 [列挙型]
 enum 列挙型名<型引数> {
    // 列挙型の定義
 }
 */

// 構造体
struct GenericStruct<T> {
    var property: T
}

// クラス
class GenericClass<T> {
    func someFunction(x: T){}
}

// 列挙型
enum GenericEnum<T> {
    case SomeCase(T)
}

/*
ジェネリック型のインスタンス化や、ジェネリック型のスタティックメソッドの
実行には、特殊化が必要となる。
ジェネリック型を特殊化する方法
    - 明治的に型引数を指定する方法
    - 型推論によって型引数を決定する方法

型引数の指定による特殊化
ジェネリック型では、型引数の直接指定による特殊化を行える

型推論による特殊化
ジェネリック型では、明治的に型引数を指定しなくても、
イニシャライザやスタティックメソッドの引数からの型推論によって
特殊化を行える。
型推論によるジェネリック型の特殊化は、ジェネリック関数での特殊化と
同様に引数の型が型引数となる。
*/

// 型引数の指定による特殊化
struct Container2<Content> {
    var content: Content
}

let intContainer2 = Container2<Int>(content: 1)
let stringContainer2 = Container2<String>(content: "abc")

// 型引数とイニシャライザの引数の型が一致しないのでコンパイルエラー
// bad: let container = Container2<Int>(content: "abc")

struct Container3<Content> {
    var content: Content
}

let intContainer3 = Container3(content: 1)
let stringContainer3 = Container3(content: "abc")

/*
型制約：型引数に対する制約
ジェネリック関数と同様に、ジェネリック型の型引数にも型制約を設けられる。
しかし、使用できる型制約の種類や場所にはいくつかの違いがある。

型の定義で使用できる型制約
ジェネリック関数では、3つの種類の型制約を使用できる。
ジェネリック型の型の定義以下の制約が使用できる。
    - 型引数のスーパークラスや準拠するプロトコルに対する制約

型引数のスーパークラスや準拠するプロトコルに対する制約を指定するには、
型引数のあと「:」に続けて、プロトコル名やスーパークラス名を指定する。

以下のwhere節を必要とする型制約はジェネリック型では、使用できない
    - 関連型のスーパークラスや準拠するプロトコルに対する
    - 型どうしの一致を要求する制約

[定義]
struct 型名<型引数: プロトコル名やスーパークラス名> {
    // 構造体の定義
}
*/

/*
ジェネリック型の型制約付きエクステンション
型制約付きエクステンション：ジェネリック型では、型引数が特定の条件を満たす場合にのみ有効となるエクステンションを定義できる

ジェネリック型の型制約付きエクステンションを利用すると、
型制約を満たす型が持つプロパティやメソッドを使った機能を、
汎用的に実装することができる

型制約付きエクステンションを定義するには、
エクステンションの型名に続けてwhere節を追加する

型の定義では型引数のスーパークラスや準拠するプロトコルに対する制約しか
使用できなかったが、エクステンションではすべての種類の型制約が使用できる

[定義]
extension ジェネリック型名 where 型制約 {
    // 制約を満たす場合に有効となるエクステンション
}
*/

struct Pair<Element> {
    let first: Element
    let second: Element
}

/*
型制約でElement型を限定することによって使用できるようになった
プロパティやメソッドを使うのが、型制約付きエクステンションを定義する目的
*/
extension Pair where Element == String {
    func hasElement(containing character: Character) -> Bool {
        return first.contains(character) || second.contains(character)
    }
}

let stringPair = Pair(first: "abc", second: "def")
print(stringPair.hasElement(containing: "e"))

let integerPair = Pair(first: 1, second: 2)
// メソッドが存在しないためコンパイルエラー
// bad: print(integerPair.hasElement(containing: "e"))

/*
プロトコルへの条件付き準拠
ジェネリック型の型制約付きエクステンションでは、プロトコルへの準拠も可能
これを「プロトコルへの条件付き準拠（conditional cnformance）」という。
ジェネリック型は、型引数が型制約を満たす時のみプロトコルへ準拠する。

プロトコルへの条件付き準拠を行うには、型制約付きエクステンションの
型名に続けて「:条件付きプロトコル名」を追加することで、
プロトコルへの準拠の宣言を追加する。

[定義]
extension ジェネリック型: 条件付き準拠するプロトコル名 where 型制約 {
    // 制約を満たす場合に有効となるエクステンション
}

プロトコルへの条件付き準拠が役立つ典型的なケース
    - 型引数があるプロトコルに準拠するとき、元のジェネリック型も同じプロトコルに準拠させるというケース

[標準ライブラリでの活用]
extension Array: Equatable where Element: Equatable {
    // 省略
}
*/

struct Pair2<Element> {
    let first: Element
    let second: Element
}

// Pair2<Element>型の型引数ElementがEquatableプロトコルに準拠している場合
// Pair2<Element>型もまたEquatableプロトコルに準拠させることができる
extension Pair2: Equatable where Element: Equatable {
    static func == (_ lhs: Pair2, _ rhs: Pair2) -> Bool {
        return lhs.first == rhs.first && lhs.second == rhs.second
    }
}

let stringPair2 = Pair2(first: "abc", second: "def")
let stringPair3 = Pair2(first: "def", second: "ghi")
let stringPair4 = Pair2(first: "abc", second: "def")
// Pair2<String>型どうしが==演算子で比較できていることから
// Pair2<String>型がEquatableプロトコルに準拠できていることがわかる
print(stringPair2 == stringPair3)
print(stringPair2 == stringPair4)
