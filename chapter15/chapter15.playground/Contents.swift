import Foundation

/*
 Swiftは、静的な型チェックやオプショナル型の導入によって実行時の安全性が高い言語になっている。
 
 I/Oやネットワーク処理など、エラーの発生が避けられない処理がある。
 
 想定外の状況が発生した際にエラー処理を行わず、プログラムを終了させる方法もある。
 プログラムを終了させてしまうことはデメリットしかないように感じるが、メリットもある。
 */

/*
 Swiftにおけるエラー処理
 
 Swiftにおけるエラー処理の方法
    - Optional<Wrapped>型によるエラー処理
    - Result<Success, Failure>型によるエラー処理
    - do-catch文によるエラー処理
 
 想定外の状況に陥ったときにアプリケーションを終了させる方法
    - fatalError(_:)関数
    - アサーション
 */

/*
 Optional<Wrapped>型によるエラー処理：値の有無による成功、失敗の表現
    - 値があること：成功
    - 値がないこと：失敗
 
 [実装方法]
 処理の結果をOptional<Wrapped>型で表し、値が存在すれば成功、存在しなければ失敗とみなす
 */

struct User {
    let id: Int
    let name: String
    let email: String
}

func findUser(byID id: Int) -> User? {
    let users = [
        User(id: 1, name: "Rio Fujimon", email: "fujimon@example.com"),
        User(id: 2, name: "Yousuke Ishikawa", email: "ishikawa@example.com"),
    ]
    
    for user in users {
        if user.id == id {
            return user
        }
    }
    
    return nil
}

let id = 1
if let user = findUser(byID: id) {
    print("Name: \(user.name)")
} else {
    print("Error: User not found")
}

// 失敗可能イニシャライザ

struct User2 {
    let id: Int
    let name: String
    let email: String
    
    init?(id: Int, name: String, email: String) {
        let components = email.components(separatedBy: "@")
        guard components.count == 2 else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.email = email
    }
}

if let user = User2(id: 0, name: "Yousuke Ishikawa", email: "ishikawa@example.com") {
    print("Username: \(user.name)")
} else {
    print("Error: Invalid data")
}

/*
 Optional<Wrapped>型によるエラー処理を利用するべきとき
 
 値の有無だけで結果を十分に表せる
 
 Optional<Wrapped>型によるエラー処理のメリット
    - エラー処理を簡潔に記述できる点
    - エラーを発生させる側は結果を表す値の型をOptional<Wrapped>にするだけで済む
    - エラーを処理する側もオプショナルチェイン、オプショナルバインディングなどを用いて簡潔に記述できる
 
 Optional<Wrapped>型によるエラー処理のデメリット
    - 呼び出しもとにエラーの詳細な情報を提供できない点
    - Optional<Wrapped>型は値の有無しか表すことができないため、どのようなエラーが発生したかは表現できない
    - 失敗の原因に応じてメッセージを表示したり、復旧処理を行なったりするのであれば、Optional<Wrapped>型だけでは不十分
 
 Optional<Wrapped>型によるエラー処理は、値の有無だけで処理の結果を十分に表せる場合に利用するべき
    - エラーを発生させる側もエラーを処理する側も実装を簡潔に記述できる
 */

/*
 Result<Success, Failure>型によるエラー処理：列挙型による成功、失敗の表現
 
 Optional<Wrapped>型によるエラー処理
    - 成功を結果の値で、失敗をnilで表していた
 
 Result<Success, Failure>型によるエラー処理
    - 成功を結果の値で、失敗をエラーの詳細で表す
 
 エラーの詳細を表すことができないという、Optional<Wrapped>型によるエラー処理のデメリットを克服できる
 
 Result<Success, Failure>型は、Swift5から標準ライブラリで提供されるようになった
    - 標準ライブラリで提供される以前は、コミュニティよってメンテナンスされているantitypical/Resultがよく使われていた
 
 
 [実装方法]
 Result<Success, Failure>型は、型引数を2つ取る列挙型であり、.success, .failureの2つのケースを持つ
 型引数のSuccessは成功時の値の型を表し、Failureは失敗時のエラーの型を表す

 public enum Result<Success, Failure> where Failure: Error {
    case success(Success) // .successの場合は、Success型の関連値を持つ
    case failure(Failure) // .failureの場合は、Failure型の関連値を持つ
 }
 */

