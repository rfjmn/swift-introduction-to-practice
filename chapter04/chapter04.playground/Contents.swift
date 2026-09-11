import Foundation

/*
 コレクション：値の集まりのこと
    - 配列：順序を持ったコレクション
    - 辞書：キーと値のペアを持つコレクション
 
 コレクションを表す型
    - 配列：Array<Element>型
    - 辞書：Dictionary<Key, Value>型
    - 範囲：Range<Bound>型
    - 文字列；String型

 SequenceプロトコルやCollectionプロトコルにコレクションとしての共通の機能
    - 要素数を取得
    - コレクションの一部にアクセス
 */


/*
 Array<Element>型：配列を表す型
 配列：順序を持ったコレクション
 Element：プレースホルダーであり、具体的な型に置き換えて扱う
    - (ex)
        - Array<Int>
        - Array<String>
 
 Array<Element>には、[Element]という糖衣構文が用意されている
 糖衣構文：すでに定義されている構文をより簡単に読み書きできるようにするために導入される構文
    - (ex)
        - Array<Int> -> [Int]
 
 配列リテラル：[]内に「,」区切りで要素を列挙
 
 型推論
 - 配列リテラルは、配列リテラルが含む要素の型からArray<Element>型のElementを推論する
 - 空の配列リテラルの場合、要素が存在しないため、型推論できない。空の配列リテラルの場合は、型アノテーションが必要
 - [1, "a"]のように配列リテラルが複数の型の要素を含む場合も、型推論によって決定できないことがある。型アノテーションが必要

 要素にできる型
 - Elementには、どのような型も当てはめることができる
 - Elementが型アノテーションと異なる場合は、要素にできない
 
 要素へのアクセス
 Array<Element>型の要素にアクセスするには、「サブスクリプト」を使用
 サブスクリプト：コレクションにインデックス（添字）を与え、そのインデックスに位置する要素の取得や書き換えを行う
    - コレクション名[インデックス]
 Array<Element>のサブスクリプトの引数には、Int型の値を利用
    - 0, 1, 2, ...
    - 添字は、0からスタートする
    - インデックスが範囲外の場合は、実行時エラー
 
 Array<Element>への要素の更新、追加、結合、削除
 - 要素の更新：コレクション名[インデックス] = 新しいエレメント要素
 - 末尾への要素の追加：.append()を利用
 - 任意の位置への要素の追加：.insert()を利用
 - Elementが同一のArray<Element>の結合：+を利用
 - 任意のインデックスの要素を削除：.remove(at:)
 - 末尾の要素を削除：removeLast()
 - 全ての要素を削除；removeAll()
 */

// 配列リテラル
let a = [1, 2, 3]
let b = ["a", "b", "c"]

// 型推論
let strings = ["a", "b", "c"]
let numbers = [1, 2, 3]
print(type(of: strings))
print(type(of: numbers))

// 空の配列リテラルの定義
let array: [Int] = []
print(type(of: array))

// 複数の型の要素が含まれている配列リテラル
let array2: [Any] = [1, "a"]
print(type(of: array2))

// 二次元配列
let integerArrays = [[1, 2, 3], [4, 5, 6]]
print(type(of: integerArrays))

// bad: let integers: [Int] = [1, 2, 3, "a"]

// 要素へのアクセス
let strings2 = ["abc", "def", "ghi"]
let string1 = strings2[0]
let string2 = strings2[1]
let string3 = strings2[2]
print(string1)
print(string2)
print(string3)
// bad: let string4 = strings2[3]

// 要素の更新
var strings3 = ["abc", "def", "ghi"]
strings3[1] = "xyz"
print(strings3)

// 末尾への要素の追加
var integers3 = [1, 2, 3]
integers3.append(4)
print(integers3)

// 任意の位置への要素の追加
var integers4 = [1, 3, 4]
integers4.insert(2, at: 1)
print(integers4)

// 要素の結合
let integets5 = [1, 2, 3]
let integets6 = [4, 5, 6]
let result = integets5 + integets6
print(result)

// 要素の削除
var integers7 = [1, 2, 3, 4, 5]
integers7.remove(at: 1)
print(integers7)
integers7.removeLast()
print(integers7)
integers7.removeAll()
print(integers7)


