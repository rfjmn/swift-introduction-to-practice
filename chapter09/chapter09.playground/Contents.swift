import Foundation

/*
 プロトコル：型のインタフェースを定義するもの
 インタフェース：型がどのようなプロパティやメソッドを持っているかを示す
 */

/*
 プロトコル：型が特定の性質や機能を持つために必要なインタフェースを定義するためのもの
 準拠：プロトコルが要求するインタフェースを型が満たすこと
 
 プロトコルを利用することで、複数の型で共通となる性質を抽象化できる
    - (ex)
    - 同値性：2つの値が同じであるかどうか
        - Equatableプロトコル：同値性が検証可能であるという性質
        - Equatableプロトコルには、==演算子が定義されており、このプロトコルに準拠する型は==演算子に対する実装を用意する必要がある
 
 
 プロトコルが存在しているおかげで、具体的な型は問わないが、同値性が検証可能な型だけを扱うことが可能になる
 */

func printIfEqual<T: Equatable>(_ arg1: T, _ arg2: T) {
    if arg1 == arg2 {
        print("Both are \(arg1)")
    }
}

printIfEqual(123, 123)
printIfEqual("str", "str")


/*
 プロトコルの基本
 
 [定義]
 protocol プロトコル名 {
    // プロトコルの定義
 }
 
 プロトコルに準拠するには、プロトコルが要求している全てのインタフェースに対する実装を用意する必要がある
 
 [準拠方法]
 struct 構造体名: プロトコル名1, プロトコル名2...{
    // 構造体の定義
 }
 */

protocol SomeProtocol {
    func someMethod()
}

struct SomeStruct1: SomeProtocol {
    func someMethod() {}
}

/*
 // someMethod()が定義されていないため、コンパイルエラー
 struct SomeStruct2: SomeProtocol{}
 */

/*
 クラスでは、クラスの継承とプロトコルへの準拠という2種類のものが同じ書式となる
 
 // スーパークラスを1番目に指定してプロトコルは2番目以降に指定する
 class クラス名: スーパークラス, プロトコル名1, プロトコル名2... {
    // クラスの定義
 }
 */

protocol SomeProtocol2 {}

class SomeSuperClass {}

class SomeClass: SomeSuperClass, SomeProtocol2 {}


/*
 エクステンションによる準拠方法
 
 1つのエクステンションで複数のプロトコルに準拠することもできるが、
 1つのプロトコルに対して1つのエクステンションを定義することで、プロパティ、メソッドとプロトコルの対応が明確になる
 複数のプロトコルに準拠する時などは特に、どのプロパティやメソッドがどのプロトコルで宣言されているものなのか分かりにくくなりがちなので、エクステンションを利用すればコードの可読性を高めることができる
 
 [定義]
 extension エクステンションを定義する対象の型: プロトコル名 {
    // プロトコルが要求する要素の定義
 }
 */

protocol SomeProtocol3 {
    func someMethod1()
}

protocol SomeProtocol4 {
    func someMethod2()
}

struct SomeStruct2 {
    let someProperty: Int
}

extension SomeStruct2: SomeProtocol3 {
    func someMethod1() {}
}

extension SomeStruct2: SomeProtocol4 {
    func someMethod2() {}
}


/*
 コンパイラによる準拠チェック
 プロトコルの要求を満たしているかどうかはコンパイラによってチェックされ、準拠するプロトコルが要求している
 インタフェースが一つでも欠けていれば、コンパイルエラーとなる
 */

protocol RemoteObject {
    var id: Int {get}
}

/*
// ArticleはRemoteObjectへの準拠を宣言しているが、
// idプロパティが実装されていないため、コンパイルエラー
struct Article: RemoteObject {
}
*/


/*
 プロトコルの利用方法
 プロトコルは構造体、クラス、列挙型、クロージャと同様に、変数、定数や引数の型として使用できる
 プロトコルに準拠している型はプロトコルにアップキャスト可能であるため、型がプロトコルの変数や定数に代入できる
 型がプロトコルの変数と定数では、プロトコルで定義されているプロパティやメソッドを使用できる
 
 
 関連型を持つプロトコルは変数、定数や引数の型として使用することはできず、ジェネリクスの型引数の型制約の記述のみ利用できる
 */

protocol SomeProtocol5 {
    var variable: Int {get}
}

func someMethod(x: SomeProtocol5) {
    // 引数xのプロパティやメソッドのうち
    // SomeProtocol5で定義されているものが使用可能
    print(x.variable)
}

/*
 プロトコルコンポジション：複数のプロトコルの組み合わせ
 プロトコルコンポジション（protocol composition）：複数のプロトコルに準拠した型を表現するための仕組み
 
 [定義]
 プロトコル名1 & プロトコル名2
 */

