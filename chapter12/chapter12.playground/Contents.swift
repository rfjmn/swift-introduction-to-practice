import Foundation

/*
 Swiftの特徴
    - 構造体、列挙型、プロトコルの表現力が豊かであること
    - オプショナル型やlet、varキーワードによって型のプロパティの特性も細かくコントロールできる
 */

/*
 クラスに対する構造体の優位性
 Swiftでは、クラスで実現可能なことの大半は構造体でも実現できる
    - 型を設計するたびに、クラスにするべきか構造体にするべきか検討する
 
 Swiftの標準ライブラリの型は、ほとんどが構造体として宣言されている
    - Swiftでは、構造体を積極的に利用した設計が推奨されている
    - できるだけ構造体を利用することを検討し、その上で要求を満たせない場合に初めてのクラスでの実装を検討する
 */

/*
 参照型のクラスがもたらすバグ
 
 Swiftでは、構造体が重視されている
    - 構造体の持つ特性に理由がある
    - クラスは参照型であり、インスタンスが引数として渡された時、そのインスタンスの参照が渡される
 
 非同期処理：実行中に他の処理を止めない処理
 */

class Temperature {
    var celsius: Double = 0
}

class Country {
    var temperature: Temperature
    
    init(temperature: Temperature) {
        self.temperature = temperature
    }
}

let temperature = Temperature()
temperature.celsius = 25

let Japan = Country(temperature: temperature)
temperature.celsius = 40

let Egypt = Country(temperature: temperature)

print(Japan.temperature.celsius) // 40.0
print(Egypt.temperature.celsius) // 40.0


import Dispatch

class Temperature2 {
    var celsius: Double = 0
}

let temperature2 = Temperature2()
temperature2.celsius = 25

// 別スレッドでtemperature2の値を編集
let dispatchQueue = DispatchQueue.global(qos: .default)
dispatchQueue.async {
    temperature2.celsius += 1
}

temperature2.celsius += 1
print(temperature2.celsius)

/*
 値型の構造体がもたらす安全性
 構造体は値型である
 値型では、インスタンスが引数として渡される時、その参照ではなく値そのものが渡される。
 つまり、インスタンスのコピーが渡される
 
 構造体はインスタンスが受け渡されるたびにコピーされるので、それぞれ別々のインスタンスを保持する
 構造体は値として受け渡される。ただし、内部にクラスの参照を持つ場合は、コピーした値の間でもその参照先を共有し得る
 
 構造体の特性により、クラスとは異なりコードの実行結果を容易に推測できる
 */

struct Temperature3 {
    var celsius: Double = 0
}

struct Country3 {
    var temperature: Temperature3
}

var temperature3 = Temperature3()
temperature3.celsius = 25
let Japan3 = Country3(temperature: temperature3)

temperature3.celsius = 40

let Egypt3 = Country3(temperature: temperature3)

print(Japan3.temperature.celsius) // 25
print(Egypt3.temperature.celsius) // 40


/*
 コピーオンライト：構造体の不要なコピーを発生させない最適化
 
 構造体は代入や変更のたびにコピーが発生する。
    - Array<Element>型やDictonary<Key, Value>型などのコレクションを表す型はサイズの大きいデータを扱う可能性があるため、代入のたびに毎回コピーを行うとパフォーマンスの低下が予想される
 
    - Array<Element>型やDictionary<Key, Value>型にはコピーオンライトという最適化が導入されており、必要になるまでコピーが行われない
 
 コピーオンライトはコストを必要最小限に抑えつつ値型の特性を実現する仕組み
 */

// Array<Element>型は構造体であるため、変数array2には変数array1のコピーが代入され、
// array1への変更はarray2には影響しない
var array1 = [1, 2, 3]
// このタイミングでは、コピーが発生していない
var array2 = array1
// このタイミングで、コピーオンライトによりコピーが実行される
array1.append(4)
print(array1)
print(array2)

/*
 クラスを利用するべきとき
 
 クラスを利用する場合
    - 参照を共有する必要がある
    - インスタンスのライフサイクルに合わせて処理を実行する
 */

/*
 参照を共有する
 参照を共有することによって、ある箇所での操作を他の箇所へ共有させたいケースにはクラスが適している
 */

protocol Target {
    var identifier: String {get set}
    var count: Int {get set}
    mutating func action()
}

extension Target {
    mutating func action() {
        count += 1
        print("id: \(identifier), count: \(count)")
    }
}