/*
 Dictionary<Key, Value>型：辞書を表す型
 辞書：キーと値のペアを持つコレクション
    - キーを元に値にアクセスする用途で利用
    - 順序関係はない
    - キーは、一意でなければならない
    - 値は他の値と重複しても大丈夫
 
 Dictionary<Key, Value>のKeyとValueはプレースホルダー
    - (ex)
        - Dictionary<String, Int>
 
 Dictionary<Key, Value>の糖衣構文
    - [Key: Value]
 
 辞書リテラル
    - Keyの型とValueの型から型推論される
    - 要素が一つも存在しない場合、キーと値に複数の型が混在する場合は型推論できないことがある。型アノテーションが必要
 
 キーと値にできる型
 Dictionary<Key, Value>は、正式にはDictionary<Key: Hashable, Value>
    - Hashableの部分：型制約がある
    - Keyは、Hashableプロトコルに準拠している必要がある
    - Hashableプロトコルに準拠した型：その値を元にハッシュ値を計算できる
 
 ハッシュ値：もとの値から特定のアルゴリズムで算出されるInt型の数値
    - Key型がHashableプロトコルに準拠している必要があるのは、ハッシュ値で探索候補を絞り、Equatableでキーの一致を判定するため。異なるキーが同じハッシュ値を持つこともある
 
 Hashableプロトコルに準拠する型
    - (ex)
        - String
        - Int

 Hashableプロトコルに準拠していない型
    - (ex)
        - Array<Element>
 
 Valueにできる型
    - Valueには制限はない
 
 要素へのアクセスには、サブスクリプトを使用
    - サブスクリプトは、Key型の値を指定
 
 Dictionary<Key, Value>型は、Array<Element>型と異なり、サブスクリプトで存在しない値にアクセスしようとすると、実行時エラーにはならずに、nilが返る
    - 返却される値の型は、Optionanl<Value>型

 Dictionary<Key, Value>の値の更新、追加、削除
 - サブスクリプトを使用
 */

let dictionary = ["a": 1, "b": 2]
print(dictionary)

// 型推論
let dictionary2 = ["a": 1, "b": 2]
print(type(of: dictionary2))

let dictionary3: [String: Int] = [:]
print(type(of: dictionary3))

// Dictionary<Key: Hashable, Value>
let array3 = ["even": [2, 4, 6, 8], "odd": [1, 3, 5, 7, 9]]
print(type(of: array3))

/*
 // 以下はコンパイルエラー
 let dictionary: [String: Int] = [
    1: 2,
    "key": "value"
 ]
 */

// Dictionary<Key, Value>型は、Optional<Value>が返る
let dictionary4 = ["key": 1]
let value = dictionary4["key"]
print(value)

let dictionary5 = ["key1": "value1"]
let valueForKey1Exists = dictionary5["key1"] != nil
let valueForKey2Exists = dictionary5["key2"] != nil
print(valueForKey1Exists)
print(valueForKey2Exists)

// Dictionary<Key, Value>型の値の更新
var dictionary6 = ["key1": 1]
dictionary6["key1"] = 2
print(dictionary6)

// Dictionary<Key, Value>型の値の追加
var dictionary7 = ["key1": 1]
dictionary7["key2"] = 2
print(dictionary7)

// Dictionary<Key, Value>型の値の削除
var dictionary8 = ["key1": 1]
dictionary8["key1"] = nil
print(dictionary8)

/*
 範囲型：範囲を表す型
 
 主な範囲型：Range<Bound>型
    - 以下の演算子によって生成
        - 末尾の値を含まない：「..<」演算子
        - 末尾の値を含む：「...」演算子
 
    - 両端の境界値の有無
    - カウント可能か：
 
 - カウント可能：Int型の範囲のように範囲に含まれる値の数を数えられる範囲
    - Sequenceプロトコルに準拠する
 - カウント不可能：Double型の範囲のように範囲に含まれる値の数を数えられない範囲
 
 範囲型の種類
 囲型 | 境界 | カウント可能
 [..<演算子（終了の値を含まない）]
 Range<Bound> | 両端 | 不可能
 CountableRange<Bound> | 両端 | 可能
 PartialRangeUpTo | 末尾のみ | 不可能
 
 [...演算子（終了の値を含む）]
 ClosedRange<Bound> | 両端 | 不可能
 CountableClosedRange | 両端 | 可能
 PartialRangeThrough | 末尾のみ | 不可能
 PartialRangeFrom | 先頭のみ | 不可能
 CountablePartialRangeFrom<Boud> | 先頭のみ | 可能
 
 Range<Bound>型とCountableRange<Bound>型の値を生成するには、「..<」演算子を「中置演算子」として使用
    - 1.0..<3.5 -> Range<Double>
    - 1..<4 -> Range<Int>
 
 「..<」演算子の両辺が「Int」型の場合は、Countable<Bound>型の値が生成される
 「..<」演算子を前置演算子として使用すると、PartialRangeUpTo<Bound>型の値を生成できる
 
 
 ClosedRange<Bound>型とCountableClosedRange<Bound>型の値を生成するには、「...」演算子を中置演算子として使用する
    - 1.0...3.5 -> ClosedRange<Bound>
    - 1...4 -> CountableClosedRange<Bound>
 
 「..<」演算子や「...」演算子によって範囲型の値を生成する場合、プレースホルダー型Boundは、両辺の値から推論される
    - let integerRange = 1..<3 -> CountableRange<Int>型
    - let doubleRange = 1.0..<3.0 -> Range<Double>型
 
 型アノテーションによって指定することも可能

 範囲型の境界を表すプレースホルダー型のBound型は、大小関係を比較するためのプロトコルであるComparableプロトコルに準拠している必要がある
    - Comparableプロトコルに準拠している型
        - (ex)
            - Int
            - Double
 
 境界値へのアクセス
 - プロパティ
    - lowerBound：先頭の値
    - upperBound：末尾の値
 
 値が範囲に含まれるかどうかの判定
 - contains(_:)メソッドを利用
    - Bound型の値を受け取り、値が範囲に含まれているかどうかをBool値で返す
 */

