import Foundation

/*
 Swiftの型
    - 構造体
    - クラス
    - 列挙型
 
 型の共通の仕様
    - プロパティ
    - メソッド
 */

/*
 型の種類を使い分ける目的
    - プログラミングでは、データを「型」として表現する
 
 大抵のデータ構造は、「構造体」や「クラス」で表現できるようになっている
 しかし、構造体、クラス、列挙型はそれぞれの目的に特快した機能や仕様を持っている為、
 データの特定に応じて適切な種類を選択すれば、単なる値と機能の組み合わせ以上の表現が可能になる
 */

/*
 値の受け渡し方法による分類
 
 Swiftの3つの型の種類は、値の受け渡しによって大別
    - 値型
    - 参照型
 
 値型と参照型の最大の違いは、変更を他の変数や定数と共有するかどうか
    - 値型：変更を共有しない型
        - 構造体
        - 列挙型
    - 参照型：変更を共有する型
        - クラス
 */

/*
 値型：値を表す型
 値型：インスタンスが値への参照ではなく、値そのものを表す型
    - 構造体
    - 列挙型
 
 変数や定数への値型のインスタンスの代入：インスタンスが表す値そのものの代入を意味する
    - 複数の変数や定数で1つの値型のインスタンスを共有することはできない
    - 一度代入したインスタンスは再代入を行わない限り不変であり、その値が予測可能になるというメリットがある
 
 値型のインスタンスが値そのものを表すという仕様
    - 変数、定数への代入や関数への受け渡しのたびにコピーを行い、もとのインスタンスが表す値を不変にすることによって実現されている
 
 mutatingキーワード：自身の値の変更を宣言するキーワード
 値型：mutatingキーワードをメソッドの宣言時に追加することで、自身の値を変更する処理を実行できる
    - mutatingキーワードが指定されたメソッドを実行してインスタンスの値を変更すると、インスタンスが格納されている変数への暗黙的な再代入が行われる
    - mutating期キーワードが指定されたメソッドの呼び出しは再代入として扱われる為、定数に再代入された値型のインスタンスに対しては実行できず、コンパイルエラーとなる
    - 定数に対して実行できないという仕様は、インスタンスが保持する値の変更を防ぎたい場合に役立つ
 
 [定義]
 mutating func メソッド名(引数) -> 戻り値の型 {
    // メソッド呼び出し時に実行される文
 }
 */

// 値型（Int型, Float型）
var a = 4.0
var b = a // bに4.0が入る（aが持つ4.0への参照ではなく値である4.0が入る）
a.formSquareRoot() // aの平方根を取る
print(a)
print(b)


struct Color {
    var red: Int
    var green: Int
    var blue: Int
}

var a2 = Color(red: 255, green: 0, blue: 0)
var b2 = a2
a2.red = 0 // aを黒に変更する

print(a2.red)
print(a2.green)
print(a2.blue)

// b2は赤のまま
print(b2.red)
print(b2.green)
print(b2.blue)


// mutatingキーワード
extension Int {
    mutating func increment() {
        self += 1
    }
}

var a3 = 1
a3.increment()
print(a3)

// .append()は、mutatingキーワードで定義されている
var mutableArray = [1, 2, 3]
mutableArray.append(4) // [1, 2, 3, 4]

let immutableArray = [1, 2, 3]
// bad: immutableArray.append(4)


/*
 参照型：値への参照を表す型
 参照型：インスタンスが値への参照を表す型
    - SwiftにおけるClass
    - 変数や定数への参照型の値の代入は、インスタンスに対する参照の代入を意味する為、複数の変数や定数で1つの参照型のインスタンスを共有できる
    - 変数や定数への代入時や関数への受け渡し時にはインスタンスのコピーが発生しないため、効率的なインスタンスの受け渡しができるというメリットがある
 
 値の変更の共有
 値型では、変数や定数は他の値の変更による影響を受けないことが保証されていた
 参照型では、1つのインスタンスが複数の変数や定数の間で共有される為、ある値に対する変更はインスタンスを共有している他の変数や定数にも伝播する
 */

