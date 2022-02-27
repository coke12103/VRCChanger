# VRCChanger
VRCのコマンドラインオプション適当に組み合せていい感じに起動してくれるやつ

## 機能
| 項目 | 説明 |
| ---- | ---- |
| `[*]のついた項目を無効化` | 普段使わない項目を適当に無効化する。 |
| `VRC起動後も開いたままにする` | チェックを外すとVRC起動させた後にVRCChangerが終了する。 |
| `VRMode` | チェック付いてるとVR、付いてないとDesktopで起動する。 |
| `Debug` | `--enable-debug-gui`を指定して起動。 |
| `FullScreen` | フルスクリーンで起動。この項目が無効化されている場合は常にウインドウで起動。 |
| `Profile` | `--profile=X`の`X`を指定して起動する。数字で指定。デフォルトは0。
| `Max FPS` | 最大FPSの指定。上げるとマウス感度がエグいぐらい鈍くなるので基本いじらないことを推奨。 |
| `Screen Width` | 横幅。 |
| `Screen Height` | 縦幅。 |
| `Other options` | これら以外に指定したいオプションがある場合はスペース区切りでここに書けばOK。(`--enable-sdk-log-levels`など) |
| `Save` | 現在の設定をデフォルト設定に上書きして保存。次起動したらその設定になる。生成された`profile.json`を削除するとデフォルトに戻る。 |
| `Launch` | 現在の設定で起動。 |

コマンドラインオプションの意味は[こちら](https://docs.vrchat.com/docs/launch-options)。

## Build
```
nim c -d:release --app:gui -o:VRCChanger.exe src/VRCChanger.nim
```

## License
MIT
