import Foundation

/*
 - 型：値の特性と値への操作を表現したもの
    - Int型：整数を表現、整数を操作する為の四則演算などの機能を持つ
    - String型：文字列を表現、基本的な文字列操作の機能を持つ
 
 - 基本的な型
    - Bool型：真理値
    - Int型：整数
    - Float型とDouble型：浮動小数点
    - String：文字列
    - Optional<Wrapped>：値があるか空かのいずれか
    - Any：任意の値
    - タブル：複数の型をまとめる
 */

/*
 Bool型：真理値を表す型
 - 真理値：ある命題が真であるか偽であるかを表す値
 - 真理値リテラル：真理値を表すリテラル
    - true
    - false
 
 - 論理演算：真理値に対する演算
    - 否定：真理値の真偽を逆にする演算 -> 「!」を利用
    - 論理積：与えられた複数の真理値がいずれも真であれば、真となる論理演算 -> 「&&」を利用
    - 論理和
 */

// 真理値リテラル
let a = true
let b = false

// 否定
let a2 = true
let b2 = !a2
print(b2)

// 論理演算
let a3 = false && false
let b3 = false && true
let c = true && false
let d = true && true
print("a3：", a3)
print("b3：", b3)
print("c：", c)
print("d：", d)

/*
 数値型：数値を表す
 - 数値リテラル
 - 浮動小数点リテラル
 
 整数型
 - Int型：ビット数は、32ビットのプラットフォームでは32ビット、64ビットのプラットフォームでは64ビット
 - Int8型：8bit
 - Int16型：16bit
 - Int32型：32bit
 - Int64型：64bit
 
 最大値：maxプロパティでアクセス
 最小値：minプロパティでアクセス
 */

// 整数リテラル
// Int型
let a4 = 123
// 浮動小数点リテラル
// Double型
let a5 = 1.0

// 最大値
print(Int8.max)
// 最小値
print(Int8.min)

/*
 浮動小数点：浮動小数点方式で少数を表す数値型
 浮動小数点方式：ビットを桁の並びを表す仮数部と小数点の位置を表す指数部の2つにわけ、これら掛けて少数を表す方式
 - Float型：32bit
 - Double型：64bit
 
 - 浮動小数点型には、最小値や最大値を表すスタティックプロパティは用意されていない
 - Float型 -> 10^38の正負の数まで表すことができる -> 最小で6桁の精度
 - Double型 -> 10^308の正負の数まで表すことができる -> 最小で15桁の精度
 
 CGFloat型：画面上の座標
    - 32ビットプラットフォーム上では、Float型
    - 64ビットプラットフォーム上では、Double型
 
 CLLocationDegrees型：地球上の座標を表す
    - いずれのプラットフォームでも、Double型
 
 型エイリアス：型の別名
 typealias 新しい型名 = 型名
 
 浮動小数点型が持つスタティックプロパティ
 - isInfinite：無限大かどうかを表す -> 演算結果が無限大になったことを表す
 - isNaN：Not a Number（非数） -> 演算として不正な値が渡されてしまい、演算できなかったことを表す
 */

// Float型とDouble型の精度の違い
let a6: Double = 12345678.9
let b6: Float = 12345678.9
print("a6：", a6)
print("b6：", b6)

// infinity
let a7 = 1.0/0.0
print(a7.isInfinite)

let a8: Double = Double.infinity
print(a8.isInfinite)

// NaN（非数）
let a9: Double = 0.0/0.0
print(a9.isNaN)

let a10: Double = Double.nan
print(a10.isNaN)

/*
 Swiftでは、整数型どうしや浮動小数点型どうしであっても型が異なれば代入できない
 - 数値型を他の数値型に変換するには、イニシャライザを使用
 - イニシャライザ：他の数値型の値から自分の型の値を生成する
 - 生成したい型よりも、精度の高い型から初期化すると、生成したい型の精度に合わせて端数処理が行われる
 */

// let a: Int = 123
// bad： let b: Int64 = a

// let c: Float = 1.0
// bad: let d: Double = c

let a11: Int = 123
let b11: Int64 = Int64(a11)
print(b11)