class IntBox {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

var a4 = IntBox(value: 1) // aはIntBox(value: 1)を参照する
var b4 = a4 // bはaと同じインスタンスを参照する

print(a4.value)
print(b4.value)

// a4.valueを2に変更する
a4.value = 2
print(a4.value)
print(b4.value)


/*
 値型と参照型の使い分け
 値型は、変数や定数への代入や引数への受け渡しのたびにコピーされ、変更や共有されない。
 したがって、一度代入された値は、明示的に再代入しない限りは不変であることが保証される。
 一方の参照型はその逆であり、変数や定数への代入や引数への受け渡しの際にコピーされずに参照が渡されるため、変更が共有される。
 したがって、一度代入された値が変更されないことの保証は難しくなる。
 
 -> 安全にデータを取り扱うためには、積極的に値型を使用し、参照型は状態管理などの変更の共有が必要となる範囲にとどめるのが良い
 */

/*
 構造体：値型のデータ構造
 構造体：値型の一種であり、ストアドプロパティの組み合わせによって1つの値を表す
    - 標準ライブラリで提供されている多くの型は構造体
    - 構造体ではないのは、列挙型であるOptional<Wrapped>型、型の組み合わせであるタプル型、プロトコルであるAny型のみ
 
 [定義]
 struct 構造体名 {
    // 構造体の定義
 }
 */

// 構造体の定義
struct Article {
    let id: Int
    let title: String
    let body: String
    
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
    
    func printBody() {
        print(body)
    }
}

let article = Article(id: 1, title: "title", body: "body")
article.printBody()

/*
 ストアドプロパティの変更による値の変更
 構造体は、ストアドプロパティの組み合わせで1つの値を表す値型である。
 構造体のストアドプロパティを変更することは、構造体を別の値に変更することであり、
 構造体が入っている変数や定数への再代入を必要とする。
 
 値型の値の変更に関する仕様は、構造体のストアドプロパティの変更にも適用される
 
 
 定数のストアドプロパティは変更できない
 構造体のストアドプロパティの変更は再代入を必要とするため、定数に代入された構造体のストアどプロパティは変更できない
 */

struct SomeStruct {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}

var variable = SomeStruct(id: 1)
variable.id = 2
print(variable.id)

let constant = SomeStruct(id: 1)
// bad: constant.id = 2


/*
 メソッド内のストアドプロパティの変更にはmutatingキーワードが必要
 */

struct SomeStruct2 {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    mutating func someMethod() {
        id = 4
    }
}

var a5 = SomeStruct2(id: 1)
a5.someMethod()
print(a5.id)

/*
 // mutatingキーワードがないとコンパイルエラー
 struct SomeStruct2 {
     var id: Int
     
     init(id: Int) {
         self.id = id
     }
     
     func someMethod() {
         id = 4
     }
 }
 */

/*
 メンバーワイズイニシャライザ：デフォルトで用意されているイニシャライザ
 
 型のインスタンスは初期化後に全てのプロパティが初期化されている必要がある
 独自にイニシャライザを定義して初期化の処理を行うこともできるが、構造体では自動的に定義される
 メンバーワイズイニシャライザ（memberwise initializer）というイニシャライザが利用できる
 
 メンバーワイズイニシャライザ：型が持っている各ストアドプロパティと同名の引数をとるイニシャライザ
 */

// メンバーワイズイニシャライザ
struct Article2 {
    var id: Int
    var title: String
    var body: String
}

let article2 = Article2(id: 1, title: "Hello", body: "...")
print(article2.id)
print(article2.title)
print(article2.body)

/*
 メンバーワイズイニシャライザのデフォルト引数
 ストアドプロパティが初期化式とともに定義されている場合、そのプロパティに対応するメンバーワイズイニシャライザの引数はデフォルト引数を持ち、呼び出し時の引数を省略できる
 */

struct Mail {
    var subject: String = "(No Subject)"
    var body: String
}

let noSubject = Mail(body: "Hello!")
print(noSubject.subject)
print(noSubject.body)

let greeting = Mail(subject: "Greeting", body: "Hello")
print(greeting.subject)
print(greeting.body)


/*
 クラス：参照型のデータ構造
 
 構造体との大きな違い
    - 一つは参照型であること
    - 継承が可能であること
 
 [定義]
 class クラス名 {
    // クラスの定義
 }
 */

class SomeClass {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    func printName() {
        print(name)
    }
}

let instance = SomeClass(id: 1, name: "name")
instance.printName()

/*
 継承：型の構成要素の引き継ぎ
 継承：新たなクラスを定義するときに、他のクラスのプロパティ、メソッド、イニシャライザなどの型を再利用する仕組み
 継承先のクラスでは、継承元のクラスと共通する動作をあらためて定義する必要がなく、継承元のクラスとの差分のみを定義すれば済む
 
 サブクラス：継承先のクラス
 スーパークラス：継承元のクラス
 
 Swiftでは、複数のクラスから継承する「多重継承」は禁止されている
 
 [定義]
 class クラス名: スーパークラス名 {
    // クラスの定義
 }
 */

class User {
    let id: Int
    
