# XCTest の学習サンプル

通常の検証は、このディレクトリで `swift test` を実行します。温度変換、非同期処理、HTTPクライアントのスタブ、アサーションとテストのライフサイクルを扱います。

## 意図的にクラッシュする例

`SomeTestCaseTests.testWithNil` は、`XCTAssertNotNil` の失敗後にも処理が継続し、nilの強制アンラップでクラッシュすることを観察する教材です。通常実行ではこの1件を明示的にスキップします。

学習のために再現する場合のみ、以下を実行します。このコマンドは失敗終了します。

```sh
RUN_CRASH_EXAMPLE=1 swift test --filter SomeTestCaseTests/testWithNil
```

通常のアプリやテストでは、値を使う前に `guard let` または `try XCTUnwrap` でアンラップしてください。