protocol SomeProtocol6 {
    var variable1: Int {get}
}

protocol SomeProtocol7 {
    var variable2: Int {get}
}

struct SomeStruct3: SomeProtocol6, SomeProtocol7 {
    var variable1: Int
    var variable2: Int
}

func someFunction(x: SomeProtocol6 & SomeProtocol7) {
    print(x.variable1 + x.variable2)
}

let a = SomeStruct3(variable1: 1, variable2: 2)
someFunction(x: a)


/*
 プロトコルを構成する要素
 
 プロトコルには、プロパティを定義でき、プロトコルに準拠する型にプロパティの実装を要求できる
 
 プロトコルのプロパティでは、プロパティ名、型、ゲッタとセッタの有無のみを定義し、
 プロトコルに準拠する型で要求に応じてプロパティを実装する
 プロトコルのプロパティは常にvarキーワードで宣言し、{}内にゲッタとセッタの有無に応じて
 それぞれgetキーワードとsetキーワードを追加する。
 letキーワードが使用できないのは、プロトコルのプロパティはストアドプロパティやコンピューテッドプロパティといった区別がないため
 
 [定義方法]
 protocol プロトコル名 {
    var プロパティ名: 型 {get set}
 }
 */

protocol SomeProtocol8 {
    var someProperty: Int {get set}
}


/*
 ゲッタの実装
 プロパティが定義されているプロトコルに準拠するには、プロトコルで定義されているプロパティを実装する必要がある
 プロパティがゲッタしかない場合は、変数または定数のストアドプロパティを実装するか、ゲッタを持つコンピューテッドプロパティを実装する
 */

protocol SomeProtocol9 {
    var id: Int {get}
}

// 変数のストアドプロパティ
struct SomeStruct4: SomeProtocol9 {
    var id: Int
}

// 定数のストアドプロパティ
struct SomeStruct5: SomeProtocol9 {
    let id: Int
}

// コンピューテッドプロパティ
struct SomeStruct6: SomeProtocol9 {
    var id: Int {
        return 1
    }
}


/*
 セッタの実装
 プロトコルで定義されているプロパティがセッタも必要としている場合は、変数のストアドプロパティを実装するか、
 ゲッタとセッタの両方を持つコンピューテッドプロパティを実装する
 なお、定数のストアドプロパティでは変更が不可能なため、プロトコルの要求を満たすことはできない
 */

protocol SomeProtocol10 {
    var title: String {get set}
}

// 変数のストアドプロパティ
struct SomeStruct7: SomeProtocol10 {
    var title: String {
        get {
            return "title"
        }
        
        set {}
    }
}

/*
 // 定数のストアドプロパティ
 struct SomeStruct3: SomeProtocol10 {
    let title: Int // コンパイルエラー
 }
 */

/*
 メソッド
 プロトコルにはメソッドを定義でき、プロトコルに準拠する型にメソッドの実装を要求できる
 
 プロトコルのメソッドでは、メソッド名、引数の型、戻り値の型のみを定義し、プロトコルに準拠する型で
 その要求を満たす実装を提供する
 プロトコルの定義では、実装を伴わないため、{}を省略する
 */

protocol SomeProtocol11 {
    func someMethod() -> Void
    static func someStaticMethod() -> Void
}


struct SomeStruct8: SomeProtocol11 {
    func someMethod() {
        // メソッドの実装
    }
    
    static func someStaticMethod() {
        // メソッドの実装
    }
}

/*
 mutatingキーワード：値型のインスタンスの変更を宣言するキーワード
 プロトコルへの準拠のチェックでは、値型のインスタンスを変更し得るメソッドと変更しないメソッドは区別される
 
 値型のインスタンスを変更し得るメソッドをプロトコルに定義する場合には、プロトコル側のメソッドの定義に
 mutatingキーワードを追加する必要がある
 
 参照型のメソッドでは、mutatingキーワードによってインスタンスの変更の有無を区別する必要がないので、
 クラスをプロトコルに準拠させる際にmutatingキーワードを追加する必要がない
 */

protocol SomeProtocol12 {
    mutating func someMutatingMethod()
    func someMethod()
}

// 構造体
struct SomeStruct9: SomeProtocol12 {
    var number: Int
    
    mutating func someMutatingMethod() {
        number = 1
    }
    
    func someMethod() {
        // SomeStructの値を変更する処理を入れることはできないため
        // コンパイルエラー
        // number = 1
    }
}

class SomeClass2: SomeProtocol12 {
    var number = 0
    
    func someMutatingMethod() {
        number = 1
    }
    
    func someMethod() {
        // SomeClassの値を変更する処理を入れることができる
        number = 1
    }
}


