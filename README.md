# swift-introduction-to-practice
Swift実践入門（第3版）の写経用リポジトリ

## 検証環境と実行方法

検証用ツールチェーンはXcode 26.6 / Swift 6.3です。Swiftの言語モード・iOSの最低バージョンは各プロジェクトの設定を使用します。macOSでXcodeをインストールし、初回起動時の追加コンポーネントのインストールを完了してください。

リポジトリのルートで以下を実行します。

```sh
# 検証対象と番号の一覧
swift Scripts/verify.swift --list

# 全対象を順番に検証
swift Scripts/verify.swift

# 1件だけ検証（0始まり）
swift Scripts/verify.swift --index 0
```

アプリは署名不要のSimulator向けにビルドし、Swiftパッケージは `swift test` で検証します。作業用ディレクトリは実行ごとに作成・削除するため、初回と同様に時間がかかります。依存パッケージの取得にはネットワーク接続が必要です。

## 検証対象

| 番号 | 対象 | 種類 | 開く場所 |
| ---: | --- | --- | --- |
| 0 | `chapter01/demo` | Swiftテスト | `chapter01/demo` |
| 1 | `chapter11/Example` | Swiftテスト | `chapter11/Example` |
| 2 | `chapter17/Demo` | Swiftテスト | `chapter17/Demo` |
| 3 | `chapter18/github_search_repository` | Swiftテスト | `chapter18/github_search_repository` |

アプリを操作するには表のworkspace（ある場合）またはprojectをXcodeで開き、対象のschemeとiPhone Simulatorを選択して実行します。実機で動かす場合は、ご自身のSigning Teamを設定してください。

## CIと検証範囲

`Quality` ワークフローは上記と同じ一覧・スクリプトを使い、対象ごとにビルドまたはテストを実行します。ビルドの成功だけでは、画面表示、アクセシビリティ、通信先の動作、テスト網羅性は保証されません。UIサンプルはSimulator上での操作確認も必要です。

第17章の意図的にクラッシュするテストは通常実行で1件スキップします。再現方法は [DemoのREADME](chapter17/Demo/README.md) を参照してください。

## Swiftコード品質

[設計・命名・所有関係の方針と、この教材への適用範囲](SWIFT-QUALITY.md)を参照してください。
