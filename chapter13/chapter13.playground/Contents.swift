/*
 イベント：UI要素のタップやプロパティの値の変更など、アプリケーション内で発生するあらゆる事象
 通知：イベントの発生箇所となるオブジェクトが、ほかのオブジェクトにイベントの発生を伝えること
 */

/*
 Swiftにおけるイベント通知のパターン
 
 オブジェクト間で相互にイベント通知が発生するのは、どのようなケースか？
    - オブジェクトが別のオブジェクトに処理を依頼
    - 特定の処理の開始や終了を伝えたりする
 
 複数のオブジェクトが互いにイベント通知を行いたい場合、やみくもにオブジェクトどうしを参照させ会えばよいわけではない
 やみくもに実装すると、依存関係が複雑になりすぎてメンテナンスが不可能になってしまったり、メモリリークが発生してしまったりする可能性がある
 */

/*
 iOSやmacOS向けのアプリケーションをSwiftで実装する場合、Appleが開発したCocoa、Cocoa Touchというオブジェクト指向のAPI群を利用する
 
 オブジェクト間のイベント通知方法
    - デリゲートパターン
    - クロージャ
    - オブザーバーパターン
 */

/*
 デリゲートパターン：別オブジェクトへの処理の委譲
    - Cocoa, Cocoa Touchの主要なコンポーネントの多くは、デリゲートパターンを用いて実装されている
 
 NSWindowクラス：macOSアプリケーションのウィンドウを管理する
 UITableViewクラス：iOSアプリケーションでリスト形式の情報を表示する
 
 デリゲートパターン：あるオブジェクトの処理を別のオブジェクトに代替させる
    - デリゲート元のオブジェクトは適切なタイミングで、デリゲート先のオブジェクトにメッセージを送る
    - デリゲート先のオブジェクトはメッセージを受けて、自分自身や別のオブジェクトの状態を変更したり、何かしらの結果をデリゲート元のオブジェクトに返す

 デリゲートパターンを用いると、デリゲート先のオブジェクトを切り替えることでデリゲート元の振る舞いを柔軟に変更できる
 一方で、必要な処理はプロトコルとして事前に宣言せれている必要があり、記述するコードは多くなりがち
 */

/*
 デリゲートパターンの実装方法
 - デリゲートパターンでは、移譲する処理をプロトコルとしてメソッドとして宣言する
 - デリゲート先のオブジェクトはそのプロトコルに準拠し、デリゲート元のオブジェクトからの処理の委譲に応えられるようにする
 - デリゲート元のオブジェクトはデリゲート先のオブジェクトをプロパティとして持ち、デリゲート先のメソッドを実装して処理を委譲する
 */

protocol GameDelegate: AnyObject {
    var numberOfPlayers: Int {get}
    func gameDidStart(_ game: Game)
    func gameDidEnd(_ game: Game)
}

class TwoPersonsGameDelegate: GameDelegate {
    var numberOfPlayers: Int {return 2}
    func gameDidStart(_ game: Game) { print("Game start") }
    func gameDidEnd(_ game: Game) { print("Game end") }
}

class Game {
    weak var delegate: GameDelegate?
    
    func start() {
        print("Number of players is \(delegate?.numberOfPlayers ?? 1)")
        delegate?.gameDidStart(self)
        print("Playing")
        delegate?.gameDidEnd(self)
    }
}

let delegate = TwoPersonsGameDelegate()
let twoPersonsGame = Game()
twoPersonsGame.delegate = delegate
twoPersonsGame.start()