let c2: Float = 1.0
let d2: Double = Double(c2)
print(d2)

// 精度が高い型から低い型にキャスト
let c3: Float = 1.99
let d3: Int = Int(c3)
print(d3)

let e: Double = 1.23456789
let f: Float = Float(e)
print(f)

/*
 比較演算子
 「==」:左辺と右辺が一致
 「!=」:左辺と右辺が不一致
 「>」:左辺が右辺よりも大きい
 「>=」:左辺が右辺以上
 「<」:左辺が右辺よりも小さい
 「>=」:左辺が右辺以下
 
 比較演算では、両辺の型を一致させる必要がある
    - 両辺の型が一致していないとコンパイルエラー
    - 暗黙的な型変換による想定外の桁の損失を防ぐ
 */
print(123 == 456)
print(123 != 456)
print(123 > 456)
print(123 >= 456)
print(123 < 456)
print(123 <= 456)

// 型を明示的にキャストする必要がある
let a12: Float = 123
let b12: Double = 123
// bad: print(a12 == b12)
print(a12 == Float(b12))

/*
 算術演算
 「+」：加算
 「-」：減算
 「*」：乗算
 「/」：除算
 「%」：剰余
 
 - 両辺の型が一致しない場合、コンパイルエラー
 - 異なる型どうしに対して、算術演算を行うには、明示的にキャストする必要がある
 
 複合代入演算子：演算子と代入演算子「=」を組み合わせた中置演算子
 「+=」：加算
 「-=」：減算
 「*=」：乗算
 「/=」：除算
 「%=」：剰余
 
 Foundationによる高度な操作
 コアライブラリのFoundationには、C言語のmath.h相当の数学関数が用意されている
    - 三角関数
        - sin(_:)
    - 対数関数
        - log(_:)
 
 Float型には、スタティックプロパティとして「円周率：pi」が用意されている
 */
print(1 + 1)
print(5 - 2)
print(2 * 4)
print(9 / 3)
print(7 % 3)

// 異なる型どうしの算術演算
let a13: Int = 123
let b13: Float = 123.0
// bad: print(a13 + b13)
print(a13 + Int(b13))

// 複合代入演算子
var a14 = 1
a14 += 6
print(a14)

var b14 = 1
b14 -= 4
print(b14)

var c14 = 1
c14 *= 2
print(c14)

var d14 = 6
d14 /= 2
print(d14)

var e14 = 5
e14 %= 2
print(e14)

// Foundationの利用
print(sin(Float.pi / 2.0))
print(log(1.0))


/*
 String型：文字列を表す型
 - 「Unicode」で定義された任意の文字が扱える
 
 文字列リテラル：文字列を表すリテラル
 let a = "ここに文字列を入れる"
 
 特殊文字列：「\」から始まる文字列
 - \n：ラインフィード
 - \r：キャリッジリターン
 - \"：ダブルクオート
 - \'：シングルクオート
 - \\：バックスラッシュ
 - \0：null文字
 
 文字列リテラル内での値の展開
 \()というエスケープシーケンスを用いて、値を文字列内に展開する
 
 複数行の文字列リテラル
 - 「"""」で囲む
 - 複数行の文字列リテラル内のインデントは、「最終行の"""の位置」が基準
    - 終了の"""よりも浅い位置のスペースはインデントと見なされ、リテラルから生成される文字列には含まれない
    - 終了の"""よりも深いスペースは、文字列とみなされる
 - 開始と終了の"""と同じ位置に文字列を書くとコンパイルエラー
 - 文字列は終了の"""と同じか、それよりも深い位置に書く。終了の"""よりもインデントが浅い位置に文字列があるとコンパイルエラー
 
 
 数値型と文字列型の相互変換
 - Stirng型と数値型の相互変換は、イニシャライザを利用
    - 数値型から文字列型: 失敗可能性はない
    - 文字列から数値型：失敗可能性がある
        - nilとなり得るOptional<Int>型の値を返却する
        - 失敗時は、nilを返す
 
 String型の操作
 比較
 - 一致の基準は、Unicodeの正準等価に基づく
 
 結合
 - 「+」or append()を利用
 
 Foundationによる高度な操作
 - 大文字と小文字を区別しない比較
 - 文字列探索
 */