enum DatabaseError: Error {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

struct User3 {
    let id: Int
    let name: String
    let email: String
}

func findUser2(byID id: Int) -> Result<User3, DatabaseError> {
    let users = [
        User3(id: 1, name: "Rio Fujimon", email: "fujimon@example.com"),
        User3(id: 2, name: "Yosuke Ishikawa", email: "ishikawa@example.com"),
    ]
    
    for user in users {
        if user.id == id {
            return .success(user)
        }
    }
    
    return .failure(.entryNotFound)
}

let id2 = 0
let result = findUser2(byID: id2)

switch result {
case let .success(user):
    print(".success: \(user)")
    
case let .failure(error):
    switch error {
    case .entryNotFound:
        print(".failure: .entryNotFound")
    case .duplicatedEntry:
        print(".failure: .duplicatedEntry")
    case .invalidEntry(let reason):
        print(".failure: .invalidEntry(\(reason)")
    }
}

/*
 Result<Success, Failure>型によるエラー処理を利用するべきとき
 
 エラーの詳細を提供する
 Optional<Wrapped>型とは違い、Result<Success, Failure>型では、関連値を通じて失敗時にエラーの値を返す
 従って、エラー発生時には必ずエラーの詳細を受け取ることができ、詳細に応じてエラー処理の挙動を細かくコントロールできる
 
 (ex)
 通信を必要とする処理中にエラーが発生した場合、通信エラーであれば数回リトライし、
 サーバがエラーを返した場合はリトライせずにエラーを表示するといった制御を行える
 
 
 Result<Success, Failure>型ではエラーの型が型引数となっている
    - 任意の型でエラーの情報を表現できる
        - 発生し得るエラーの種類をあらかじめ把握できるというメリット
        - エラー処理に必要な情報を受け取ることができるというメリット
    - switch文の網羅性チェックを利用することにより、全てのエラーに対する処理が実装されていることをコンパイル時に保証することもできる
 
 
 成功か失敗のいずれかであることを保証する
 Result<Success, Failure>型には、処理の結果が成功か失敗かのいずれかに絞られるというメリットがある
 
 Result<Success, Failure>型を持たずに、成功時の値と失敗時の値のそれぞれに別の定数を用意するケースを想定する
 (ex)
 func someFunction() -> (value: Int?, error: Error?){}
 
 [valueとerrorの組み合わせ]
 value | error | 成否
 nil | nil | ?
 nil | nilではない | 失敗
 nilではない | nil | 成功
 nilではない | nilではない | ?
 
 4パターンのうち「?」となっている箇所は、成功か失敗かわからない
 不正な結果にならないように関数が実装されているべきだが、コンパイラが保証してくれるわけではなく、
 関数を提供する側の責任に委ねられる
 
 関数を利用する側では、関数を提供する側を信頼して不正なパターンを無視した実装をするか、
 不正なパターンまで考慮した実装をするかのいずれかを選択する必要がある
 
 
 Result<Success, Failure>型を用いた場合は、値を.successか.failureのどちらかに必ずなるため、
 その結果は成功か失敗のいずれかであることを保証できる。
 従って、不正なパターンを考慮する必要が一切なくなる
 
 
 非同期処理のエラーを扱う
 Result<Success, Failure>型は値として処理の結果を表せるため、関数やクロージャの引数や戻り値に指定できる
 クロージャを用いて、非同期処理の結果を呼び出しもとに通知する例で、クロージャの引数の型をResult<Success, Failure>型にすれば、呼び出しもとにエラー情報を伝えることもできる
 
 do-catch文によるエラー処理は、非同期に発生したエラーを呼び出しもとに伝えることができない
 Optional<Wrapped>型も値として、処理の結果を表しているためイベント通知方法にも使用できるが、
 値の有無だけでは十分なエラー処理が行えないケースでは、Result<Success, Failure>型を使用するのが良い
 */

/*
 do-catch文によるエラー処理：Swift標準のエラー
 
 do-catch文は、Swift2.0で追加されたSwift標準のエラー処理機構
 
 do-catch文によるエラー処理では、エラーが発生する可能性のある処理をdo節内に記述
 エラーが発生すると、catch節へプログラムの制御が移る
 catch節内では、エラーの詳細情報にアクセスすることができるため、
 Result<Success, Failure>型と同様にエラー詳細を用いたエラー処理を行える
 
 [実装方法]
 do {
    // throw文によるエラーが発生する可能性のある処理
 } catch {
    // エラー処理
    // 暗黙的に宣言された定数errorを通じてエラー値にアクセスできる
 }
 */

struct SomeError: Error {}

do {
    throw SomeError()
    print("success")
} catch {
    print("Failure: \(error)")
}

/*
 catch節では処理するエラーの条件を絞ることができ、条件の絞り込みにはパターンマッチを使用する
 ただし、パターンを持つcatch節では暗黙的に宣言された定数errorは使用できない
 catch節は複数続けて書くことができ、最初にマッチしたcatch節のブロックのみが実行される
 switch文では、パターンマッチによって全てのケースが網羅されていなければならない
 */

enum SomeError2: Error {
    case error1
    case error2(reason: String)
}

do {
    throw SomeError2.error2(reason: "何かがおかしいようです")
} catch SomeError2.error1 {
    print("error1")
} catch SomeError2.error2(let reason) {
    print("error2: \(reason)")
} catch {
    print("Unknown error: \(error)")
}


/*
 Errorプロトコル：エラー情報を表現するプロトコル
 
 throw文のエラーを表現する型は、Errorプロトコルに準拠している必要がある
 Errorプロトコルは、準拠した型がエラーを表現する型として扱えることを示すためのプロトコルで、準拠するために必要な実装はない
 
 Errorプロトコルに準拠する型は、列挙型として定義することが一般的である
    - 発生するエラーを網羅的に記述できるというメリットがある
    - プログラム全体で起こり得るあらゆるエラーを1つの列挙型で表現するのではなく、エラーの種類ごとに別の型を定義することが一般的である
 */

// ローカルのデータベースにアクセスする際に発生するエラー
enum DatabaseError2: Error {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

// 通信を行う際に発生するエラー
enum NetworkError: Error {
    case timedOut
    case cancelled
}


/*
 throwsキーワード：エラーを発生させる可能性のある処理の定義
 関数、イニシャライザ、クロージャの定義にthrowsキーワードを追加すると、
 それらの処理の中でdo-catch文を用いいずにthrow文によるエラーを発生させることができる
 throwsキーワードを持つ関数の定義は、throwsキーワードは引数の直後に追加する
 
 func 関数名(引数) throws -> 戻り値の型 {
    throw文によるエラーが発生する可能性のある処理
 }
 */

enum OperationError: Error {
    case overCapacity
}

func triple(of int: Int)throws -> Int {
    guard int <= Int.max / 3 else {
        throw OperationError.overCapacity
    }
    
    return int * 3
}

/*
 定義にthrowsキーワードを指定していない場合、
 do-catch文で囲まれていないthrow文によるエラーはコンパイルエラーとなる
 */

/*
 enum OperationError: Error {
    case overCapacity
 }
 
 func triple(of int: Int) -> Int {
    guard int <= Int.max / 3 else {
        // 関数にthrowsキーワードが指定されていないため、
        // do-catch文で囲まれていないthrow文によるエラーはコンパイルエラー
        throw OperaitonError.overCapacity
    }
 
    return int * 3
 }
 */

/*
 throwsキーワードは、イニシャライザでも使用でき、インスタンス化の途中に発生したエラーを呼び出しもとに伝えることができる
 */

enum AgeError: Error {
    case outOfRange
}

struct Teenager {
    let age: Int
    