let range = 1..<4
print(type(of: range))

for value in range {
    print(value)
}

let range2 = 1.0..<3.5
print(type(of: range2))

/*
// bad: CountableRange<Bound>ではない
for value in range2 {
    print(value)
}
 */

let range3 = ..<4
print(type(of: range3))

/*
// bad: PartialRangeUpTo<Bound>はカウント不可能
for value in range3 {
    print(value)
}
*/

let range4 = 1...4
print(type(of: range4))

for value in range4 {
    print(value)
}

let range5 = ...4
print(type(of: range5))
/*
 // bad: PartialRangeThrough<Bound>はカウント可能ではない
 for value in range5 {
    print(value)
 }
*/

// CountablePartialRangeFromをfor inで回すと無限ループになる
let range6 = 1...
print(type(of: range6))

// 型推論
let integerRange = 1..<3
print(type(of: integerRange))

let doubleRange = 1.0..<3.0
print(type(of: doubleRange))

// 型アノテーションによる型の指定
let floatRange: Range<Float> = 1..<3
print(type(of: floatRange))

// 境界値へのアクセス
let range7 = 1.0..<4.0
print(range7.lowerBound)
print(range7.upperBound)

let range8 = 1..<4
print(range8.lowerBound)
print(range8.upperBound)

let range9 = 1.0...4.0
print(range9.lowerBound)
print(range9.upperBound)

let range10 = 1...4
print(range10.lowerBound)
print(range10.upperBound)

// 片側範囲の場合
let rangeThrough = ...3.0
print(rangeThrough.upperBound)

let rangeUpTo = ..<3.0
print(rangeUpTo.upperBound)

let rangeFrom = 3.0...
print(rangeFrom.lowerBound)

let countableRangeFrom = 3...
print(countableRangeFrom.lowerBound)

// 値が範囲に含まれているかの判定
let range11 = 1...4
print(range11.contains(2))
print(range11.contains(5))

/*
 コレクションとしてのString型
    - String型は、文字の集まりで構成されるため、コレクションだと捉えることができる
    - String型は単一の文字を表すCharacter型のコレクションとして定義されている
        - 文字の列挙
        - 文字数のカウント
 
 Character型：文字を表す型
    - 文字列リテラルからCharacter型の変数や定数を生成するには、「型アノテーション」をつける
 
 String.Index型：文字列内の位置を表す型
    - 文字列内の特定の位置を指定し、その位置に存在する文字にアクセスできる
    - 以下のプロパティを経由して取得
        - startIndexプロパティ
        - endIndexプロパティ：最後の文字のインデックスではなく、その次のインデックス
    - n番目の文字のインデックスを取得
        - .index(元になるインデックス, offsetBy: ずらす数)
    - countプロパティを取得して、要素数を取得
 */

let string4 = "a"
print(type(of: string4))

// 明示的に、型アノテーションを指定する必要がある
let string5: Character = "a"
print(type(of: string5))

// String.Index型
let string6 = "abc"
let startIndex = string6.startIndex
print(type(of: startIndex))

let endIndex = string6.endIndex
print(type(of: endIndex))

// String型からCharacter型の値を取り出す
let string7 = "abc"
print(string7[string7.startIndex])
// String.Index.endIndexは、最後の文字のインデックスではなく、その次のインデックスになる
// bad: print(string7[string7.endIndex])
// 最後の文字の取得
let endIndex2 = string7.index(string7.endIndex, offsetBy: -1)
print(string7[endIndex2])

// 2番目の文字の取得
let secondIndex = string7.index(string7.startIndex, offsetBy: 1)
print(string7[secondIndex])