// 文字列リテラル
let a15 = "ここに文字列を入れる"
print(a15)

// 特殊文字の利用
let a16 = "1\n2\n3"
print(a16)

// 文字列リテラルへの値の展開
let result = 7 + 9
print("result: \(result)")

let result2 = "優勝"
print("結果：\(result2)")

// 複数行の文字列リテラル
let haiku = """
五月雨を
あつめて早し
最上川
"""
print(haiku)

let haiku2 = """
  五月雨を
   あつめて早し
  最上川
  """
print(haiku2)

// 数値型と文字列型の相互変換
let i = 123
print(String(i))

let s1 = "123"
print(Int(s1))
let s2 = "abc"
print(Int(s2))

// 文字列比較
let string1 = "abc"
let string2 = "def"
print(string1 == string2)

// 文字列の結合
let a17 = "abc"
let b17 = "def"
let c17 = a17 + b17
print(c17)

var d17 = "abc"
let e17 = "def"
d17.append(e17)
print(d17)

// Foundationの利用
// 2つの文字列間の順序の比較
let options = String.CompareOptions.caseInsensitive
let order = "abc".compare("ABC", options: options)
print(order == ComparisonResult.orderedSame)

// 文字列の探索
print("abc".range(of: "bc"))


/*
 Optional<Wrapped>型：値があるか空のいずれかを表す型
 - nilを許容する必要がある場合は、Optional<Wrapped>型を利用
 - Wrapped：プレースホルダー、具体的な型に置き換えて利用する
    - Optinal<Int>
    - Optinal<String>
 - ジェネリクス型：<>内にプレースホルダー型を持つ型
 
 Optional<Wrapped>型の2つのケース
 - .none：値の不在
 - .some(Wrapped)：値の存在

 オプショナル型の定義
 enum Optional<Wrapped>{
    case none
    case some(Wrapped)
 }
 
 列挙型：複数の識別子をまとめる型。それぞれの識別子をケース
 
 値が存在しないケース：.noneはOptional<Wrapped>.noneで生成
 値が存在するケース：.someはOptional<Wrapped>.some(値)で生成
 Optional<Wrapped>.none -> nil
 Optional<Wrapped>.some(値) -> Optional(値)
 
 型推論
 - Optional<Wrapped>.some(値)を生成する場合、Wrapped型は.someに持たせる値から型推論可能
 - .noneは、Wrappedの部分を省略できない
 - .noneの生成で、<Wrapped>を省略するには、型アノテーションを利用して代入先の型を決定する
 
 リテラルを利用したOptional<Wrapped>型の生成
 - nilリテラルには、デフォルトの型が存在しないため、型アノテーションで型を決める
 - bad: let b = nil -> 定数の型が不明
 
 イニシャライザによる.someの生成
 - Optinal<Wrapped>型の.someは、値を引数にとるOptinal(_:)を利用して生成できる
 - プレースホルダーのWrappedは、イニシャライザに渡された値から型推論される
 
 値の代入による.someの生成
 - 変数や定数の型アノテーションなどによってOptional<Wrapped>型と決まっている場合は、値の代入による.someの生成が可能
 
 
 Optional<Wrapped>型のアンラップ：値の取り出し
 (ex)以下はコンパイルエラー
 let a: Int? = 1
 let b: Int? = 1
 print(a + b)
 
 - Optional<Wrapped>型の値からWrapped型の値を取り出す必要がある
 - アンラップ：Wrapped型の値を取り出すこと
    - オプショナルバインディング：条件分岐や繰り返し文の条件にOptional<Wrapped>型の値を指定する。値の存在が保証されている分岐内では、Wrapped型の値に直接アクセスできる。if-letを利用
    - ??演算子：値が存在しない場合のデフォルトの値を指定する演算子。
    - 強制アンラップ：!演算子によるOptional<Wrapped>型の値の取り出し
 
 オプショナルバインディング
 if let 定数名 = Optional<Wrapped>型の値 {
    値が存在する場合に実行される文
 }
 
 ??演算子
 - Optional<Wrapped>型に値が存在しない場合のデフォルト値を指定するには、中値演算子??を利用
 - ??の左辺には、Optional<Wrapped>型の値、右辺にはWrapped型の値を取る
 - 左辺のOptional<Wrapped>型が値を持っていれば、アンラップしたWrapped型の値を返す
 - 値を持っていなければ、右辺のWrapped型の値を返す
 
 強制アンラップ
 Optional<Wrapped>型からWrapped型の値を強制的に取り出す方法
 - 強制的により、値が存在しなければ、実行時エラーを引き起こす
 - !を利用
 - Swiftは、プログラムの誤りをできるだけコンパイル時に検出することで安全性を高めるという思想を持つ言語
 - 強制アンラップを多用することは、思想に反して、実行時までエラーの検出を先延ばしする行為
 - 値の存在がよほど明らかな場合以外は、利用を避ける
 
 
 オプショナルチェイン：アンラップを伴わずに値のプロパティやメソッドにアクセス
 - オプショナルチェイン：アンラップを伴わずにWrapped型のメンバーにアクセスする記法
 
 map(_:)とflatMap(_:)：アンラップを伴わずに値の変換を行うメソッド
 map(_:)：引数には、値を変換するクロージャを渡す。値が存在すればクロージャを実行して値を変換し、値が存在しなければ何もしない
 
 flatMap(_:)：map(_:)と同様だが、クロージャの戻り値はOptional<Wrapped>型である
 
 暗黙的にアンラップされたOptional<Wrapped>型
 Optional<Wrapped>型には、Wrapped?と表記する糖衣構文がある
 Optional<Wrapped>型には、Wrapped!と表記する糖衣構文も存在
 Wrapped!と表記する糖衣構文は、値へのアクセス時に自動的に強制アンラップを行う
 Wrapped型と同様に扱えるが、nilが入っていると、実行時エラーになる
 Optional<Wrapped>型は、強制アンラップと同様の危険な側面を持っており、乱用するべきではない
 
 
 Any型
 - 代入すると、もとの型の情報は失われる
    - Int型を代入すると、四則演算不可になる
 - 可能な限り、Any型への代入は避ける
 */