    var message: String {
        return "Hello."
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func printPforile() {
        print("id: \(id)")
        print("message: \(message)")
    }
}

// Userを継承したクラス
class RegisteredUser: User {
    let name: String
    
    init(id: Int, name: String) {
        self.name = name
        super.init(id: id)
    }
}

let registeredUser = RegisteredUser(id: 1, name: "Rio Fujimon")
let id = registeredUser.id
let message = registeredUser.message
registeredUser.printPforile()

/*
 オーバーライド：型の構成要素の再定義
 オーバーライド：スーパークラスで定義されているプロパティやメソッドなどの要素は、サブクラスで再定義することもできる
 オーバーライド可能なプロパティ
    - インスタンスプロパティ
    - クラスプロパティ
 
 オーバーライド不可能なプロパティ
    - スタティックプロパティ
 
 オーバーライドを行うには、overrideキーワードを使用してスーパークラスで定義されている要素を再定義
 
 [定義]
 class クラス名: スーパークラス名 {
    override func メソッド名(引数) -> 戻り値の型 {
        // メソッド呼び出し時に実行される文
    }
 
    override var プロパティ名: 型名 {
        get {
            return文によって値を返す処理
            superキーワードでスーパークラスの実装を利用できる
        }
 
        set {
            値を更新する処理
            superキーワードでスーパークラスの実装を利用できる
        }
    }
 }
 */


class User2 {
    let id: Int
    
    var message: String {
        return "Hello."
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func printProfile() {
        print("id: \(id)")
        print("message: \(message)")
    }
}


class RegisteredUser2: User {
    let name: String
    
    override var message: String {
        return "Hello, my name is \(name)"
    }
    
    init(id: Int, name: String) {
        self.name = name
        super.init(id: id)
    }
    
    override func printPforile() {
        super.printPforile()
        print("name: \(name)")
    }
}

let user = User2(id: 1)
user.printProfile()

print("--")

let registeredUser2 = RegisteredUser2(id: 2, name: "Rio Fujimon")
registeredUser2.printPforile()


/*
 finalキーワード：継承とオーバーライドの禁止
 オーバーライド可能な要素の前にfinalキーワードを記述することで、その要素がサブクラスでオーバーライドされることを禁止できる
 */

class SuperClass {
    func overridableMethod() {}
    
    final func finalMethod() {}
}

class SubClass: SuperClass {
    override func overridableMethod() {}
    