let string8 = "abc"
// 文字数のカウント
print(string8.count)

// 要素の列挙
for character in string8 {
    print(character)
}

/*
 シーケンスとコレクションを扱うためのプロトコル
 シーケンス：その要素に一方向から順次アクセス可能なデータ構造
    - (ex)
        - 配列
 Sequenceプロトコル：シーケンスを汎用的に扱うためのプロトコル
 
 コレクション：一方向からの順次アクセスと、特定のインデックスの値への直接アクセスが可能なデータ構造
    - コレクションは、シーケンスを包含する概念
    - 標準ライブラリには、コレクションを汎用的に扱うためのCollectionプロトコルが用意されている
 
 SequenceプロトコルとCollectionプロトコルに準拠する
    - Array<Element>
    - Dictionary<Key, Value>
    - Range<Bound>
    - String
 
 Sequenceプロトコル：シーケンスを表現したプロトコル
    - for inを用いて、その要素に順次アクセスできる
 
 Sequenceプロトコルが提供するインタフェース
    - forEach(_:)：要素に対して順次アクセス
        - 引数のクロージャ内で各要素にアクセスする
        - 引数のクロージャの戻り値は、Void型
    - filter(_:)：要素を絞り込む
        - 指定した条件を満たす要素のみを含む、新しいシーケンスを返す
        - 条件は、引数のクロージャを用いて指定
        - 引数のクロージャはBool型の戻り値を返す
            - 戻り値がtrueならば要素は新しいシーケンス
            - 戻り値がfalseならば含まれない
    - map(_:)：要素を変換する
        - すべての要素を、特定の処理を用いて変換する
        - 要素を変換する処理は、引数のクロージャを用いて指定
    - flatMap(_:)：要素をシーケンスに変換し、それを1つのシーケンスに連結する
        - すべての要素をシーケンスへと変換し、さらに、それを1つのシーケンスに連結する
        - 要素をシーケンスへ変換する処理は、引数のクロージャを用いて指定
        - 要素をシーケンスへと変換するため、引数のクロージャの戻り値の型はSequenceプロトコルに準拠している必要がある
    - compactMap(_:)：要素を、失敗する可能性のある処理を用いて変換する
        - すべての要素を特定の処理で変換するという点では、map(_:)と同じだが、変換できない処理を無視する
        - 要素を変換する処理は、引数のクロージャを用いて指定
        - 引数のクロージャの戻り値の型は、Optional<Wrapped>型
        - 失敗した場合は、クロージャ内でnilを返す
    - reduce(_:)：要素を1つにまとめる
        - 第一引数に初期値を指定
        - 第二引数に要素を結果に反映する処理
        - クロージャの第一引数から結果の途中経過にアクセスできる
        - クロージャの第二引数からその要素にアクセスできる
 
 Collectionプロトコル：コレクションを表現したプロトコル
    - Collectionプロトコルは、Sequenceプロトコルを継承している
    - Collectionプロトコルに準拠している型は、Sequenceプロトコルが提供するインタフェースを利用できる
 
 Collectionプロトコルが提供するインタフェース
    - サブスクリプトによる要素へのアクセス
    - isEmptyプロパティ：コレクションが空かどうかを判定
    - countプロパティ：要素の個数を取得
    - firstプロパティ：最初の要素を取得
    - lastプロパティ：最後の要素を取得
 */

// forEach(_:)メソッド
let array4 = [1, 2, 3, 4, 5, 6]
var enumerated = [] as [Int]
array4.forEach({ element in enumerated.append(element)})
print(enumerated)

// filter(_:)
let array5 = [1, 2, 3, 4, 5, 6]
let filtered = array5.filter({element in element % 2 == 0})
print(filtered)

// map(_:)
let array6 = [1, 2, 3, 4, 5, 6]
let doubled = array6.map({ element in element * 2})
let convered = array6.map({ element in String(element)})
print(doubled)
print(convered)

// flatMap(_:)
let a2 = [1, 4, 7]
let b2 = a2.flatMap({ value in [value, value+1]})
print(b2)

let b3 = a2.map({ value in [value, value+1]})
print(b3)

// compactMap(_:)
let strings4 = ["abc", "123", "def", "456"]
let integers = strings4.compactMap({ value in Int(value)})
print(integers)

// reduce(_:)
let array7 = [1, 2, 3, 4, 5, 6]
let sum = array7.reduce(0, {result, element in result + element})
print(sum)

let contact = array7.reduce("", {result, element in result + String(element)})
print(contact)

let array8 = [1, 2, 3, 4, 5, 6]
print(array8[3])
print(array8.isEmpty)
print(array8.count)
print(array8.first)
print(array8.last)