let none = Optional<Int>.none
print(".none: \(String(describing: none))")

let some = Optional<Int>.some(1)
print(".some: \(String(describing: some))")

// 型推論
let some2 = Optional.some(1)
print(type(of: some2))

let none2: Int? = Optional.none
print(type(of: none2))

var a18: Int?
// nilリテラルの代入による.noneの生成
a18 = nil
// イニシャライザによるのsome生成
a18 = Optional(1)
// 値の代入によるsome生成
a18 = 1
print(a18)

// nilリテラルには、デフォルトの型が存在しないため、型アノテーションで型を決める
let optionalInt: Int? = nil
let optionalString: String? = nil
print(type(of: optionalInt), String(describing: optionalInt))
print(type(of: optionalString), String(describing: optionalString))

// イニシャライザによるOptional<Wrapped>の生成
let optionalInt2 = Optional(1)
let optionalString2 = Optional("a")
print(type(of: optionalInt2), String(describing: optionalInt2))
print(type(of: optionalString2), String(describing: optionalString2))

// 値の代入よるOptional<Wrapped>の生成
let optionalInt3: Int? = 1
print(type(of: optionalInt3), String(describing: optionalInt3))

// オプショナルバインディング
let optionalA = Optional("a")
if let a = optionalA {
    print(type(of: a))
}

// ??演算子
let optionalInt4: Int? = 1
let int = optionalInt4 ?? 3
print(int)

let optionalInt5: Int? = nil
let int2 = optionalInt5 ?? 3
print(int2)

// 強制アンラップ
let a19: Int? = 1
let b19: Int? = 1
print(a19! + b19!)

// オプショナルチェイン
// オプショナルバインディングだと冗長
let optionalDouble = Optional(1.0)
let optionalIsInfinite: Bool?
if let double = optionalDouble {
    optionalIsInfinite = double.isInfinite
} else {
    optionalIsInfinite = nil
}
print(optionalIsInfinite)