    init(age: Int) throws {
        guard case 13...19 = age else {
            throw AgeError.outOfRange
        }
        
        self.age = age
    }
}

/*
 rethrowsキーワード：引数のクロージャが発生させるエラーの呼び出しもとへの伝播
 
 関数やメソッドをrethrowsキーワードを指定することで、引数のクロージャが発生させるエラーを関数の呼び出し元に伝播させることができる
 
 rethrowsキーワードを指定するには、関数やメソッドが少なくとも1つのエラーを発生させるクロージャを引数に取る必要がある
 */

struct SomeError3: Error {}

func rethrowingFunction(_ throwingClosure: ()throws -> Void) rethrows {
    try throwingClosure()
}

do {
    try rethrowingFunction {
        throw SomeError3()
    }
} catch {
    // 引数のクロージャが発生させるエラーを、関数の呼び出しもとで処理
    print(error)
}

/*
 関数内で引数のクロージャが発生させるエラーを処理し、別のエラーを発生させることもできる
 */

enum SomeError4: Error {
    case originalError
    case convertedError
}

func rethrowingFunction2(_ throwingClosure: ()throws -> Void) rethrows {
    do {
        try throwingClosure()
    } catch {
        throw SomeError4.convertedError
    }
}

do {
    try rethrowingFunction2 {
        throw SomeError4.originalError
    }
} catch {
    print(error)
}

/*
 引数のクロージャが発生させるエラー以外を元にエラーを発生させることはできない
 */

/*
struct SomeError5: Error {}

func otherThrowingFunction() throws {
    throw SomeError5()
}

func rethrowingFunction(_ throwingClosure: () throws -> Void) rethrows {
    do {
        try throwingClosure()
        
        // 引数のクロージャと関係ない関数がエラーを発生させているため
        // コンパイルエラー
        try otherThrowingFunction()
    } catch {
        throw SomeError5()
    }
    
    // 関数内で新たなエラーを発生させているため、コンパイルエラー
    throw SomeError5()
}
*/

/*
 tryキーワード：エラーを発生させる可能性のある処理の実行
 
 throwsキーワードが指定された処理を呼び出すには、それらの処理の呼び出しの前にtryキーワードを追加して
 try関数名(引数)のように記述する。tryキーワードを用いた処理の呼び出しには、throw文と同様に、do-catch文のdo節とthrowsキーワードが指定された処理の内部のみで使用できる
 */

enum OperationError2: Error {
    case overCapacity
}

func triple2(of int: Int)throws -> Int {
    guard int <= Int.max / 3 else {
        throw OperationError2.overCapacity
    }
    
    return int * 3
}

let int = Int.max

do {
    let tripleOfInt = try triple2(of: int)
    print("Success: \(tripleOfInt)")
} catch {
    print("Error: \(error)")
}

/*
 try!キーワード：エラーを無視した処理の実行
 
 throwsキーワードが指定された処理であっても、特定の場面では絶対にエラーが発生しないとわかっていて、
 わざわざエラー処理を記述したくないケースは、tryキーワードの代わりに、try!キーワードを使用することで
 エラーを無視できる。
 
 try!キーワードはdo-catch文のdo節やthrowsキーワードが指定された処理の内部でなくても使用できる
 */

enum OperationError3: Error {
    case overCapacity
}

func triple3(of int: Int)throws -> Int {
    guard int <= Int.max / 3 else {
        throw OperationError3.overCapacity
    }
    
    return int * 3
}

let int2 = 9
let tripleOfInt2 = try! triple3(of: int2)
print(tripleOfInt2)

/*
 // 以下はエラー
 enum OperationError: Error {
    case overCapacity
 }
 
 func triple(of int: Int) -> Int {
    guard int <= Int.max / 3 {
        throw OperationError.overCapacity
    }
 
    return int * 3
 }
 
 let int = Int.max
 let tripleOfInt = try! triple(int) // 実行時エラー
 print(tripleOfInt)
 */

/*
 try!キーワードは一見Swiftの安全性を損ねる機能に見える
 しかし、「いかなる場合も、発生し得るエラーに対処する」というのはあまりに面倒で、現実的ではない
 かといって、「暗黙的にエラーを無視できる」としてしまうと、どこでエラーが無視されたのかが分からなくなり、
 結果としてプログラム全体の信頼性が下がってしまう。
 
 
 try!キーワードが意図しているのは、両者の間をとった「明治的なエラーの無視」である。
 つまり、エラーを無視することはできるが、無視するのであれば無視したことを明らかにしたということ
 
 try!キーワードは実用性と安全性の両方のバランスを保っているSwiftらしい言語仕様といえる
 
 強制アンラップにも同じく「!」が使用されており、「!」は安全性ではない処理を意味している
 */

/*
 try?キーワード：エラーをOptional<Wrapped>型で表す処理の実行
 
 throwsキーワードが指定された処理であっても、利用時にはエラーの詳細が不要な場合もある。
 このようなケースでは、try?キーワードを使用できる。
 
 try?キーワードを付けてthrowsキーワードが指定された処理を呼び出すとdo-catch文を省略でき、
 代わりに関数の戻り値がOptional<Wrapped>型となる。
 処理の成否は値の有無で表されるため、Optional<Wrapped>型によるエラー処理と同様になる
 
 try?キーワードはdo-catch文のdo節やthrowsキーワードが指定された処理の内部でなくても使用できる
 
 失敗可能イニシャライザやオプショナルチェインにも同じく「?」が使われていたように、
 Swiftの記法では、一貫して、「?」が失敗の安全な無視を意味している
 */

enum OperationError4:Error {
    case overCapacity
}

func triple4(of int: Int)throws -> Int {
    guard int <= Int.max / 3 else {
        throw OperationError4.overCapacity
    }
    
    return int * 3
}

if let triple = try? triple4(of: 9) {
    print(triple)
}

// try?は、失敗可能イニシャライザにも使える
enum AgeError2: Error {
    case outOfRange
}

struct Teenager2 {
    let age: Int
    