struct ValueTypeTarget: Target {
    var identifier = "Value Type"
    var count = 0
    
    init(){}
}

class ReferenceTypeTarget: Target {
    var identifier = "Reference Type"
    var count = 0
}

struct Timer {
    var target: Target
    
    mutating func start() {
        for _ in 0..<5 {
            target.action()
        }
    }
}

// 構造体のターゲットを登録してタイマーを実行
let valueTypeTarget: Target = ValueTypeTarget()
// targetがコピーして渡される
// 登録したターゲットがイベントを受け取るわけではない
var timer1 = Timer(target: valueTypeTarget)
timer1.start()
print(valueTypeTarget.count) // 0


// クラスのターゲットを登録してタイマーを実行
let referenceTypeTarget = ReferenceTypeTarget()
// 登録したターゲットがタイマーと共有される
var timer2 = Timer(target: referenceTypeTarget)
timer2.start()
print(referenceTypeTarget.count) // 5


/*
 インスタンスのライフサイクルに合わせて処理を実行する
 クラスにあって構造体にない特徴の一つとして、デイニシャライザがある
 デイニシャライザはクラスのインスタンスが解放された時点で即座に実行されるため、インスタンスのライフサイクルに関連するリソースの解放操作を結びつけることができる
 */

var temporaryData: String?

class SomeClass {
    init() {
        print("Create a temporary data")
        temporaryData = "a temporary data"
    }
    
    deinit {
        print("Clean up the temporary data")
        temporaryData = nil
    }
}

var someClass: SomeClass? = SomeClass()
print(temporaryData)

someClass = nil
print(temporaryData)


/*
 クラスの継承に対するプロトコルの優位性
 抽象概念を表現する方法として最も一般的なのはクラスの継承
 Swiftでは値型の利用を推奨しているが、値型である構造体や列挙型には継承に相当する概念はない
 Swiftにはプロトコルという抽象概念を表すもう一つの方法があり、構造体や列挙型にはプロトコルに準拠するという形で抽象的な概念を具象化する
 */

/*
 クラスの継承がもたらす期待しない挙動
 
 メリット
 - move()メソッドの多態性が実現されている
 - それぞれのサブクラスで実装せずともsleep()メソッドを利用できる
 
 デメリット
 - Animalクラスは特定の動物を表さない抽象的な概念であるためインスタンス化は不可能であるべきだが、インスタンス化が可能になってしまっている
 - 野生であるためownerプロパティが不要なWildEagleクラスにも、継承によって自動的にownerプロパティが追加されてしまっている
 */

class Animal {
    var owner: String?
    func sleep() {print("Sleeping")}
    func move(){}
}

class Dog: Animal {
    override func move() {
        print("Running")
    }
}

class Cat: Animal {
    override func move() {
        print("Prancing")
    }
}

class WildEagle: Animal {
    override func move() {
        print("Flying")
    }
}

/*
 プロトコルによるクラスの継承の問題点の克服
 プロトコルとプロトコルエクステンションを利用すれば、クラスの継承で実現可能な挙動を満たした上で、
 クラスの継承の問題点も克服できる
 値型に対しても適用できる
 */

protocol Ownable2 {
    var owner: String {get set}
}

protocol Animal2 {
    func sleep()
    func move()
}

extension Animal2 {
    func sleep() {print("sleeping")}
}

struct Dog2: Animal2, Ownable2 {
    var owner: String
    func move() {
        print("Running")
    }
}

struct Cat2: Animal2, Ownable2 {
    var owner: String
    func move() {
         print("Prancing")
    }
}

struct WildEagle2: Animal2, Ownable2 {
    var owner: String
    func move() {
        print("Flying")
    }
}


/*
 - move()メソッドの多態性が実現されている
    -> 共通のインタフェースをプロトコルで実現している
 - それぞれのサブクラスで実装せずともsleep()メソッドを利用できる
    -> Animalプロトコルを拡張することで、sleep()メソッドのデフォルト実装を定義している
 
 - Animalクラスは特定の動物を表さない抽象的な概念であるためインスタンス化は不可能であるべきだが、インスタンス化が可能になってしまっている
    -> Animalはプロトコルなのでインスタンス化できない
 
 - 野生であるためownerプロパティが不要なwilEagleクラスにも、継承によって自度的にownerプロパティが追加されてしまっている
    -> クラスは多重継承できないが、複数のプロトコルに準拠する型を実装することはできる。
        - (ex)
        - ownerプロパティが必要な型だけ、Ownableプロトコルに準拠させている
 
 継承よりもプロトコルの利用が主流になるため、プロトコルは抽象概念を実装する際に第一の選択肢となる
 */