// オプショナルチェインを利用すると簡潔に記述できる
let optionalDouble2 = Optional(1.0)
let optionalIsInfinite2 = optionalDouble2?.isInfinite
print(optionalIsInfinite2)

let optionalRange = Optional(0..<10)
let containsSeven = optionalRange?.contains(7)
print(String(describing: containsSeven))


// map(_:)とflatMap(_:)の利用
let a20 = Optional(17)
let b20 = a20.map({value in value * 2})
print(type(of: b20))

// map(_:)を利用した型の変換
let a21 = Optional(17)
let b21 = a21.map({value in String(value)})
print(type(of: b21))

// flatMap(_:)の利用
// String型からInt型に変換のような、値の有無が不確かな定数に対し、さらに値を返すかわからない操作をおこなっている点である
let a22 = Optional("17")
let b22 = a22.flatMap({value in Int(value)})
print(type(of: b22))

// map(_:)を利用すると、二重にOptional<Wrapped>型に包まれた値になる
let a23 = Optional("17")
let b23 = a23.map({value in Int(value)})
print(type(of: b23))

var a24: String? = "a"
var b24: String! = "b"
print(type(of: a24))
print(type(of: b24))
var c24: String! = a24
var d24: String? = b24
print(type(of: c24))
print(type(of: d24))

// 暗黙的アンラップが行われる
let a25: Int! = 1
print(a25 + 1)

var b25: Int! = nil
// 実行時エラー：print(b + 1)


/*
 Any型：任意の型を表す型
 Any型は、すべての型が暗黙的に準拠している特別なプロトコルとして実装されている
 Any型の変数や定数にはどのような型の値も代入できるため、代入する値の型が決まっていない場合に利用
 */
let string3: Any = "abc"
let int3: Any = 123

// Any型への代入による型の損失
let a26: Any = 1
let b26: Any = 2
// bad: print(a26 + b26) -> コンパイルエラーになる


/*
 タプル型：複数の型をまとめた型
 タプル型の定義：(型名1, 型名2, 型名3, ...)
 
 要素へのアクセス
 - 変数名.インデックス
 
 要素名を指定した定義
 (要素名1: 要素1, 要素名2: 要素2, ...)
 
 Void型：空のタプル
 要素が0個のタプルをVoid型
 nilとVoid型の違い
 - nilは、値が存在し得る場所で値が存在しないことを表す
 - Voidは、値がその場所に存在し得ないことを表す
 Void型は、関数の戻り値がないことを表すときなどに利用
 */
var tuple: (Int, String)
tuple = (1, "a")
print(tuple)

// 要素へのアクセス
print(tuple.0)
print(tuple.1)

// 要素名によるアクセス
let tuple2 = (int: 1, string: "a")
print(tuple2.int)
print(tuple2.string)

// 代入によるアクセス
let int4: Int
let string4: String
(int4, string4) = tuple
print(int4)
print(string4)

// 変数は、タプルを用いて宣言も可能
let (int5, string5) = (1, "a")
print(int5)
print(string5)

print(type(of: ()))


/*
 型のキャスト：別の型として扱う操作
 型のキャストとは、値の型を確認し、可能であれば別の型として扱う操作
 型のキャストは、クラスの継承やプロトコルの準拠などによって階層関係にある型どうしで行う
 
 アップキャスト：上位の型として扱う
 - アップキャストとは、階層関係がある型どうしにおいて、階層の下位となる具体的な型を上位の抽象的な型として扱う
 - as演算子を利用する
 - 左辺には、下位の型の値を指定し、右辺には上位の型を指定する
 - as演算子によるアップキャストを行う場合、その型はas演算子の右辺の型として認識されるため、型アノテーション不要

 ダウンキャスト：下位の型として扱う操作
 - ダウンキャストとは、階層関係のある型どうしにおいて、階層の上位となる抽象的な型を下位の具体的な型として扱う
 - コンパイル可能なアップキャストは、常に成功するが、ダウンキャストはコンパイル可能でも失敗する可能性がある
 - as?：失敗時はnilを返す。結果はOptional<Wrapped>
 - as!：強制キャスト。失敗した場合は実行時エラー。結果はWrapped型
 
 型のキャストでは、基本的にas?を利用する
 
 型の判定：is演算子を利用
 */