/*
 デリゲートパターンの命名規則
 デリゲートパターンでは、デリゲート先にデリゲート元から呼び出されるメソッド群を実装する必要がある
 どのようなメソッド群を実装する必要があるかは、プロトコルとして宣言する
 
 [重要]
 プロトコルやメソッドの命名については、Cocoa, Cocoa Touchフレームワーク内で利用されているデリゲートパターンの実装を参考にする
    - デリゲートパターンでは、さまざまなタイミングでデリゲート先のメソッドが実行されるため、「どのタイミングで呼び出されるか」ということを「did」や「will」といった「助動詞」を用いて表現する
        - セルがタップされた直後 -> didSelect
    - デリゲート元はデリゲート先が必要としている情報を引数を通じて渡す。
        - 「どのインデックスのセルがタップされたか」という情報が必要なので、IndexPath型が引数となる

    - Cocoaのデリゲートパターンでは、メソッド名をデリゲート元のオブジェクト名から始め、第1引数にデリゲート元のオブジェクトを渡すことになっている。
        - tableView(_: didSelectRowAt:)メソッドのデリゲート元はUITableViewクラスであるため、メソッド名はtableViewから始まり、これが名前空間の役割を果たす
 [NG]
 // 複数のプロトコルに準拠する際に、似たような役割を持ったデリゲートメソッドどうしの名前が衝突する可能性がある
 func didSelectRowAt(indexPath: IndexPath)
 
 [ex]
 public protocol UITableViewDelegate: NSObjectProtocol, UIScrollViewDelegate {
    (省略)
    optional public func tableView(
        _ tableView: UITableView,
        didSelectRowAt index: IndexPath
    )
 }
 
 - メソッド名はデリゲート元のオブジェクト名から始め、続いてイベントを説明する
 - didやwillなどの助動詞を用いてイベントのタイミングを示す
 - 第1引数には、デリゲート元のオブジェクトを渡す
 
 命名規則は、自分自身で定義したデリゲートメソッドにも適用するべき
    - 名前の衝突を回避できる
    - 既存のCocoa, Cocoa Touchフレームワークと違和感なく強調させることができるので、利用する側が扱いやすいというメリットもある
 */

/*
 弱参照による循環参照への対処
 ARCでは使用中のインスタンスのメモリが解放されてしまうことを防ぐために、プロパティ、変数、定数からクラスのインスタンスへの参照がいくつあるのかを参照カウンタとしてカウントしており、参照カウンタが0になったときにクラスのインスタンスのメモリの解放が行われる
 
 クラスのインスタンスへの参照
    - 強参照：参照カウントを1つカウントアップ。デフォルトでは強参照
    - 弱参照：参照カウントをカウントアップしない。弱参照は循環参照の解消に用いる

 weakキーワードとともにプロパティを宣言すると、「弱参照」となる
 
 循環参照: インスタンスやクロージャの強参照が循環し、外部の所有者を失っても解放されない状態。2つ以上の対象を経由する場合もある。
    - 参照カウンタが0になることはない
    - 仮にこれらのインスタンスが不要になっても、そのメモリは確保されたままとなる
 
 メモリリーク：メモリが確保されたまま解放されない問題全般
    - メモリ領域の圧迫によってパフォーマンスの低下を招いたり、場合によってはアプリケーションを終了させてしまう
 
 デリゲートパターンでは、デリゲート先のオブジェクトとデリゲート元のオブジェクトが互いに参照し合う可能性がある
 そのため、通常はデリゲート元からデリゲート先への参照を弱参照として、循環参照を回避する
 */

/*
 デリゲートパターンを利用するべき時
 
 1. 2つのオブジェクト間で多くの種類のイベント通知を行う
    - (ex)
    - 非同期処理中に発生するイベントに応じて実行する関数を切り替えたいケース
        - 非同期処理を開始したタイミングで、プログレスバーを表示
        - 非同期処理の途中で、定期的にプログレスバーを更新
        - 非同期処理が完了したタイミングで、プログレスバーを非表示にする
        - 非同期処理が失敗したタイミングで、エラーダイアログを表示する
 
 クロージャによるコールバックでは、コールバック時の処理を非同期処理の開始位置と同じ箇所に記述できる
 しかし、このように複数のコールバックが存在するケースでは、かえって煩雑になる
 
 通知するイベントの種類が多い場合は、デリゲートパターンとして実装するのが良い
 */

/*
 外部からカスタマイズを前提としたオブジェクトを設計する
 オブジェクトの中には、外部からのカスタマイズを前提とした設計が適しているものがあり、そのようなケースではデリゲートパターンを採用するのが良い
 
 デリゲートパターンでは、カスタマイズ可能な処理をプロトコルとして定義するため、オブジェクトのどの振る舞いがカスタマイズ可能かは明らかである。
    - UITableViewクラスの場合、画面によって異なるセルの選択時の動作をデリゲート先に委譲できるようにしている
 
 
 特定のクラスをカスタマイズする方法として、継承を使うことも考えられる
 あるクラスを継承すると、そのクラスのパブリックなAPIはすべてカスタマイズ可能になるが、
 クラスによってはカスタマイズして利用されることを想定していない場合もある。
 APIの一部をカスタマイズ可能にしたいという場合に、継承ではなくデリゲートパターンを選択するべき
 */