/*
 クラスの継承を利用するべき時
 - 複数の型の間でストアドプロパティの実装を共有する
 
 プロトコルエクステンションを利用すれば、クラスの継承を利用せずとも、複数の型の間でデフォルト実装を共有できる
 しかし、プロトコルエクステンションにはストアドプロパティを実装できないとうい制限があるため、実装を共有できないケースがある
 */

class Animal3 {
    var owner: String? {
        didSet {
            guard let owner = owner else {return}
            print("\(owner) was assigned as the owner")
        }
    }
}

class Dog3: Animal3 {}

class Cat3: Animal3 {}

class WildEagle3: Animal3 {}

let dog3 = Dog3()
dog3.owner = "Rio Fujimon"

/*
 protocol Ownable {
    var owner: String {get set}
 }
 
 extension Ownable {
    // コンパイルエラー
    var owner: String {
        didSet {
            print("\(owner) was assigned as the owner")
        }
    }
 }
 */

// protocolでコンピューテッドプロパティは、extensionが使えない
protocol Ownable4 {
    var owner: String {get set}
}

struct Dog4: Ownable4 {
    var owner: String {
        didSet {
            print("\(owner) was assigned as the owner")
        }
    }
}

struct Cat4: Ownable4 {
    var owner: String {
        didSet {
            print("\(owner) was assigned as the owner")
        }
    }
}

struct WildEagle4 {}

var dog4 = Dog4(owner: "Rio Fujimon")
dog4.owner = "Rio Fujimon"


/*
 オプショナル型の利用指針
 Swiftの特徴的な言語仕様であるオプショナル型を正しく利用することは、安全なコードを書くための要である
 
 利用指針
 - Optional<Wrapped>型を利用するべき時
 - 暗黙的にアンラップされたOptional<Wrapped>型を利用するべき時
 - 比較検討するべき
 */

/*
 全てのプロパティをOptional<Wrapped>型として宣言することもできるが、コードの厳密性を損ね、かつ冗長なコードを招く原因となる
 */

/*
 値の不在が想定される
 Optional<Wrapped>型は、その値の不在が想定される場合にのみ使用する
 
 ただし、必然性のないOptional<Wrapped>型のプロパティは排除する
 プロパティごとのnil許容性は、できる限り仕様を厳密にして表現しているべき
 */

// メールアドレスが必須ではない
struct User {
    let id: Int
    let name: String
    let mailAddress: String?
}

/*
 struct User {
    let id: Int
    let name: String
    let mailAddress: String?
 
    // idとnameがOptional<Wrapped>型となるためコンパイルエラー
    // jsonで受け取っているため、ダウンキャストが必要
    init(json: [String: Any]) {
        id = json["id"] as? Int
        name = json["name"] as? String
        mailAddress = json["mailAddress"] as? String
    }
 }
 */

// コンパイル可能だが、idとnameが必須であるという仕様を表現していない
struct User2 {
    let id: Int?
    let name: String?
    let mailAddress: String?
    
    init(json: [String: Any]) {
        id = json["id"] as? Int
        name = json["name"] as? String
        mailAddress = json["mailAddress"] as? String
    }
}

let json: [String: Any] = [
    "id": 123,
    "name": "Rio Fujimon"
]

let user = User2(json: json)

// idとnameがnilでないことを確認する必要がある
if let id = user.id, let name = user.name {
    print("id: \(id), name: \(name)")
} else {
    print("Invalid JSON")
}

// good
struct User3 {
    // idとnameの値は仕様通りに必須とする
    let id: Int
    let name: String
    let mailAddress: String?
   
    // 失敗可能イニシャライザの利用
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String else {
            // idやnameを初期化できなかった場合は
            // インスタンスの初期化が失敗する
            return nil
        }
        
        self.id = id
        self.name = name
        self.mailAddress = json["email"] as? String
    }
}

let json2: [String: Any] = [
    "id": 123,
    "name": "Rio Fujimon"
]

if let user = User3(json: json2) {
    print("id: \(user.id), name: \(user.name)")
} else {
    print("Invalid JSON")
}

