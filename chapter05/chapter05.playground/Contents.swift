import Foundation

/*
 制御構文：プログラムの実行フローを制御する構文
 
 実行フローの制御
    - 条件分岐
    - 繰り返し
 
 通常、プログラムは上から下へ逐次実行されるが、条件に応じて処理を切り替えたり、処理を複数回繰り返したりすることもできる
 
 Swiftでは、条件分岐や繰り返しのための構文が複数存在するので、目的と使用方法を理解し、正しく使い分ける必要がある
 */

/*
 条件分岐：条件に応じて処理を切り替える処理
 条件ん分岐文：条件分岐を行う文
    - (ex)
        - if
        - guard
        - switch
 
 if文：条件の成否による分岐
 [記述方法]
 if 条件式 {
    条件式がtrueの場合に実行される文
 }
 
 ifの条件式は、Boolの値を返す必要がある。Boolの値を返さない場合は、コンパイルエラーになる。
    - 一部の言語では、Int型やString型でもコンパイルエラーにならないものもあるが、Swiftでは直感的ではない仕様を排除している
    - Boolを返す式
        - (ex)
            - 比較式

 else節：条件不成立時の処理
 [記述方法]
 if 条件式 {
    // 条件式がtrueの場合に実行される文
 } else {
    // 条件式がfalseの場合に実行される文
 }
 
 else if節
 [記述方法]
 if 条件式1 {
    // 条件式1がtrueの場合に実行される文
 } else if 条件式2 {
    // 条件式1がfalseかつ条件式2がtrueの場合に実行される文
 } else {
    // 条件式1と条件式2の両方がfalseの場合に実行される文
 }
 
 */

let value = 2

if value <= 3 {
    print("valueは3以下です")
}


let value2 = 1

if 0 < value2 {
    print("value2は0より大きい値です")
}

/*
 [bad]
 let value = 1
 
 if value {
    // コンパイルエラー
 }
 */


// else節
let value3 = 4

if value <= 3 {
    print("valueは3以下です")
} else {
    print("valueは3より大きいです")
}


// else if節
let value4 = 2

if value < 0 {
    print("valueは0未満です")
} else if value <= 3 {
    print("valueは0以上3以下です")
} else {
    print("valueは3より大きいです")
}

/*
 if-let文：値の有無による分岐
    - オプショナルバインディングを行う条件分岐文
    - Optional<Wrapped>型の値の有無に応じて分岐を行い、値が存在する場合には値の取り出しも同時に行う
 
 [記述方法]
 if let 定数名 = Optional<Wrapped>型の値 {
    // 値が存在する場合に実行される文
 } else {
    // 値が存在しない場合に実行される文
 }
 
 if-let文は、複数のOptional<Wrapped>型の値を同時に取り出すことが可能
    - Optional<Wrapped>型の値を右辺に持つ定数定義を「,」区切りで並べると、すべての右辺が値を持っていた場合にのみ、if文の実行文が実行される
 
 
 if-letとas?演算子による型のダウンキャストが行える
    - 型による条件分岐を安全に行える
 
 if-let文で定義された定数は、{}内のみ使用できる
 */

// if-let文
let optionalA = Optional(1)

if let a = optionalA {
    print("aの値は\(a)です")
} else {
    print("値が存在しません")
}

// if-let（複数のOptional<Wrapped>）
let optionalA2 = Optional("a")
let optionalB2 = Optional("b")

if let a = optionalA2, let b = optionalB2 {
    print("aとbの値は\(a)と\(b)です")
} else {
    print("どちらかの値が存在しません")
}

// if-letとas?の組み合わせによるダウンキャスト
let a: Any = 1

if let int = a as? Int {
    print("値はInt型の\(int)です")
}

/*
 [bad]
 let a: Any = 1
 
 if let int = a as? Int {
    // intは使用可能
 }

 // intは使用不可能なためコンパイルエラー
 print(int)
 */

/*
 guard文：条件不成立時に早期退出する分岐
    - 条件式の評価結果がBool型の値に応じた処理を行う
    - 後続の処理を行うにあたってtrueとなっているべき条件を指定
 
 [記述方法]
 
 guard 条件式 else {
    // 条件式がfalseの場合に実行される文
    // guard文が記述されているスコープの外に退出する必要がある
 }
 
 guard文のスコープの外への退出の強制
 guard文のelse節では、guard文が含まれるスコープから退出しなければいけない
 スコープからの退出は、コンパイラによってチェックされるため、guard文を通過した後では、guard文の条件式が必ず成り立っていることがコンパイル時に保証される
 
 guard文で宣言された変数や定数へのアクセス
    - guard-letを利用する
    - guard-letで宣言された変数や定数は、guard-let文以降で利用可能
        - 条件式が満たされなかった場合には、スコープから退出することが保証されているため
 
 */

