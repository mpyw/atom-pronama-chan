# mpyw/atom-simple-wallpaper-changer

## インストール方法

```bash
apm install https://github.com/mpyw/atom-simple-wallpaper-changer
```

## [オリジナル](https://github.com/hurumeki/atom-pronama-chan)との違い

- 背景画像の表示だけに用途を限定しています．
- 自分で画像を用意しないと使えません．お好きなキャラクターの画像を用意してください．
- 最初は背景画像をランダム表示します．但し，設定で **Default Image** を指定している場合にはそれを表示します．
- 設定の変更やファイルの作成を検知すると，自動的に再読み込みします．

## 画像を設置するディレクトリ

パッケージの設定から **Assets Directory** を指定してください．  
その直下に配置された拡張子 `*.png` `*.gif` `*.jpg` のファイルが対象になります．

## ショートカット

|Key|Description|
|:-:|:-:|
|<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>K</kbd>|表示/非表示|
|<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>L</kbd>|画像巡回|