/*
 暗黙的にアンラップされたOptional<Wrapped>型を利用するべき時
 暗黙的にアンラップされたOptional<Wrapped>型はnilとなることが可能ではあるものの、
 アクセス時には毎回自動的に強制アンラップを行われるため、これをプロパティとして使用することは、
 当然安全ではありません
 */

class Sample {
    var value: String!
}

let sample = Sample()
// 実行時エラー
// print(sample.value.isEmpty)

/*
 以下のケースでは、暗黙的にアンラップされたOptional<Wrapped>型をプロパティとして宣言することが有効
 - 初期化時にのみ値が決まっていない
 - サブクラスの初期化により前にスーパークラスの初期化が必要
 */

/*
 初期化時にのみ値が決まっていない
 初期化時には値が決まらないものの、初期化以降に何かしらの値が必ず設定され、
 その値を使用するときにはnilであることは絶対にない値
 */

/*
 Storyboard：iOSアプリケーションのレイアウトを表現するためのファイル
    - XcodeはこれをGUI上で編集するためのエディタを提供している
    - アウトレット：IBOutlet属性と共に宣言されたプロパティ
    - アウトレットをStoryboard上の要素と紐づけることで、その内容をGUI上から編集できる
    - アウトレットは、Storyboard上の要素から自動的に生成できる
 
 [定義例]
 // someLabelプロパティは、これを所有する型がインスタンス化されるときには空だが、その後に必ずStoryboardから生成された値が設定される
 // そのため、暗黙的にアンラップされた値になっている
 @IBOutlet weak var someLabel: UILabel!
 print(someLabel.text)
 
 // もし、通常Optional<Wrapped>型の値の場合
 // オプショナルバインディングや強制的なアンラップが必要
 if let label = someLabel {
    print(label.text)
 }
 */

/*
 サブクラスよりも前にスーパークラスを初期化する
 
 class SuperClass {
    let one = 1
 }
 
 class BaseClass: SuperClass {
    let two: Int
 
    override init() {
        // 初期化される前のoneにアクセスしているためコンパイルエラー
        two = one + 1
        super.init()
    }
 }
 */

/*
class SuperClass {
    let one = 1
}

class BaseClass: SuperClass {
    let two: Int
    override init() {
        // twoの初期化前にスーパークラスを
        // 初期化しようとしているためコンパイルエラー
        super.init()
        two = one + 1
    }
}
*/

// Swiftでは、スーパークラスのイニシャライザを呼び出す前に、サブクラスのプロパティが初期化されている必要がある
// サブクラスのプロパティを暗黙的にアンラップされたOptional<Wrapped>型として定義する

class SuperClass {
    var one = 1
}

class BaseClass: SuperClass {
    var two: Int!
    
    override init() {
        super.init()
        two = one + 1
    }
}

print(BaseClass().one)
print(BaseClass().two)

/*
 Optional<Wrapped>型と暗黙的にアンラップされたOptional<Wrapped>型を比較検討するべきとき
 
 Optional<Wrapped>型と暗黙的にアンラップされたOptional<Wrapped>型をそれぞれ使用するべきケースの
 どちらを使用するべきか、もしくは、どちらも使用しないべきかを断定できないケースがある
 
 一時的にnilになることがあっても、アクセス時にはnilになり得ないプロパティに対し、暗黙的にアンラップされた
 Optional<Wrapped>型を使用することは、仕様に厳密であると言える。
 しかし、アクセス時に暗黙的にアンラップされたOptional<Wrapped>型の値がnilにならないことをコンパイラが保証できるわけではなく、そのような結果が起こらないようにプログラマーが気をつけないといけない
 つまり、誤った実装をした場合には実装時エラーが発生する可能性があることを意味し、安全ではない
 
 
 冗長ではあるものの、こうしたケースに対して常にOptional<Wrapped>型を使用すれば、
 予期せぬnilへのアクセスによる実行時エラーは起こり得ない。
 これは、厳密ではないものの安全である。
 
 安全性を取るか、仕様に対する厳密性を取るかの選択は、プログラムが予期しない不正な状態に陥ったときに、
 どうなって欲しいかを選択することと等価である。
 予期しない状態になった場合、プログラムが終了することが望ましいのであれば、
 暗黙的にアンラップされたOptional<Wrapped>型を選択するべき
 不正な状態でも可能な限り実行を継続して動作してほしいのであれば、
 できる限りOptional<Wrapped>型を選択するべき
 */