    // オーバーライド不可能なためコンパイルエラー
    // bad: override func finalMethod(){}
}

class InheritableClass {}

class ValidSubClass: InheritableClass {}

final class FinalClass {}

// 継承不可能なためコンパイルエラー
// class InvalidSubClass: FinalClass {}


/*
 クラスに紐づく要素
 クラスのインスタンスではなく、クラス自身に紐づく要素として、「クラスプロパティ」と「クラスメソッド」がある
 
 クラスプロパティはスタティックプロパティと、クラスメソッドはスタティックメソッドと、それぞれ似通った性質を持つ
 両者の違いは、スタティックプロパティとスタティックメソッドは、オーバーライドできないのに対し、
 クラスプロパティとクラスメソッドはオーバーライドできる
 */

/*
 クラスプロパティ：クラスに紐づくプロパティ
 クラスプロパティはクラスのインスタンスではなく、クラス自身に紐づくプロパティで、
 インスタンスに依存しない値を扱う場合に利用する
 
 クラスプロパティを定義するには、プロパティ宣言の先頭に「classキーワード」を追加する
 クラスプロパティにアクセスするには、型名に「.」とクラスプロパティ名を付けて、「型名.クラスプロパティ名」のように記述する
 */

// クラスプロパティ
class A {
    class var className: String {
        return "A"
    }
}

class B: A {
    // クラスプロパティは、overrideできる
    override class var className: String {
        return "B"
    }
}

print(A.className)
print(B.className)

/*
 クラスメソッド：クラス自身に紐づくメソッド
 クラスメソッドはクラスのインスタンスではなく、クラス自身に紐づくメソッドで、
 インスタンスに依存しない処理を実装する際に利用
 
 クラスメソッドを定義するには、メソッドの定義の先頭にclassキーワードを追加する
 クラスメソッドを呼び出すには、型名に「.」とクラスメソッド名を付けて型名.クラスメソッド名のように書く
 */

// クラスメソッド
class A2 {
    class func inheritanceHierarchy() -> String {
        return "A"
    }
}

class B2: A2 {
    override class func inheritanceHierarchy() -> String {
        return super.inheritanceHierarchy() + "<-B"
    }
}

class C2: B2 {
    override class func inheritanceHierarchy() -> String {
        return super.inheritanceHierarchy() + "<-C"
    }
}

print(A2.inheritanceHierarchy())
print(B2.inheritanceHierarchy())
print(C2.inheritanceHierarchy())

/*
 スタティックプロパティ、スタティックメソッドとの使い分け
 スタティックプロパティ、スタティックメソッドはクラスに対しても利用できる
 つまり、クラスに対してインスタンスはなく型に紐づく要素を定義する場合、スタティックプロパティ、スタティックメソッドと、クラスプロパティ、クラスメソッドの両方を選択できる
    -> どちらを選択するべきかは、その値がサブクラスで変更される可能性があるかどうか
 */

class A3 {
    class var className: String {
        return "A3"
    }
    
    static var baseClassName: String {
        return "A3"
    }
}

class B3: A3 {
    override class var className: String {
        return "B3"
    }
    
    // スタティックプロパティはオーバーライドできないので、コンパイルエラー
}

print(A3.className)
print(A3.baseClassName)
print(B3.className)
print(B3.baseClassName)


/*
 イニシャライザの種類と初期化のプロセス
 イニシャライザの役割は型のインスタンス化の完了までに全てのプロパティを初期化し、型の整合性を保つこと
 それに加えて、クラスには継承関係があるため、さまざまな階層で定義されたプロパティが初期化されることを保証する必要がある
 
 クラスには、2段階初期化という仕組みが導入されている
    - 指定イニシャライザ
    - コンビニエンスイニシャライザ
 */

/*
 指定イニシャライザ：主となるイニシャライザ
 指定イニシャライザ（desinated initializer）：クラスの主となるイニシャライザ
    - このイニシャライザの中で、全てのストアドプロパティが初期化される必要がある
 */

class Mail2 {
    let from: String
    let to: String
    let title: String
   
    // 指定イニシャライザ
    init(from: String, to: String, title: String) {
        self.from = from
        self.to = to
        self.title = title
    }
}

/*
 コンビニエンスイニシャライザ：指定イニシャライザをラップするイニシャライザ
 コンビニエンスイニシャライザ（convenience initializer）：指定イニシャライザを中継するイニシャライザで、内部で引数を組み立てて指定イニシャライザを呼び出す必要がある
 
 コンビニエンスイニシャライザは、「convenienceキーワード」を追加することで定義できる
 */

class Mail3 {
    let from: String
    let to: String
    let title: String
    
    // 指定イニシャライザ
    init(from: String, to: String, title: String) {
        self.from = from
        self.to = to
        self.title = title
    }
    