func someFunction() {
    let value4 = -1
    
    guard 0 <= value4 else {
        print("0未満の値です")
        return
    }
}

someFunction()

// gaurd文を含むスコープからの早期退出
func printIfPositive(_ a: Int) {
    // else節では、guard文を含むスコープから退出しなければならないので、
    // pirntIfPositive(_:)関数から退出する必要がある -> returnの利用
    guard 0 < a else {
        return
    }
    
    // guard文以降では、0 < aが成り立つことが保証される
    print(a)
}

printIfPositive(1)

// guard-let文
func someFunction2() {
    let a: Any = 1
    
    guard let int = a as? Int else {
        print("aはInt型ではありません")
        return
    }
    
    // intはguard文以降でも利用可能
    print("値はInt型の\(int)です")
}

someFunction2()

func add(_ optionalA: Int?, _ optionalB: Int?) -> Int? {
    let a: Int
    
    if let unwrappedA = optionalA {
        a = unwrappedA
    } else {
        print("第1引数に値が入っていません")
        return nil
    }
    
    let b: Int
    
    if let unwrappedB = optionalB {
        b = unwrappedB
    } else {
        print("第2引数に値が入っていません")
        return nil
    }
    
    return a + b
}

print(add(Optional(1), Optional(2)))

func add2(_ optionalA: Int?, _ optionalB: Int?) -> Int? {
    
    guard let a = optionalA else {
        print("第1引数に値が入っていません")
        return nil
    }
    
    guard let b = optionalB else {
        print("第2引数に値が入っていません")
        return nil
    }
    
    return a + b
}

print(add2(Optional(1), Optional(2)))


/*
 switch文：複数のパターンマッチによる分岐
    - 各パターンは、caseキーワードで定義し、どのパターンにもマッチしなかった場合の実行文はdefaultキーワードでデフォルトケースとして定義する
    - 上から順に評価し、マッチしたパターンの実行文が実行される
    - switch文では、一度マッチして実行文を実行するとマッチングが終了し、それ以降のパターンマッチはスキップする
    - 重複したパターンを記述しても、重複したパターンのうち先頭となるパターン以外は意味を成さない
    - 複数のケースを持つ条件分岐に向いている
 
 [記述方法]
 switch 制御式 {
    case パターン1:
        制御式がパターン1にマッチした場合に実行される文
    case パターン2:
        制御式がパターン2にマッチした場合に実行される文
    default:
        制御式がいずれかのパターンにもマッチしなかった場合に実行される文
 }
 
 switchを利用したケースの網羅性のチェック
 - switch文では、コンパイラによってケースの網羅性がチェックされ、網羅されていない場合はコンパイルエラーとなる
 - 網羅性を満たすためには、制御式の型が取り得るすべての値をケースで記述する必要がある
 
 defaultキーワード：デフォルトケースによる網羅性の保証
 - defaultケース：他のいずれのケースにもマッチしない場合にマッチするケース
 - defaultキーワードで定義
 - 列挙型の制御式に対してデフォルトケースを用意することは極力避け、個々のケースを列挙するほうが好ましい
    - switch文がデフォルトケースを持っている場合、列挙型に新たなケースが追加されたとしても、それが自動的にデフォルトケースにマッチしてしまうため。この場合、網羅性は保たれたままになるので、コンパイルエラーは発生しない。
    - 列挙型に新たに追加されたケースはプログラムの至るところで暗黙的にデフォルトケースとして扱われ、意図していない動作を招く危険性がある
    - デフォルトケースの濫用は、変更に弱いプログラムを招く
 - デフォルトケースを利用せずにswitch文で列挙型の個々のケースを列挙する場合、列挙型に新たなケースが追加されると、既存のswitch文が網羅できなくなるためコンパイルエラーとなる。このコンパイルエラーは、新しく追加されたケースに対処するための実装をどこに追加するべきかを明らかにする
 
 
 whereキーワード：ケースにマッチする条件の追加
 
 [記述方法]
 switch 制御式 {
 case パターン where 条件式:
    制御式がパターンにマッチし、かつ、条件式を満たす場合に実行される文
 default:
    条件式がいずれのパターンにもマッチしなかった場合に実行される文
 }
 
 
 break：ケースの実行の中断
 break文：switch文のケースの実行を中断する文
    - breakキーワードのみか、breakキーワードとラベルの組み合わせで構成される
 途中で中断する必要がない限り、break文は必須ではない
 ケース内には、少なくとも1つの文が必要であるため、デフォルトケース内のような、何も処理が存在しない場合にはbreak文が必須である
 
 
 ラベル：break文の制御対象の指定
 ラベル：break文の制御対象を指定するための仕組みである
    - switch文が入れ子になっている場合など、break文の対象となるswitch文を明示する必要があるケースで利用
 
 [記述方法]
 ラベル名: switch文
 
 
 fallthrough：switch文の次のケースへの制御の移動
 fallthrough：switch文のケースの実行を終了し、次のケースを実行する制御構文
 */

