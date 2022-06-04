# VRCChanger
VRCのコマンドラインオプション適当に組み合せていい感じに起動してくれるやつ

## 機能
| 項目 | 説明 |
| ---- | ---- |
| `VRC起動後も開いたままにする` | チェックを外すとVRC起動させた後にVRCChangerが終了する。 |
| `VRMode` | チェック付いてるとVR、付いてないとDesktopで起動する。 |
| `Profile` | `--profile=X`の`X`を指定して起動する。デフォルトは0。 |
| `Custom home world` | 公式サイトの`LAUNCH WORLD`のボタンに付いてるリンクを突っ込むと起動時にそのインスタンスから起動する。 |
| `Other options` | GUIにないオプションがある場合はスペース区切りでここに書けばOK。(midiなど) |
| `Debug/Enable` | デバッグ関連の設定を有効化。 |
| `Debug/Debug gui` | デバッグ用のGUIを有効化。(`--enable-debug-gui `を指定して起動。) |
| `Debug/SDK log levels` | 追加ログの有効化。(`--enable-sdk-log-levels`を指定して起動。) |
| `Debug/Udon debug logging` | Udonのheapとstack dumpを有効化。(`--enable-udon-debug-logging`を指定して起動。) |
| `Debug/IK debug logging` | IKに関する追加のログを有効化。(`--enable-ik-debug-logging`を指定して起動。) |
| `Window/Enable` | ウインドウ関連の設定を有効化。 |
| `Window/Full screen` | フルスクリーンで起動。 |
| `Window/Max FPS(Desktop only)` | 最大FPSの指定。上げるとマウス感度がエグいぐらい鈍くなるので基本いじらないことを推奨。 |
| `Window/Screen width` | ウインドウの横幅の指定。 |
| `Window/Screen height` | ウインドウの縦幅の指定。 |
| `IK/Enable` | IK関連の設定を有効化。 |
| `IK/Legacy FBT calibrate` | 従来のキャリブレーションの使用を強制する。(`--legacy-fbt-calibrate`を指定して起動。) |
| `IK/Custom arm ratio` | 腕によるアバタースケーリングを使用している場合に使用される腕の比率の指定。(--custom-arm-ratioの値を指定。)デフォルトは0.4537 |
| `IK/Disable shoulder tracking` | 一部のIMU方式の腕トラッカーで発生する問題を回避する。(`--disable-shoulder-tracking`を指定して起動。) |
| `IK/Calibration range` | キャリブレーション時のバインディングポイントからの検索範囲を指定。(`--calibration-range`の値を指定。)メートル単位。デフォルトは0.6 |
| `IK/Freeze tracking on disconnect` | トラッカーが切断された時にその場でフリーズするように設定。(`--freeze-tracking-on-disconnect`を指定して起動。) |
| `Save` | 現在の設定をデフォルト設定に上書きして保存。次起動したらその設定になる。生成された`profile.json`を削除するとデフォルトに戻る。 |
| `Launch` | 現在の設定で起動。 |

コマンドラインオプションの意味の詳細は[こちら](https://docs.vrchat.com/docs/launch-options)。

## Build
```
nim c -d:release --app:gui -o:VRCChanger.exe src/VRCChanger.nim
```

## License
MIT