/*
 関連型：プロトコルの準拠時に指定可能な型
 
 プロトコルの定義時にプロパティの型やメソッドの引数や戻り値の型を具体的に指定する必要がある
 
 しかし、関連型（associated type）を用いると、プロトコルの準拠時にこれらの型を指定できる
 プロトコルの側では、関連型はプレースホルダーとして働き、関連型の実際の型は準拠する型の方で指定する
 関連型を使用すれば、1つの型に依存しない、より抽象的なプロトコルを定義できる
 
 プロトコルの関連型の名前は、associatedtypeキーワードを用いて定義する
    - プロトコルの関連型は、同じプロトコル内のプロパティやメソッドの引数や戻り値の型として使用できる
    - 関連型の実際の型は、プロトコルに準拠する型ごとに指定できる
    - 関連型の実際の型の指定には、型エイリアスを使用し、準拠する型の定義の内部で、¥関連型と同名の型エイリアスをtypealias 関連型名 = 指定する型名と定義する
    - ただし、実装から関連型が自動的に決定する場合は、型エイリアスの定義を省略できる
    - 関連型は、型エイリアスだけでなく、同名のネスト型によって指定できる
 
 [定義]
 protocol プロトコル名 {
    associatedtype 関連型名
    
    var プロパティ名: 関連型名
    func メソッド名(引数名: 関連型名)
    func メソッド名() -> 関連型名
 }
 */

protocol SomeProtocol13 {
    associatedtype AssociatedType
    
    // 関連型はプロパティやメソッドでも使用可能
    var value: AssociatedType {get}
    func someMethod(value: AssociatedType) -> AssociatedType
}

// AssociatedTypeを定義することで要求を満たす
struct SomeStruct10: SomeProtocol13 {
    typealias AssociatedType = Int
    
    var value: AssociatedType
    
    func someMethod(value: AssociatedType) -> AssociatedType {
        return 1
    }
}

// 実装からAssociatedTypeが自動的に決定する
struct SomeStruct11: SomeProtocol13 {
    var value: Int
    
    func someMethod(value: Int) -> Int {
        return 1
    }
}

// ネスト型AssociatedTypeを定義することで要求を満たす
struct SomeStruct12: SomeProtocol13 {
    // ネスト型AssociatedTypeを定義
    struct AssociatedType {}
    
    var value: AssociatedType
    func someMethod(value: AssociatedType) -> AssociatedType {
        return AssociatedType()
    }
}

// 関連値を利用して1つの型に依存しない抽象的な性質を定義できる
protocol RandomValueGenerator {
    associatedtype Value
    
    func randomValue() -> Value
}

struct IntegerRandomValueGenerator: RandomValueGenerator {
    func randomValue() -> Int {
        return Int.random(in: Int.min...Int.max)
    }
}

struct StringRandomValueGenerator: RandomValueGenerator {
    func randomValue() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        let offset = Int.random(in: 0..<letters.count)
        let index = letters.index(letters.startIndex, offsetBy: offset)
        return String(letters[index])
    }
}

/*
 型制約の追加
 プロトコルの関連型が準拠すべきプロトコルや継承すべきスーパークラスを指定して、関連型に制約を設けることができる
 制約を追加するには、関連型の宣言の後に「:」を追加し、プロトコル名やスーパークラス名を続ける。
 関連型が型の制約を満たすかどうかはコンパイラによってチェックされ、満たさない場合にコンパイルエラーとなる
 
 プロトコル名に続けて「where節」を追加すると、より詳細な制約を指定できる
 where節では、プロトコルに準拠する型自身をSelfキーワードで参照でき、
 その関連型も「.」を付けてSelf.関連型のように参照できる
 また、Selfキーワードを省略として関連型とすることもできます。
 「.」を続けてSelf.関連型.関連型の関連型と記述することで、関連型の関連型も参照できる
 
 [定義]
 protocol プロトコル名 {
    associatedtype 関連型名: プロトコル名またはスーパークラス名
 }
 */

class SomeClass3{}

protocol SomeProtocol14 {
    associatedtype AssociatedType: SomeClass3
}

class SomeSubclass: SomeClass3 {}

// SomeSubclassはSomeClass3のサブクラスなのでAssociatedTypeの制約を満たす
struct ConformedStruct: SomeProtocol14 {
    typealias AssociatedType = SomeSubclass
}

/*
// IntはSomeClassのサブクラスではないのでコンパイルエラー
struct NonConformedStruct: SomeProtocol14 {
    typealias AssociatedType = Int
}
*/


// where節
protocol Container {
    associatedtype Content
}

protocol SomeData {
    // 関連型ValueContainerの関連型ContentがEquatableプロトコルに準拠するという制約を設けている
    associatedtype ValueContainer: Container where ValueContainer.Content: Equatable
}

