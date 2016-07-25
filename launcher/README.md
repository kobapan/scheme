# launcher.scm

command launcher written by gauche-gtk

## 使い方

一度呼び出したコマンドを優先的に呼び出します。

例えば

「firefox」を呼び出すとして、一回目は「fir」まで入力すると「firefox」というコマンドと一致して、エンターキーで実行できますが、二回目からは「f」を入力した時点でエンターキーを押すと「firefox」が実行されます。


## ホットキーの登録

GNOME系

システムツール＞設定＞システム設定＞キーボード＞ショートカット

名前:launcher.scm

コマンド：gosh /PATH/TO/launcher.scm