    init(age: Int) throws {
        guard case 13...19 = age else{
            throw AgeError2.outOfRange
        }
        
        self.age = age
    }
}

if let teenager = try? Teenager2(age: 17) {
    print(teenager)
}


/*
 defer文によるエラーの有無に関わらない処理の実行
 
 defer文内の処理は、その式が記述されているスコープを抜けた直後に実行される
 
 defer文による処理の遅延実行は、do-catch文によるエラー処理で特に有効
    - (ex)
    - リソースの解放
 
 エラーが発生したかどうかに関わらず、必ず実行したい処理というものがある
 通常は、エラーが発生した時点で制御がcatch節に移動してしまうので、
 エラーが発生する可能性のある処理の後に記述されたコードが実行される保証はありません
 */

do {
    defer {
        print("second")
    }
    
    print("first")
}

enum Error2: Swift.Error {
    case someError
}

func someFunction() throws {
    print("Do something")
    throw Error2.someError
}

func cleanup() {
    print("Clean up")
}

do {
    try someFunction()
    cleanup() // someFunctionでエラーが発生した場合は実行されない
} catch {
    print("Error: \(error)")
}

// defer文を利用すれば、エラーの有無に関わらず実行される処理を記述できる
enum Error3: Error {
    case someError
}

func someFunction2() throws {
    print("Do something")
    throw Error3.someError
}

func cleanup2() {
    print("Clean up")
}

do {
    defer {
        cleanup2()
    }
    
    try someFunction2()
} catch {
    print("Error: \(error)")
}

/*
 do-catch文によるエラー処理を利用するべきとき
 
 エラーの詳細を提供する
 do-catch文によるエラー処理では、catch節でエラー詳細を受け取る。
 従って、エラー発生時にはエラーの詳細に応じて処理を切り替えることができる。
    - (ex)
    - ファイルにアクセスする処理
        - ファイルへのアクセス権がない場合の処理とファイルが見つからない場合の処理を切り替えることができる
 
 エラーの詳細を受け取ることができるという点では、Result<Success, Failure>型によるエラー処理も同様だが、
 Result<Success, Failure>型は、型引数Errorと同じ型のエラーしか扱えないのに対し、
 do-catch文ではErrorプロトコルに準拠した型であれば、どのような型のエラーも扱える
 
 エラーの型には制限があるResult<Success, Failure>型には、あらかじめどのようなエラーが発生するのか
 予測しやすいというメリットがあり、エラー型に制限のないdo-catch文には、複数の種類のエラーを1ヶ所で扱うことができるというメリットがある
 
 エラーの詳細を利用するかどうかはエラーが発生する処理の利用者次第である。
 try?キーワードを利用すれば、エラーの詳細を無視できるため、この場合はOptional<Wrapped>型による
 エラー処理と等価になる
 
 
 成功か失敗のいずれかであることを保証する
 Result<Success, Failure>型によるエラー処理と同様に、do-catch文によるエラー処理も、
 処理の結果が成功か失敗かのいずれかに絞られるというメリットがある。
 throw文によるエラーが発生しているにも関わらず、do節が実行が継続されたり、
 逆にエラーは発生していないがcatch節が実行されるようなプログラムは、言語仕様上あり得ない
 
 
 エラー処理を強制する
 do-catch文によるエラー処理には、利用する側にはエラー処理の実装を強制できるというメリットがある
 Result<Success, Failure>型は成功と失敗を明確に区別するが、失敗時にエラーを確実に処理させる仕組みではない
 Result<Success, Failure>型の成功時の値を取得するにはswitch文を書くため、同時に失敗時のケースも考慮することになる
 しかし、成功時の戻り値がVoidの場合には値に関心を持たないため、エラーを無視しがちである。
 */

struct SomeError5: Error {}

func someFunction3(arg: Int) -> String {
    do {
        guard arg < 10 else {
            throw SomeError5()
        }
        return "Success"
    } catch {
        return "Failure"
    }
    
}

print(someFunction3(arg: 11))


/*
 連続した処理のエラーをまとめて扱う
 
 do-catch文によるエラー処理はResult<Success, Failure>型によるエラー処理と比べて、
 連続した処理のエラーをまとめて扱うことにする
 */

// Result<Success, Failure>の利用
enum DatabaseError3: Error {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

struct User4 {
    let id: Int
    let name: String
    let email: String
}

func findUser3(byID id: Int) -> Result<User4, DatabaseError3> {
    let users = [
        User4(id: 1, name: "Rio Fujimon", email: "fujimon@example.com"),
        User4(id: 2, name: "Yosuke Ishikawa", email: "ishikawa@example.com"),
    ]
    
    for user in users {
        if user.id == id {
            return .success(user)
        }
    }
    
    return .failure(.entryNotFound)
}

func localPart(fromEmail email: String) -> Result<String, DatabaseError3> {
    let components = email.components(separatedBy: "@")
    guard components.count == 2 else {
        return .failure(.invalidEntry(reason: "Invalid email address"))
    }
    
    return .success(components[0])
}

let userID = 1

// 連続したエラー処理では、switch文がネストし、条件分岐の構造を把握しづらくなる
switch findUser3(byID: userID) {
case .success(let user):
    switch localPart(fromEmail: user.email) {
    case .success(let localPart):
        print("Local part: \(localPart)")
    case .failure(let error):
        print("Error: \(error)")
    }
    
case .failure(let error):
    print("Error: \(error)")
}

// do-catch文によるエラー処理の実装
// Result<Success, Failure>型を使用した実装と比べてコード量こそあまり変わらないが、
// より命令的、直感的なコードと言える
// do-catch文は非同期処理で発生するエラーは扱えないが、動機処理ではdo-catch文の方がエラーを扱いやすいことがある
enum DatabaseError4: Error {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

struct User5 {
    let id: Int
    let name: String
    let email: String
}

func findUser4(byID id: Int) throws -> User5 {
    let users = [
        User5(id: 1, name: "Rio Fujimon", email: "fujimon@example.com"),
        User5(id: 2, name: "Yosuke Ishikawa", email: "ishikawa@example.com"),
    ]
    
    for user in users {
        if user.id == id {
            return user
        }
    }
    
    throw DatabaseError4.entryNotFound
}

func localPart2(fromEmail email: String) throws -> String {
    let components = email.components(separatedBy: "@")
    guard components.count == 2 else {
        throw DatabaseError4.invalidEntry(reason: "Invalid email address")
    }
    
    return components[0]
}

let userID2 = 1

do {
    let user = try findUser4(byID: userID2)
    let localPartOfEmail = try localPart2(fromEmail: user.email)
    print("Local part: \(localPartOfEmail)")
} catch {
    print("Error: \(error)")
}

struct User6 {
    let id: Int
    let name: String
}

enum DatabaseError5: Error {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

var registeredUsers = [
    User6(id: 1, name: "Rio Fujimon"),
    User6(id: 2, name: "Yosuke Ishikawa"),
]

func register(user: User6) -> Result<Void, DatabaseError5> {
    for registeredUser in registeredUsers {
        if registeredUser.id == user.id {
            return .failure(.duplicatedEntry)
        }
    }
    
    registeredUsers.append(user)
    
    return .success(())
}

let user = User6(id: 1, name: "Rio Fujimon")
print(register(user: user)) // 処理に失敗しているが、エラーを無視している

// do-catch文では、処理の結果がどのような型であっても、正しくエラー処理されているかどうかがコンパイラによってチェックされる
// throwsキーワードを持つ関数はtryキーワードを追加せずに呼び出すとコンパイルエラーになるため、
// register(user:)関数を呼び出すにはtryキーワードを追加する必要があり、必ずエラー処理を意識することになる
// do-catch文によるエラー処理は、エラーを無視しづらい仕組みになっている

struct User7 {
    let id: Int
    let name: String
}

enum DatabaseError6: Error {
    case entryNotFound
    case duplicatedEntry
    case invalidEntry(reason: String)
}

var registeredUsers2 = [
    User7(id: 1, name: "Rio Fujimon"),
    User7(id: 2, name: "Yosuke Ishikawa"),
]

func regiter2(user: User7) throws {
    for registeredUser in registeredUsers {
        if registeredUser.id == user.id {
            throw DatabaseError6.duplicatedEntry
        }
    }
    
    registeredUsers2.append(user)
}

let user2 = User7(id: 1, name: "Rio Fujimon")

do {
    // register(user:)の呼び出しにはtryキーワードが必要
    try regiter2(user: user2)
} catch {
    print("Error: \(error)")
}

/*
 fatalError(_:)関数によるプログラムの終了：実行が想定されていない箇所の宣言
 エラー処理を適切に行えば、プログラムの利用者が失敗に遭遇する機会を減らしたり、
 失敗の内容利用者に伝えて復帰のための操作を促すことができる。
 
 エラーの中にそもそも発生することが想定されておらず、想定されていないがゆえに、
 その復帰方法も存在しないようなエラーもある。
 そうしたケースではプログラムを終了させてしまうのも選択肢の1つである
 
 fatalError(_:)関数：その箇所が実行されること自体が想定外であることを宣下するための関数
    - この関数が呼び出されると、プログラムは終了する
 
 [実装方法]
 fatalError(_:)関数は、引数に終了時のメッセージをとる
 fatalError(_:)関数を実行すると、実行時にエラーが発生してプログラムを終了する
 終了時には引数で指定したメッセージと、ソースファイル名、行番号を出力する
 */

// fatalError("指定しないエラーが発生したためプログラムを終了します")

/*
 Never型：値を返さないことを示す型
 
 fatalError(_:)関数の戻り値の型は、値を返さないことを示すNever型という特殊な型
 値を返さないとは、Void型のように空のタプルを返すという意味ではなく、
 関数の実行時にプログラムを終了するため値を返すことはない意味
 
 Never型を戻り値に持つ関数を実行すると、その箇所以降の処理は実行されないものとみなされるため、
 戻り値を返す必要がなくなる
 */


func randomInt() -> Int {
    // Never型を表すfatalError(_:)関数を実行しているため
    // Int型の値を返さなくてもコンパイル可能
    fatalError("まだ実装されていません")
}

// randomInt()

/*
 Never型のこの性質を利用すると、想定しない状況における処理の実装は不要となる
 */

/*
 func title(forButtonAt index: Int) -> String {
 // ケースがInt型の値を網羅できていないためコンパイルエラー
     switch index {
     case 0:
     return "赤"
     case 1:
     return "青"
     case 2:
     return "黄"
     }
 }
 */

/*
 Int型の値を網羅するため、switch文にデフォルトケースを追加
 デフォルトケース内でNever型を戻り値に持つfatalError(_:)を呼び出しているため、値を返さずともコンパイルできる
 
 もちろんデフォルトケースで""のような適当な値を返してもコンパイル可能になる
 しかし、想定していない状況をより適切に表しているのは値を返さないNever型の方である
 Never型を利用すると想定していない状況における処理の実装は不要となり、仕様にない値を無理に返すことも避けられる
 */
func title(forButtonAt index: Int) -> String {
    switch index {
    case 0:
        return "赤"
    case 1:
        return "青"
    case 2:
        return "黄"
    default:
        fatalError("想定外のボタンのインデックス\(index)を受け取りました")
    }
}

// title(forButtonAt: 3)

/*
 fatalError(_:)関数を利用するべきとき
 
 想定外の状況ではプログラムを終了させる
 想定しない状況が発生した際、プログラムの実行を継続するべきか終了するべきかは場合によって異なる
 実装上想定外の状況を考慮しなくても良いことが明らかな場合は、fatalError(_:)関数を利用して想定外の状況ではプログラムを終了してもよい
 
 結果が外部リソースに依存する場合など、想定外の挙動が十分起こりうる場合は、実行を継続できる実装にした方が良い
 */


/*
 アサーションによるデバッグ時のプログラムの終了：満たすべき条件の宣言
 アサーション：プログラムがある時点で満たしているべき条件を記述するための機能で、条件が満たされていない場合はプログラムの実行を終了する
 ある処理を行う前に満たされるべき条件がある場合にアサーションを使用する
 
 アサーションが実行時エラーを発生させてプログラムを終了するのは、デバッグ時のみ
 リリース時には条件式の成否によらず処理を継続する
 従って、デバッグ中は想定外の状況を速やかに発見できるようにしつつも、リリース時には影響を与えない
 
 [実装方法]
 標準ライブラリのassert(_:_:)関数とassertionFailure(_:)関数を利用することで、アサーションを実装
 */

/*
 assert(_:_:)：条件を満たさない場合に終了するアサーション
 assert(_:_:)関数は、第1引数に満たされるべき条件式を、第2引数に終了時のメッセージをとる
 条件式がtrueのときは通常通り後続の処理が実行されるが、falseのときは実行時エラーが発生してプログラムが終了
 終了時には、第2引数で指定したメッセージと、ソースファイル名、行番号を出力する
 assert(_:_:)関数はリリース時には無効になるため、戻り値の型はNever型ではない
 */

func format(minute: Int, second: Int) -> String {
    assert(second < 60, "secondは60未満を設定してください")
    return "\(minute)分\(second)秒"
}

format(minute: 24, second: 48)
// format(minute: 24, second: 72)

/*
 assertionFailure(_:)関数：必ず終了するアサーション
 
 assertionFailure(_:)は、条件式を持たない、常に失敗するアサーション
 実行されること自体が条件を満たしていないので、第1引数にはfalseを取るassert(_:_:)と等価である
 
 fatalError(_:)関数と同様に、その箇所が実行されること自体が想定外であることを宣言するための関数
 この関数が呼び出されると、プログラムは終了する
 
 assertionFailure(_:)関数は、引数に終了時のメッセージをとる
 assertionFailure(_:)関数が実行されると、実行時エラーが発生してプログラムが終了する
 終了時には、引数で指定したメッセージと、ソースファイル名、行番号を出力する
 assert(_:_:)関数と同様に、戻り値の型はNever型ではない
 */

func printSeason(forMonth month: Int) {
    switch month {
    case 1...2, 12:
        print("冬")
    case 3...5:
        print("春")
    case 6...8:
        print("夏")
    case 9...11:
        print("秋")
    default:
        assertionFailure("monthには1から12までの値を設定してください")
    }
}

printSeason(forMonth: 11)
printSeason(forMonth: 12)
printSeason(forMonth: 13)

/*
 コンパイルの最適化レベル：デバッグとリリースの切り替え
 
 アサーションはデバッグ時に有効で、リリース時には無効になる
 これはSwiftのコンパイラの最適化レベルによって決まる
 最適化レベル：実行時間やメモリ使用量が小さくなるようにコンパイラが行う最適化の段階のこと
 
 Swiftの主な最適化レベル
    - -Onone：最適化が全く行われず、デバッグ時に使用する
    - -O：最適化が行われ、リリース時に使用する
 
 [実行方法]
 Xcodeのデフォルト設定では、「Product」 -> 「Run」メニュー（command + R）から実行してデバッグする際には、「-Onone」が使用される
 
 Xcodeのデフォルト設定では、「Product」 -> 「Archive」メニューからリリース用のビルドを作成する際には、「-O」が使用される
 
 最適化レベルは、「swiftc」コマンドでもオプションとして指定できる
 */

/*
 アサーションを利用するべきとき
 
 デバッグ時に想定外の状況を検出する
 アサーションを利用して関数が想定する値の範囲を宣言することで、デバッグ時に想定外の値を検出できる
 
 リリース時は想定外の状況でもプログラムの実行を継続する
 アサーションはリリース時には想定外の状況であってもプログラムの実行を継続する。
 一方、fatalError(_:)関数はリリース時であってもプログラムを終了する
 
 想定外の状況に陥った際にプログラムの実行を継続するべきか、終了するべきかは場合によって異なる
 もし、実行を継続するべきと判断した場合はアサーションを使用し、終了するべきと判断した場合はfatalError(_:)を使用する
 */

/*
 エラー処理の使い分け
 
 Optional<Wrapped>型
    - エラーの詳細情報が不要で、結果の成否のみによってエラーを扱える場合
 
 Result<Success, Failure>型
    - 非同期処理の場合
 
 do-catch
    - 同期処理の場合
 
 fatalError(_:)関数
    - エラー発生時にプログラムを終了させたい場合
 
 アサーション
    - デバッグ時のみ、エラー発生時にプログラムを終了させたい場合
 */