    // コンビニエンスイニシャライザ
    convenience init(from: String, to: String) {
        self.init(from: from, to: to, title: "Hello, \(from)")
    }
}

/*
 2段階初期化
 型の整合性を保った初期化を実現するためには、クラスのイニシャライザには次の3つのルールがある
    - 指定イニシャライザは、スーパークラスの指定イニシャライザを呼ぶ
    - コンビニエンスイニシャライザは、同一クラスのイニシャライザを呼ぶ
    - コンビニエンスイニシャライザは、最終的に指定イニシャライザを呼ぶ
 
 このルールを満たしている場合、継承関係にある全てのクラスの指定イニシャライザが必ず実行され、
 各クラスで定義されたプロパティが全て初期化されることが保証される。
 一つでも満たせないルールがある場合、型の整合性を保てない可能性があるためコンパイルエラー
 
 また、スーパークラスとサブクラスのプロパティの初期化順序を守るため、
 指定イニシャライザによるクラスの初期化は、次の2段階に分けて行われる
 
    - クラス内で新たに定義された全てのストアドプロパティを初期化し、スーパークラスの指定イニシャライザを実行する。スーパークラスでも同様の初期化を行い、大元のクラスまでのぼる
 
    - ストアドプロパティ以外の初期化を行う
 
 第1段階の時点では、スーパークラスで定義されているストアドプロパティが初期化されていないため、selfにはアクセスできないようになっている。
 第2段階では、全てのストアドプロパティが初期化されていることが保証されている保証されており、selfに安全にアクセスができるようになっている
 */

class User3 {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func printProfile() {
        print("id: \(id)")
    }
}

class RegisteredUser3: User3 {
    let name: String

    init(id: Int, name: String) {
        // 第1段階
        self.name = name
        super.init(id: id)
        
        // 第2段階
        self.printProfile()
    }
}

let registeredUser3 = RegisteredUser3(id: 1, name: "Rio Fujimon")

/*
 デフォルトイニシャライザ：プロパティの初期化が不要な場合に定義されるイニシャライザ
 
 プロパティが存在しない場合や、全てのプロパティが初期値を持っている場合、指定イニシャライザ内で
 初期化する必要があるプロパティはない。
 このようなクラスでは、暗黙的にデフォルトの指定イニシャライザがinit()で定義される
 */

class User4 {
    let id = 0
    let name = "Rio"
    