/*
 クロージャ：別オブジェクトへのコールバック時の処理の登録
 
 クロージャは、コールバックとしてよく利用される
    - (ex)
    - 非同期処理のためのDispatchモジュールのAPIの多くは、コールバックをクロージャで受け取る
 
 
 クロージャを用いると、呼び出し元と同じ場所にコールバック処理を記述できるので、処理の流れを追いやすい
 一方で、複数のコールバック関数が必要であったり、コールバック時の処理が複雑な場合は、クロージャの性質上、ネストが深くなりやすい
 */

/*
 クロージャの実装方法
 
 非同期処理を行うメソッドの引数にクロージャを追加する
 非同期処理を行うメソッドでは、処理の完了時にコールバックを受け取るクロージャを実行し、結果をクロージャの引数に渡す
 */

class Game2 {
    private var result = 0
    
    func start(completion: (Int) -> Void) {
        print("Playing")
        result = 42
        completion(result)
    }
}

let game2 = Game2()
game2.start { result in
    print("Result is \(result)")
}

/*
 キャプチャリスト：キャプチャ時の参照方法の制御
 
 クロージャのキャプチャ：クロージャが定義されたスコープに存在する変数や定数への参照を、クロージャ内のスコープでも保持することをいう
 
 デフォルトでは、キャプチャはクラスのインスタンスの強参照となる。
 そのため、クロージャが解放されない限りはキャプチャされたクラスのインスタンスは解放されない
 */

import PlaygroundSupport
import Dispatch

// Playgroundでの非同期実行を待つオプション
PlaygroundPage.current.needsIndefiniteExecution = true

class SomeClass {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    deinit {
        print("deinit")
    }
}

do {
    let object = SomeClass(id: 42)
    
    let queue = DispatchQueue.main
    
    queue.asyncAfter(deadline: .now() + 3) {
        print(object.id)
    }
}

/*
 キャプチャリスト（capture list）を用いることで、弱参照を持つこともできる
 弱参照のキャプチャは参照先の寿命を延ばさない。参照先は、他の強参照がなくなったときに解放される。
 キャプチャを弱参照にすることは、クロージャとキャプチャされたクラスのインスタンスの循環参照の解消にも役立つ
 
 [定義]
 キャプチャリストを定義するには、クロージャの引数の定義の前に[]を追加し、内部にweakキーワードもしくはunownedキーワードと変数名もしくは、定数名の組み合わせを「,」区切りで列挙する
 
 {[weakまたはunowned 変数名または定数名](引数) -> 戻り値 in
    // クロージャの呼び出し時に実行される文
 }
 */

class SomeClass2 {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

let object1 = SomeClass2(id: 42)
let object2 = SomeClass2(id: 43)

let closure = {[weak object1, unowned object2] () -> Void in
    print(type(of: object1))
    print(type(of: object2))
}

closure()

/*
 weakキーワード：メモリ解放を想定した弱参照
 
 weakキーワードを指定して、変数や定数をキャプチャした場合、
 クロージャはOptional<Wrapped>型の同名の変数を新たに定義し、キャプチャ対象となる変数や定数の値を代入する
 
 weakキーワードを指定して、キャプチャした変数や定数は、参照先に対して弱参照を持つ
 弱参照ということは、クロージャの実行時に参照先のインスタンスがすでに解放されている可能性があることを意味する
 参照先のインスタンスが既に解放されていた場合、weakキーワードが指定してキャプチャした変数や定数の値は自動的にnilとなる。
 参照先がnilの場合をOptionalとして処理できる。ただし、強制アンラップすれば実行時エラーになり得る。
 */

class SomeClass3 {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

do {
    let object = SomeClass3(id: 42)
    let closure = {[weak object] () -> Void in
        if let o = object {
            print("objectはまだ解放されていない: id => \(o.id)")
        } else {
            print("objectは既に解放されました")
        }
    }
    
    print("ローカルスコープ内で実行：", terminator: "")

    closure()
    
    let queue = DispatchQueue.main
    queue.asyncAfter(deadline: .now() + 1) {
        print("ローカルスコープ外で実行:", terminator: "")
        closure()
    }
}

/*
 unownedは参照先を保持しない非所有参照で、weakとは区別する。
 ここで使う非Optionalのunownedは、参照先が解放されてもnilにならない。
 参照先が先に解放された後でアクセスすると実行時エラーになるため、
 使用中は参照先が生存するという関係を設計で保証できる場合に限って使う。
 */

class SomeClass4 {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
}

do {
    let object = SomeClass4(id: 42)
    
    let closure = {[unowned object] () -> Void in
        print("objectはまだ解放されていません: id => \(object.id)")
    }
    
    print("ローカルスコープ内で実行：", terminator: "")
    closure()
   
    /*
    let queue = DispatchQueue.main
    queue.asyncAfter(deadline: .now() + 1) {
        print("ローカルスコープ外で実行")
        // 実行時エラー
        closure()
    }
     */
}

/*
 キャプチャの選択は、所有関係と必要な生存期間から判断する。
 - 強参照: 処理が終わるまで対象を保持する必要があり、所有関係が循環しない場合。
   キャプチャリストで[self]と明示しても強参照になる。
 - weak: 対象が先に解放される可能性があり、その場合に処理を省略できる場合。
 - unowned: 対象が参照の使用中は必ず生存する関係を保証できる場合。
   Optionalの扱いを省くことだけを理由に選ばない。
 クロージャを保持する側から参照先までを確認し、weakを付けただけで
 すべての循環参照が解消したと判断しない。
 */

/*
 escapingクロージャでは、selfのキャプチャを明示して所有関係に気づきやすくする。
 通常はself.を付けるが、[self]による明示的なキャプチャや、対応するSwiftバージョンでの
 [weak self]とguard let selfの組み合わせなど、暗黙のselfが許可される書き方もある。
 */

class Executor {
    let int = 0
    var lastExecutedClosure: (() -> Void)? = nil
    
