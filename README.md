# cbuild by sake
大学の演習時に使いたいツール  
毎回Makefileやコメントが必要なcファイルを作るのがめんどくさい，
実行時の入力と出力のリダイレクトがめんどくさい．
それらを楽にしたいという目的で作られた．  
つまりそれ以外はおまけ  
rubyで作られているのは，文字列の扱いとか諸々cより楽だから  
名前はcbuildで作ったものを他の名前に変えるのがめんどくさいので
sakeコマンドによってcをbuildしますよ的な後付．暇なときに直すかもしれない
## rubyの勉強
rubyの勉強と言いながら別に勉強しているわけではない．  
一応絵本は読んだ．  
そのうち時間があればcでやり直すかもしれない
## オブジェクト指向の勉強
オブジェクト指向の勉強と言いながら別にオブジェクト指向で設計されているわけではない．
```ruby
class a
    attr_accessor :aba
    def b
        @aba = "あばばば"
    end
    def c
        puts @aba
    end
end
```
みたいな感じで全部作ればいいらしい
## インストール方法
以下を実行
```shell
$ git clone https://github.com/pacificbelt30/ruby_cbuild
$ cd ruby_cbuild
$ bash install.sh #~/.cbuild以下にインストールされる
```
エラーがでても多分うまく行っているので複数回実行しない  
終了後は各自cloneしたディレクトリを削除してください．  
## 使用方法
makefileなどのテンプレートを作成する  
~/.cbuild/tmpl の中にあるファイルを編集して自分用のテンプレを作れ  
~/.cbuild/env.rb に作成者と学籍番号を設定する  
端末で＄sakeってうとう！そしたらヘルプがでるぞ！  
```
$ sake {command} [ファイル名] 
``` 

コマンド：  
  * build {ターゲット} makeするターゲットは省略可(その場合はTARGET全部がmakeされる)  
  * run   [option] {実行ファイル名} コンパイルして実行する   
      -i 同名の.inがある場合標準入力にリダイレクトする  
      -o 同名の.outを作成し，標準出力をリダイレクトする  
      -io どっちも  
  * new   makefileがない場合新規作成する  
  * gen   {拡張子抜きファイル名} .cファイルを作り，MakefileのTARGETに追加する ファイル名は複数指定可  
  * genh {拡張子なしファイル名} .hファイルを作り MakefileのHFに追加する   
  * genf {拡張子なしファイル名} .cファイルを作る Makefileには追加しない  
  * rm .oファイルと実行ファイルを削除する．(make cleanを実行してるだけ)  
  * version バージョン  

注意：
  Makefileに書き込むコマンド(gen系)は./.cbuildにMakefileのバックアップファイルを作る
  
## 更新
更新方法は考え中  
~/.cbuild/以下で
```
$ git pull 
```
で行けるかもしれない
