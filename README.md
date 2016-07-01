# mpyw/atom-simple-wallpaper-changer

## インストール方法

```bash
apm install https://github.com/mpyw/atom-simple-wallpaper-changer
```

## [オリジナル](https://github.com/hurumeki/atom-pronama-chan)との違い

- 背景画像の表示だけに用途を限定しました．
- 最初は背景画像をランダム表示します．但し，設定でデフォルトを指定している場合にはそれを表示します．
- 自分で`assets`を用意しないと使えません．

## 画像の追加

直接画像を`assets`に放り込んでください．

```
atom-simple-wallpaper-changer
  - assets
    - xxx.png
    - yyy.png
    - zzz.png
    - ...
```

## 使い方

|Key|Description|
|:-:|:-:|
|<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>K</kbd>|表示/非表示|
|<kbd>Ctrl</kbd><kbd>Alt</kbd><kbd>L</kbd>|画像巡回|