    func execute(_ closure: @escaping () -> Void) {
        // キャプチャを行ったクロージャをストアドプロパティlastExecutedClosureに保存
        closure()
        // selfはクロージャにキャプチャされ、クロージャはselfのストアドプロパティに保存されているため、
        // 循環参照が発生
        lastExecutedClosure = closure
    }
    
    func executePrintInt() {
        execute {
            // selfのキャプチャが行われる
            // selfを使用せずに、intプロパティにアクセス可能だった場合、selfがキャプチャされることに気付きにくくなる
            print(self.int)
        }
    }
}

/*
 typealiasキーワードによる複雑なクロージャの型への型エイリアス
 
 typealiasキーワードを用いることで、複雑なクロージャの型に型エイリアスを設定できる
 
 (ex)
 func someMethod(completion: (Int?, Error?, Array<String>?) -> Void){}
 */

typealias CompletionHandler = (Int?, Error?, Array<String>?) -> Void

func someMethod(completion: CompletionHandler){}

/*
 クロージャを利用するべき時
 
 処理の実行とコールバックを同じ箇所に記述する
    - デリゲートパターンに比べて、処理の流れが追いやすい
    - いくつものクロージャを引数に受け取るメソッドは可読性が低くなる
 
 game.start { result in
    print("Result is \(result)")
 }
 */


/*
 オブザーバーパターン：状態変化の別オブジェクトへの通知
 
 デリゲートパターンやコールバックは、1対1のイベント通知でしか有効ではない
    - (ex)
        - デリゲートパターンではデリゲート先となるオブジェクトは1つで、同じイベントを複数のオブジェクトが受け取ろうとすると、その数だけデリゲート先を追加しなければいけない
    - コールバックも呼び出し元しか、その結果を知ることができない
 
 1つのイベントの結果を複数のオブジェクトが知る必要がある場合もある
    - (ex)
        - 特定のオブジェクトが変更されたタイミングで、複数の画面が更新される
 
 オブザーバーパターンは、1対多のイベント通知を可能にする
    - (ex)
    - Cocoa Touchでは、アプリケーションの起動やバックグラウンドへの遷移のイベント通知にオブザーバーパターン
 
 オブザーバーパターンの構成要素
    - サブジェクト：オブザーバーを管理し、必要なタイミングでオブザーバーに通知を発行する。
        - オブザーバーのメソッドを呼び出す
        - オブザーバーに関して知る必要があるのは、オブザーバーの通知の受け口であるメソッドのインタフェース
    - オブザーバー：通知を受け取る対象
 
 オブザーバーパターンにより、疎結合を保ったままオブジェクト間を連携させることができる
 一方で、むやみやたらに多用すると、どのタイミングで通知が発生するか予想しづらくなり、処理を追うのが難しくなる
 */

/*
 iOSやmacOSアプリケーションでは、オブザーバーパターンをCocoaが提供する「Notification型」と「NotificationCenterクラス」を用いて実装する
 
 NotificationCenter：サブジェクトであり、中央に位置するハブのような役割をする
    - このクラスを通じて、オブジェクトは通知の送受信を行う
    - オブザーバーはこのクラスに登録され、登録の際に、通知を受け取るイベントと受け取る際に利用するメソッドを指定する
    - 1つのイベントに対して、複数のオブザーバーを登録できるので、1対多の関係のイベント通知が可能になる
 
 Notification：NotificationCenterクラスから発行される通知をカプセル化したもの
    - Notification型は、name、object、userInfoというプロパティを持つ
    - name：通知を特定するためのタグ
    - object：通知を送ったプロジェクト
    - userInfo：通知に関連するその他の情報
 
 
 [実装]
 1. 通知を受け取るオブジェクトにNotification型の値を引数に持つメソッドを実装
 2. NotificationCenterクラスに通知を受け取るオブジェクトを登録
 3. NotificationCenterクラスに通知を投稿する
 */

import Foundation

class Poster {
    static let notificationName = Notification.Name("SomeNotification")
    