let a2 = 1

switch a2 {
case Int.min..<0:
    print("aは負の値です")
case 1..<Int.max:
    print("aは正の値です")
default:
    print("aは0です")
}

// switch文による網羅性のチェック
enum SomeEnum {
    case foo
    case bar
    case baz
}

let foo = SomeEnum.foo

switch foo {
case.foo:
    print(".foo")
case .bar:
    print(".bar")
case .baz:
    print(".baz")
}

/*
 [bad]
 enum SomeEnum {
    case foo
    case bar
    case baz
 }
 
 let foo = SomeEnum.foo

 // 網羅されていないため、コンパイルエラーになる
 switch foo {
 case .foo:
    print(".foo")
 case .bar:
    print(".bar")
 }
 */

let a3 = true

switch a3 {
case true:
    print("true")
case false:
    print("false")
}

// default
// 列挙型に対しては、default文の利用は避ける

enum SomeEnum2 {
    case foo
    case bar
    case baz
}

let baz = SomeEnum2.baz

switch baz {
case .foo:
    print(".foo")
case .bar:
    print(".bar")
default:
    print("Default")
}

// whereキーワードの利用
let optionalA3: Int? = 1

switch optionalA3 {
case .some(let a) where 10 < a:
    print("10より大きい値\(a)が存在します")
default:
    print("値が存在しない、もしくは10以下です")
}

// break
let a4 = 1

switch a4 {
case 1:
    print("実行される")
    break
    print("実行されない")
default:
    break
}

// ラベル
let value5 = 0 as Any

outerSwitch: switch value5 {
case let int as Int:
    let description: String
    switch int {
    case 1, 3, 5, 7, 9:
        description = "奇数"
    case 2, 4, 6, 8, 10:
        description = "偶数"
    default:
        print("対象外の数字です")
        break outerSwitch
    }
    
    print("値は\(description)です")
    
default:
    print("対象外の型の値です")
}


// fallthrough
// C言語のように自動的には、次のcaseが実行されることはない
let a5 = 1

switch a5 {
case 1:
    print("case 1")
    fallthrough
    
case 2:
    print("case 2")
    
default:
    print("default")
}


/*
 繰り返し：処理を複数回実行すること
 
 繰り返しを行う制御構文
    - (ex)
        - for-in：シーケンスの要素数による
        - while：継続条件の評価による
        - repeat-while：実行文の初回実行を保証する
 
 for-in文：シーケンスの要素の列挙
 for-in文：Sequenceプロトコルに準拠した型の要素にアクセスするための制御構文
 Sequenceプロトコルに準拠した型
    - Array<Element>
    - Dictionary<Key, Value>
 
 [記述方法]
 for 要素名 in シーケンス {
    要素ごとに繰り返し実行される文
 }
 
 
 while文：条件式が成り立つ限り繰り返し続ける制御構文
 - while文は、実行文の実行前に条件式を評価するため、場合によっては一度も処理が行われない可能性がある
 - 繰り返し回数は、0回以上
 
 [記述方法]
 while 条件式 {
    条件式が成立する間、繰り返し実行される文
 }
 
 条件式の成否にかかわらず、必ず1回以上の繰り返しを実行したい場合、repeat-whileを利用
 repeat-while文では、条件式は実行文の実行後に評価される
 
 [記述方法]
 repeat {
    1回は必ず実行され、それ以降は条件式が成立する限り繰り返し実行される文
 } while 条件式
 
 break文やcontinue文を用いることで、実行文を中断できる。ラベルを使用することで制御指定もできる
 break：繰り返し文全体を終了させる
 continue：現在の処理のみを中断し、後続の処理を継続する
 
 ラベルの利用
 [記述方法]
 ラベル名: 繰り返し文
 
 break ラベル名
 continue ラベル名
 */