    // 以下と同等のイニシャライザが自動的に定義
    // init() {}
}

let user4 = User4()

/*
 一つでも指定イニシャライザ内で初期化が必要なプロパティが存在する場合、
 デフォルトイニシャライザinit()はなくなり、指定イニシャライザを定義する必要が生じる
 */
class User5 {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
let user5 = User5(id: 0, name: "Rio")

/*
 指定イニシャライザ内で初期化する必要があるプロパティが存在するにも関わらず、
 指定イニシャライザを定義しない場合は、インスタンス化が不可能となるためコンパイルエラー
 
 class User {
    let id: Int
    let name: String
    
    // id, nameを初期化する方法が存在しないためコンパイルエラー
 }
 */


/*
 クラスのメモリ管理
 
 Swiftは、クラスのメモリ管理にARC（Automatic Reference Counting）という方式を採用している
 ARCでは、クラスのインスタンスを生成するたびに、そのインスタンスのためのメモリ領域を自動的に確保し、
 不要になったタイミングでそれらを自動的に解放する
 
 ARCでは、使用中のインスタンスのメモリが解放されてしまうことを防ぐために、
 プロパティ、変数、定数からそれぞれのクラスのインスタンスへの参照がいくつあるかをカウントする。
 このカウントが0になった時に、そのインスタンスはどこからも参照されていないとみなされ、メモリが解放される
 このカウントのことを参照カウンタと呼ぶ
 */

/*
 デイニシャライザ：インスタンスの終了処理
 ARCによってインスタンスが破棄されるタイミングでは、クラスのデイニシャライザが実行される
 デイニシャライザとはイニシャライザの逆で、クリーンアップなどの終了処理を行うもの

 デイニシャライザは継承関係の下位のクラスから自動的に実行されるため、スーパークラスのデイニシャライザを呼び出す必要はない
 
 [定義]
 class クラス名 {
    deinit {
        // クリーンアップ処理
    }
 }
 */

/*
 値の参照と参照の比較
 参照型の比較
    - 参照先の値どうしの比較
    - 参照先自体の比較
 
 参照先の値どうしの比較は、==演算子で行う
 参照先自体の比較は===演算子で行う
 */

class SomeClass2: Equatable {
    static func == (lhs: SomeClass2, rhs: SomeClass2) -> Bool {
        return true
    }
}

let a6 = SomeClass2()
let b6 = SomeClass2()
let c6 = a6

// 定数aとbは同じ値
print(a6 == b6)

// 定数aとbの参照先は異なる
print(a6 === b6)

// 定数aとcの参照先は同じ
print(a6 === c6)


/*
 列挙型：複数の識別子をまとめる型
 列挙型は値型の一種で、複数の識別子をまとめる型
 ケース：列挙型の一つ一つの識別子
 
 標準ライブラリで提供されている一部の型は列挙型
    - Optional<Wrapped>

 イニシャライザを定義してインスタンス化を行うことができる
 
 列挙型には、プロパティやメソッドなども利用できる
    - プロパティには制限があり、ストアドプロパティを持つことはできない
 [定義]
 enum 列挙型名 {
    case ケース名1
    case ケース名2
    ...
 
    // その他の列挙型の定義
 }
 */

// 列挙型の定義
enum Weekday {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

let sunday = Weekday.sunday
let monday = Weekday.monday
print(sunday)
print(monday)

// イニシャライザを利用した列挙型の定義
enum Weekday2 {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    init?(japaneseName: String) {
        switch japaneseName {
        case "日": self = .sunday
        case "月": self = .monday
        case "火": self = .tuesday
        case "水": self = .wednesday
        case "木": self = .thursday
        case "金": self = .friday
        case "土": self = .saturday
        default: return nil
        }
    }
}

let sunday2 = Weekday2(japaneseName: "日")
let monday2 = Weekday2(japaneseName: "月")
print(sunday2)
print(monday2)

// プロパティの利用
enum Weekday3 {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var name: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "月"
        case .tuesday: return "火"
        case .wednesday: return "水"
        case .thursday: return "木"
        case .friday: return "金"
        case .saturday: return "土"
        }
    }
}

let weekday3 = Weekday3.monday
let name = weekday3.name
print(name)

/*
 ローバリュー：実体の定義
 
 ローバリュー（raw value）：列挙型ケースには、それぞれに対応する値を設定できる
    - 全てのケースのローバリューの型は同じである必要がある
    - ローバリューの型に指定できるのは、Int型、Double型、String型、Character型などのリテラルに変換可能な型
 
 ローバリューが定義されている列挙型では、ローバリューと列挙型の相互関係を行うための
 失敗可能イニシャライザinit?(rawValue:)とプロパティrawValueが暗黙的に用意されている
 init?(rawValue:)はローバリューと同じ型の値を引数に取り、ローバリューが一致するケースであれば、
 そのケースをインスタンス化し、なければnilを返す。また、rawValueプロパティは、ケースのローバリューを返す
 ローバリューと列挙型の相互変換は、文字や数値といった原始的なデータのうち、想定している値だけを
 各ケースに振り分けることに役立つ
 
 [定義]
 enum 列挙型名: ローバリューの型 {
    case ケース名1 = ローバリュー1
    case ケース名2 = ローバリュー2
 }
 */

// ローバリューの定義
enum Symbol: Character {
    case sharp = "#"
    case dollar = "$"
    case percent = "%"
}


// rawValueプロパティの利用
enum Symbol2: Character {
    case sharp = "#"
    case dollar = "$"
    case percent = "%"
}

let symbol = Symbol2(rawValue: "#")
print(symbol)

let character = symbol?.rawValue
print(character)

/*
 ローバリューのデフォルト値
 
 Int型やString型では、ローバリューにデフォルト値が存在し、特に値を指定しない場合はデフォルト値が使用される
    - Int型のローバリューのデフォルト値は、最初のケース0で、それ以降は前のケースの値に1を足した値である
    - String型のローバリューのデフォルト値は、ケース名をそのまま文字列にした値
 */

enum Option: Int {
    case none
    case one
    case two
    case undefined = 999
}

print(Option.none.rawValue) // 0
print(Option.one.rawValue) // 1
print(Option.two.rawValue) // 2
print(Option.undefined.rawValue) // 999

// String型のローバリューのデフォルト値
enum Direction: String {
    case north
    case east
    case south
    case west
}

print(Direction.north.rawValue)
print(Direction.east.rawValue)
print(Direction.south.rawValue)
print(Direction.west.rawValue)


/*
 関連値：付加情報の付与
 列挙型のインスタンスは、どのケースかということに加えて、関連値（associated value）という付加情報を持つことができる
 関連値に指定できる型には制限がない
 */

enum Color2 {
    case rgb(Float, Float, Float)
    case cmyk(Float, Float, Float, Float)
}

let rgb = Color2.rgb(0.0, 0.33, 0.66)
let cmyk = Color2.cmyk(0.0, 0.33, 0.66, 0.99)

let color = Color2.rgb(0.0, 0.33, 0.66)

switch color {
case .rgb(let r, let g, let b):
    print("r: \(r), g: \(g), b: \(b)")
    
case .cmyk(let c, let m, let y, let k):
    print("c: \(c), m: \(m), y: \(y), k: \(k)")
}

/*
 CaseIterableプロトコル：要素列挙のプロトコル
 
 列挙型を使用していると、全てのケースを配列として取得したい場合がある
    - (ex)
    - 都道府県を列挙型で表現する場合、選択肢を表示するために全てのケースの配列が必要
 
 CaseIterableプロトコルへの準拠を宣言した列挙型には自動的にallCasesスタティックプロパティが追加され、
 このプロパティが列挙型の全ての要素を返す。
 */

enum Fruit: CaseIterable {
    case peach, apple, grape
}

print(Fruit.allCases)

/*
 コンパイラによるallCasesプロパティのコードの自動生成
 通常、プロトコルに準拠するためには、プロトコルが定義しているプロパティやメソッドをプログラマが実装する必要がある。
 
 関連値を持たない列挙型がCaseIterableプロトコルの準拠を宣言した場合、その実装故コードがコンパイラによって自動生成されるため
 もちろん、コンパイラによって自動生成された実装を使わずに自分でallCasesプロパティを実装することもできる
 
 CaseIterableプロトコルの他にも、Equatableプロトコル、Hashableプロトコルで行われる
 コードの自動生成は、コンパイラが一部のプロトコルを特別扱いすることで実現されるため、特殊なものとして覚える
 */

// 以下のような実装は、自明であるため、わざわざ自分で行う必要はない
enum Fruit2: CaseIterable {
    case peach, apple, grape
    
    static var allCases: [Fruit2] {
        return [
            .peach,
            .apple,
            .grape
        ]
    }
}

print(Fruit2.allCases)

/*
 allCasesプロパティのコードが自動生成されない条件
 列挙型が関連値を持つ場合、allCasesプロパティの実装は自動生成されなくなる。
 従って、そのような列挙型でも全てのケースを列挙したい場合には、プログラマがallCasesプロパティを実装する必要がある
 
 もし関連値にInt型やString型がある場合、取り得る値が非常に多くなるため、
 CaseIterableプロトコルに準拠するのは現実的ではない。
 そのようなケースでは、そもそも列挙型がCaseIterableプロトコルに準拠すること自体が妥当かどうかを見直すべき
 */

// allCasesプロパティを実装するのが現実的である
enum Fruit3: CaseIterable {
    case peach, apple(color: AppleColor), grape
    
    static var allCases: [Fruit3] {
        return [
            .peach,
            .apple(color: .red),
            .apple(color: .green),
            .grape,
        ]
    }
}

enum AppleColor {
    case green, red
}