    // NotificationCenterクラスへの通知の投稿は、post(name:object:)メソッドを用いる
    // 通知の名前、通知を送るオブジェクト（多くの場合は自分自身）を渡す
    // Notification型のインスタンスを自動的に作成するので、自分自身で作成する必要はない
    func post() {
        NotificationCenter.default.post(name: Poster.notificationName, object: nil)
    }
}

/*
 Observer型は、Notification型の値を引数に持つメソッドhandleNotification(_:)を持っており、このメソッドを通じて受け取る。
 */
class Observer {
    init() {
        // オブザーバのNotificationCenterクラスへの登録は、addObserver(_:, selector:name:object:)メソッドを用いる
        // 通知を受け取るオブジェクト、通知を受け取るメソッド、受け取りたい通知の名前を登録
        // "SomeNotification"という名前の通知をhandleNotification(_:)メソッドで受け取るように登録
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification(_:)),
            name: Poster.notificationName,
            object: nil
        )
    }
    
    @objc func handleNotification(_ notification: Notification) {
        print("通知を受け取りました")
    }
    
    // （注意）
    // オブザーバが破棄されるタイミングで、そのオブザーバへの通知をやめるという処理を明示的に記述する必要がある
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

/*
 Poster型とObserver型の値をインスタンス化し、Poster型のpost()メソッドを呼び出すと、
 サブジェクトであるNotificationCenterクラスを通じてSomeNotificationという名前の通知が発行される
 Observer型は、この通知をhandleNotification(_:)メソッドで受け取り、"通知を受け取りました"というメッセージを出力する
 
 */
var observer = Observer()
let poster = Poster()
poster.post()


/*
 Selector型：メソッドを参照するための型
 
 addObserver(_:selector:name:object:)メソッドを利用した
 
 open func addObserver(_ observer: Any,
    selector aSelector: Selector,
    name aName: NSNotification.Name?,
    object anObject: Any?
 )
 
 Selector型：Objective-Cのセレクタという概念を表現
 セレクタ：メソッドの名前を表す型で、これを利用することで、メソッドをそれが属する型とは切り離して扱うことが可能
 
 Selector型を生成するには、#selectorキーワードを利用する
 #selectorキーワードに参照したいメソッド名を渡すことで、Selector型の値を生成できる。
 また、プロパティ名の前に、setterやgetterラベルを記述することで、セッタやゲッタのセレクトを取得できる
 自身が属するスコープ内のメソッドを参照する場合は型名を省略できる
 
 [定義]
 #selector(型名.メソッド名)
 #selector(setter: 型名.プロパティ名)
 
 セレクタはObjective-Cの概念であるため、Selector型を生成するには、メソッドがObjective-Cから参照可能である必要がある
 メソッドをObjective-Cから参照可能にするためには、「objc属性」を指定する
 */

class SomeClass5: NSObject {
    @objc func someMethod(){}
}

let selector = #selector(SomeClass5.someMethod)
print(type(of: selector))

/*
 オブザバパターンを利用するべき時
 
 1対多のイベント通知を行う時
 1対多のイベント通知が発生する場合は、オブザーバパターンを利用する
    - (ex)
        - ユーザー情報を表示している画面が複数あり、ユーザーがプロフィールを更新するなどして、それらすべての画面を再描画する必要が生じたとする
        - 更新する必要がある画面をすべてオブザーバとして登録しておき、プロフィールが更新されたタイミングで登録された画面すべてに通知を送り、再描画する
 
 オブザーバパターンは、どの処理がいつ実行されるかをコード上からただちに読み取ることが困難であるので、
 濫用するべきではない。1対1の処理では、オブザーバパターンではなく、デリゲートパターンやクロージャによるコールバックを利用する
 */