let array = [1, 2, 3]

for element in array {
    print(element)
}

// Dictionary<Key, Value>に対するfor-in
// Dictionary<Key, Value>は順番が保証されているわけではない
let dictionary = ["a": 1, "b": 2]

for (key, value) in dictionary {
    print("Key: \(key), Value: \(value)")
}

// while
var a6 = 1

while a6 < 4 {
    print(a6)
    a6 += 1
}

// repeat-whileとwileの比較
var a7 = 1

repeat {
    print(a7)
    a7 += 1
} while a7 < 1

var a8 = 1

while a8 < 1{
    print(a8)
    a8 += 1
}

// break
var containsTwo = false
let array2 = [1, 2, 3]

for element in array2 {
    if element == 2 {
        containsTwo = true
        break
    }
    
    print("element: \(element)")
}

print("containsTwo: \(containsTwo)")

// continue
var odds = [Int]()
let array3 = [1, 2, 3]

for element in array3 {
    if element % 2 == 1 {
        odds.append(element)
        continue
    }
    
    print("even: \(element)")
}

print("odds: \(odds)")

// ラベルの利用
label: for element in [1, 2, 3] {
    for nestedElement in [1, 2, 3] {
        print("element: \(element), nestedElement: \(nestedElement)")
        break label
    }
}

/*
 遅延実行：特定の文をそれが記述されている箇所よりもあとで実行すること
 
 defer文：スコープ退出時の処理
 defer文：{}内のコードは、defer文が記述されているスコープの退出時に実行される
    - リソースの解放などに利用
    - 実行フローの内容にかかわらず、スコープの退出時に確実に実行されて欲しい処理を記述する
 */

// defer
var count = 0

func someFunction3() -> Int {
    defer {
        count += 1
    }
    
    return count
}

print(someFunction3())
print(count)


/*
 パターンマッチ：値の構造や性質による評価
 パターン：値の持つ構造や性質を表現する
 パターンマッチ：値が特定のパターンに合致するか検査すること
 
 パターンの種類
 - 式パターン
 - バリューバインディングパターン
 - オプショナルパターン
 - 列挙型ケースパターン
 - is演算子による型キャスティングパターン
 - as演算子による型キャスティングパターン
 */

/*
 式パターン(expression pattern)：~=演算子による評価を行うパターン
    - 式パターンは式のみで構成され、式 ~= 評価する値がtrueを返す場合にマッチする
    - ~=演算子に対する評価結果は比較する型ごとに定義されており、独自に~=の評価を定義することもできる
    - 標準ライブラリでは基本的な型に対して~=演算子が定義されている
        - (ex)
            - 範囲型のマッチングでは、指定した値が範囲に含まれるかどうかを判定するcontains(_:)で評価される
            - Int型やString型などの==演算子で比較可能な型のマッチングでは==演算子で評価されるようになっている
 */

let integer = 9

switch integer {
case 6:
    print("match: 6")
case 5...10:
    print("match: 5...10")
default:
    print("default")
}

/*
 バリューバインディングパターン：値の代入を伴う評価
 バリューバインディングパターン（value-binding pattern）：値を変数や定数に代入するためのパターン
    - varまたはletキーワードと他のパターンを組み合わせて使用
    - バリューバインディングパターンと組み合わせられる代表的なパターンは、識別子パターン
    - 識別子パターン：変数名または定数名で構成され、どのような値にもマッチし、値をその名前を持つ変数や定数に代入する
    - バリューバインディングパターンと組み合わせた場合、定数や変数を宣言して代入を行うという動作になる
 */

// バリューバインディングパターン
let value6 = 3

switch value6 {
case let matchedValue:
    print(matchedValue)
}

/*
 オプショナルパターン：Optional<Wrapped>型の値の有無を評価
 オプショナルパターン（optional pattern）：Optional<Wrapped>型の値の有無を評価するパターン
 値を持つOptional<Wrapped>型にマッチする
 */