let any = "abc" as Any
print(type(of: any))

// 暗黙的なアップキャスト
let any2: Any = "abc"
print(type(of: any2))

// ダウンキャスト
let any3 = 1 as Any
let int6 = any3 as? Int
let string6 = any3 as? String
print(int6)
print(string6)

let any4 = 1 as Any
let int7 = any4 as! Int
// 実行時エラー：let string7 = any4 as! String
print(int7)

// is演算子による型の判定
let a27: Any = 1
let isInt = a27 is Int
print(isInt)


/*
 値比較のためのプロトコル
 プロトコル：それに準拠する型が持つべき性質を定義したもの
 プロトコルに準拠する型は、プロトコルに定義されたプロパティやメソッドを実装する必要がある
 プロトコルを用いることで、異なる型に対して、同じ性質を与えることができ、それらの型を共通のインタフェースを通じて操作できる
 - Equatableプロトコル
 - Comparableプロトコル
 
 Equatableプロトコル：同値性を検証するためのプロトコル
 - ==や!=を使って値の一致と不一致を確認できる
 - 以下の型は、Equatableプロトコルに準拠
    - Bool
    - Int
    - Float
    - Double
    - String
 
Optional<Wrapped>では、WrappedがEquatableプロトコルに準拠している場合のみ比較可能
 
 Comparableプロトコル：大小関係を検証するためのプロトコル
 以下の4つが可能になる
 - <
 - <=
 - >
 - >=
 
 Comparableプロトコルに準拠していない型は、比較不可能
 - Bool
 - Optional<Wrapped>
 - Any
 */

let boolLeft = true
let boolRight = true
print(boolLeft == boolRight)
print(boolLeft != boolRight)

let intLeft = 12
let intRight = 13
print(intLeft == intRight)
print(intLeft != intRight)

let floatLeft = 3.4 as Float
let floatRight = 3.9 as Float
print(floatLeft == floatRight)
print(floatLeft != floatRight)

let doubleLeft = 3.4
let doubleRight = 3.9
print(doubleLeft == doubleRight)
print(doubleLeft != doubleRight)

let stringLeft = "abc"
let stringRight = "def"
print(stringLeft == stringRight)
print(stringLeft != stringRight)

// Equatableプロトコルに準拠していない場合は比較できない
let anyLeft = "abc" as Any
let anyRight = "abc" as Any
// コンパイルエラー：print(anyLeft == anyRight)

// Optional<Wrapped>の比較
let optionalStringLeft = Optional("abc")
let optionalStringRight = Optional("def")
print(optionalStringLeft == optionalStringRight)
print(optionalStringLeft != optionalStringRight)

let optionalAnyLeft = Optional("abc") as Any
let optionalAnyRight = Optional("def") as Any
// 以下はコンパイルエラー
// print(optionalStringLeft == optionalStringRight)
// print(optionalStringLeft != optionalStringRight)

// Comparableプロトコル
let intLeft2 = 12
let intRight2 = 13
print(intLeft2 < intRight2)

let floatLeft2 = 3.4 as Float
let floatRight2 = 3.9 as Float
print(floatLeft2 < floatRight2)

let doubleLeft2 = 3.4
let doubleRight2 = 3.9
print(doubleLeft2 < doubleRight2)

let stringLeft2 = "abc"
let stringRight2 = "def"
print(stringLeft2 <= stringRight2)

let boolLeft2 = true
let boolRight2 = true
// コンパイルエラー：print(boolLeft2 < boolRight2)

let anyLeft2 = "abc" as Any
let anyRight2 = "def" as Any
// コンパイルエラー：print(anyLeft2 < anyRight2)

let optionalLeft2 = Optional(24)
let optionalRight2 = Optional(27)
// コンパイルエラー：print(optionalLeft2 < optionalRight2)