// ==による型の一致の制約も設定できる
protocol Container2 {
    associatedtype Content
}

protocol SomeData2 {
    associatedtype ValueContainer: Container2 where ValueContainer.Content == Int
}

/*
 型制約を複数指定する場合は、制約1, 制約2, 制約3のように「,」区切りで並べる
 */

protocol Container3 {
    associatedtype Content
}

// SomeData3プロトコルの関連型ValueContainerの関連型Contentが、
// Equatableプロトコルに準拠し、なおかつ別の関連型Valueと一致するという制約を設けている
protocol SomeData3 {
    associatedtype Value
    associatedtype ValueContainer: Container3 where ValueContainer.Content: Equatable, ValueContainer.Content == Value
}


/*
 デフォルトの型の指定
 プロトコルの関連型には、宣言と同時にデフォルトの型を指定できる
 関連型にデフォルトの型を設定すれば、プロトコルに準拠する型側での関連型の指定が任意となる
 */

protocol SomeProtocol15 {
    associatedtype AssociatedType = Int
}

// AssociatedTypeを定義しなくてもSomeProtocolに準拠できる
struct SomeStruct13: SomeProtocol15 {
    // SomeStruct.AssociatedTypeはIntとなる
}


/*
 プロトコルの継承
 プロトコルは他のプロトコルを継承できる
 プロトコルの継承は、単純に継承元のプロトコルで定義されているプロパティやメソッドなどを
 プロトコルに引き継ぐものであり、クラスにおけるオーバーライドのような概念はない
 また、型をプロトコルに準拠させる場合と同様に、プロトコルは複数のプロトコルを継承できる
 */

protocol ProtocolA {
    var id: Int {get}
}

protocol ProtocolB {
    var title: String {get}
}

// ProtocolCはid, titleの2つを要求するプロトコルとなる
protocol ProtocolC: ProtocolA, ProtocolB {}


/*
 クラス専用プロトコル
 プロトコルは準拠する型をクラスのみに限定でき、このようなプロトコルをクラス専用プロトコル(class-only protocol)という。

 プロトコルの継承リストの先頭にclassキーワードを指定する
 
 [定義]
 protocol SomeClassOnlyProtocol: classs {}
 */


/*
 プロトコルエクステンション：プロトコルの実装の定義
 エクステンションはプロトコルにも定義でき、これをプロトコルエクステンション（protocol extension）という。
 プロトコルエクステンションはプロトコルが要求するインタフェースを追加するものではなく、
 プロトコルに実装を追加するものである。
 プロトコルエクステンションでは、通常のエクステンションと同様の実装を行える
 
 [定義]
 extension プロトコル名 {
    対象のプロトコルに実装する要素
 }
 */

protocol Item {
    var name: String {get}
    var category: String {get}
}

extension Item {
    var description: String {
        return "商品名: \(name), カテゴリ: \(category)"
    }
}

struct Book: Item {
    let name: String
    
    var category: String {
        return "書籍"
    }
}

let book = Book(name: "Swift実践入門")
print(book.description)


/*
 デフォルト実装による実装の任意化
 
 プロトコルに定義されているインタフェースに対して、プロトコルエクステンションで実装を追加すると、
 プロトコルに準拠する型での実装は任意となる。
 準拠する型が実装を再定義しなかった場合はプロトコルエクステンションの実装が使用されるため、
 これをデフォルト実装（dfault implementation）という
 */

// デフォルト実装による実装の任意化
protocol Item2 {
    var name: String {get}
    var caution: String? {get}
}

extension Item2 {
    var caution: String? {
        return nil
    }
    
    var description: String {
        var description = "商品名: \(name)"
        
        if let caution = caution {
            description += "、注意事項: \(caution)"
        }
        
        return description
    }
}

struct Book2: Item2 {
    let name: String
}

struct Fish: Item2 {
    let name: String
    
    var caution: String? {
        return "クール便での配送となります"
    }
}

let book2 = Book2(name: "Swift実践入門")
print(book2.description)

let fish = Fish(name: "秋刀魚")
print(fish.description)

/*
 型制約の追加
 プロトコルエクステンションには型制約を追加でき、条件を満たす場合のみ
 プロトコルエクステンションを有効にできる
 プロトコルエクステンションの型制約は、プロトコル名に続くwhere節内に記述する
 
 [定義]
 extension プロトコル名 where 型制約 {
    制約を満たす場合に有効となるエクステンション
 }
 */

extension Collection where Element == Int {
    var sum: Int {
        return reduce(0) { $0 + $1 }
    }
}

let integers = [1, 2, 3]
print(integers.sum)

/*
 // stringsの要素は、where Element == Intを満たさないのでコンパイルエラー
 let strings = ["a", "b", "c"]
 strings.sum
 */