// オプショナルパターン
let optionalA4 = Optional(4)

switch optionalA {
case let a?:
    // 4が出力される
    print(a)
default:
    print("nil")
}

/*
 列挙型ケースパターン：ケースとの一致の評価
 列挙型ケースパターン（enumeration case pattern）：列挙型のケースとの一致を評価するパターン
 列挙型ケースパターンは、評価式がOptional<Wrapped>型かつWrapped型が列挙型の場合、Wrapped型のケースでマッチングが行える
 列挙型ケースパターンは、「ケース名(パターン, パターン, ...)」という形式で他のパターンと組み合わせると、関連値のパターンマッチも可能になる
 関連値：列挙型のケースに紐づいた付加情報であり、同一のケースでも異なる関連値を持つことができる
 */

// 列挙型ケースパターン
enum Hemisphere {
    case norhern
    case southern
}

let hemisphere = Hemisphere.norhern

switch hemisphere {
case .norhern:
    print("match: .northern")
case .southern:
    print("match: .southern")
}

// 列挙型：Optional<Wrapped>, Wrappedが列挙型の場合
enum Hemisphere2 {
    case northern
    case southern
}

let hemisphere2 = Optional(Hemisphere2.northern)
// Optional<Wrapped>の場合、case nilが必要
switch hemisphere2 {
case .northern:
    print("match: .northern")
case .southern:
    print("match: .southern")
case nil:
    print("nil")
}

// 列挙型ケースパターン, 関連値のパターンマッチ, バリューバインディングパターン
enum Color {
    case rgb(Int, Int, Int)
    case cmyk(Int, Int, Int, Int)
}

let color = Color.rgb(100, 200, 255)

switch color {
case .rgb(let r, let g, let b):
    print(".rgb: \(r), \(g), \(b)")
    
case .cmyk(let c, let m, let y, let k):
    print(".cmyk: \(c), \(m), \(y), \(k)")
}


/*
 is演算子による型キャスティングパターン：型の判定による評価
 型キャスティングパターン(type-casting pattern)：型のキャストによって評価を行うパターン
 型キャスティングパターン
    - is演算子：is 型名
        - is演算子による評価結果がtrueであればマッチする
    - as演算子：パターン as 型名
        - パターンの式がダウンキャストに成功した場合、マッチする
 */

// 型キャスティングパターン（is演算子）
let any: Any = 1

switch any {
case is String:
    print("match: String")
    
case is Int:
    print("match: Int")
    
default:
    print("default")
}

// 型キャスティングパターン（as演算子）
let any2: Any = 1

switch any2 {
case let string as String:
    print("match: String(\(string))")
    
case let int as Int:
    print("match: Int(\(int))")
    
default:
    print("default")
}

/*
 パターンマッチが使える場所
 switch文以外にif文、guard文、for-in文、while文でも条件にcaseキーワードを指定するとパターンマッチできる
 また、do文のcatch節でもパターンマッチできる
 
 switch文では、条件を網羅しなければならないため、多くの場合ケースを2つ以上書くことになる。
 一方、if文は条件を網羅する必要がないため、検証したいパターンマッチのみを書けば十分
 従って、条件を網羅する必要があるときはswitch文を選び、網羅する必要がないときはif文でのパターンマッチを使う
 */

/*
 if case パターン = 制御式 {
    制御式がパターンにマッチした場合に実行される文
 }
 */
let value7 = 9

if case 1...10 = value {
    print("1以上10以下の値です")
}

/*
 guard case パターン = 制御式 else {
    パターンにマッチしなかった場合に実行される文
    guard文が記述されているスコープの外に退出する必要がある
 }
 */

func someFunction4() {
    let value = 9
    guard case 1...10 = value else {
        return
    }
    
    print("1以上10以下の値です")
}

/*
 for-in文
 
 for case パターン in 値の連続 {
    要素がパターンにマッチした場合に実行される文
 }
 */

let array4 = [1, 2, 3, 4]

for case 2...3 in array4 {
    print("2以上2以下の値です")
}

/*
 while文
 
 while case パターン = 制御式 {
    制御式がパターンにマッチする間は繰り返し実行される文
 }
 */

var nextValue = Optional(1)

// オプショナルパターンでマッチ
while case let value? = nextValue {
    print("value: \(value)")
    
    if 3 <= value {
        nextValue = nil
    } else {
        nextValue = value + 1
    }
}
