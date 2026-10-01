# BFElement
プロダクト間共通定数、定数関連ソースコード自動生成ライブラリ

BFElement はプリンター名や印刷設定名の統一を目指したプロジェクトである。
自動生成結果も管理しているため、使用するだけならビルドの必要はない。変更のためにビルドする場合は以下の章を参照する。

## ビルド準備
以下をインストールする。
- Python (2.3/2.4/2.5/2.6/3.1/3.2/3.3 以外のバージョン)
- Jinja2 (http://jinja.pocoo.org/docs/2.10/)

### Xcode の Run script から Jinja2 を実行する
ターミナルでパスが通っている Python と Xcode で参照される Python は別のバイナリを指す (ことが多い) ので、Xcode の Run Script で Jinja2 を実行する場合は、次の章に示すような手順が必要になる。

#### Xcode が参照する Python にインストール
1. Xcode で任意のプロジェクトに新規ターゲットを作成する (cross-platform -> aggregate)
2. Build Phase に Run Script を追加する
3. 以下のスクリプトを記述して、実行する
```
pip3 install --upgrade pip --user
pip3 install jinja2
```
このスクリプトを実行する際、ネットワーク接続に Proxy 情報が必要な場合は、事前に設定しておく。もしくは、Proxy が必要ないネットワークに接続する。

#### 別途インストールした Python にインストールし、Xcode から参照する
1. 上記スクリプトをターミナルで実行する
2. Xcode が実行する Jinja2 を呼ぶスクリプトで、ターミナルが参照する Python へのパスを通す  
または、スクリプトでターミナルが参照する Python の絶対パスを直接記述する

## ビルド
_main.py_ を実行する。
```
$ python3 main.py
```

## 構成
BFElementには大きく分けて４つのコンテンツがある。
- テンプレート
- データベース
- スクリプトライブラリ
- ソースコード

それぞれのコンテンツの概要は、[jinja2AndMetaProgramming](docs/jinja2AndMetaProgramming.pdf) で説明している。

### テンプレート
成果物のソースコードのひな型であり、Jinja2 によって変数が展開されるファイル。  
_src/template/_ ディレクトリの中身が相当する。

### データベース
Jinja2 に渡す変数が記述されるファイル。このファイルに記述された情報がテンプレートに展開される。  
_src/database/_ ディレクトリの中身が相当する。

### スクリプトライブラリ
BFElement で管理するデータベースを読み込み、テンプレートに展開するスクリプト。  
_create_definition.py_ が相当する。

### ソースコード
自動生成の成果物ファイル。  
_output/_ ディレクトリの中身が相当する


## 構成

### 自動生成の成果物
```
output
├─ cpp          // C++ の成果物
├─ oc           // Objective-C の成果物
├─ UnitTest_mm  // Objective-C の単体テストの成果物
└─ test         // 自動生成自体のテスト成果物
```

### 自動生成のデータベースとテンプレート、スクリプトライブラリ
```
src
├─ create_definition.py // Jinja2を使って自動生成を行うモジュール
├─ database             // 自動生成のリソースファイルが入っている  
│   ├─ element         // element のリソースが入っている  
│   └─ element_set     // element セットのリソースが入っている  
└─ template
```

## 開発

### 事前知識
本章では Jinja2 を利用するために独自実装したデータベースファイルの構成や template 内で利用できる変数について説明する。
template の記述方法などの Jinja2 の使い方に関する情報は、公式サイトなどを参照すること。

また本章は事前に https://dev.infohub.cc/jinja2/ を読むことで理解しやすい。
この解説サイトで使われている「テンプレートファイル」「設定ファイル」「コード生成用プログラム」の用語は BFElement では以下に対応している。

- テンプレートファイル : _template/_ 内のファイル
- 設定ファイル : _database/_ 内の ini ファイル
- コード生成プログラム : main.py と create_definition.py スクリプト


### データベースファイルの種類

#### element/\*.ini ファイル
これらの ini ファイルは、主に template 内で１つの変数とその定義を記述するための情報を持っており、スクリプト内では element 構造体として扱われる。ファイル名は element に読み込まれないため任意に設定してよい。
ここの ini ファイルで記述できる属性（element が持つ属性）は以下：

* key : element の名前 \*
* type : element のプログラム上の型 \*
* values : element のtypeがenumの場合の取りうる値
* section : element の種類分け ( 補助的属性 )
* nullname : 無効な値が入ったの時の名前
* exif : 補助情報

(\* がつく属性は必須項目。)

type には次の値が設定できる。
```
enum, int, float, bool, string, object, struct, uint8
```

**例）ini ファイルを記載する**
```
[image]             # <- section
key: ImageHalftone  # <- key
exif: hoge          # <- key
# type( enum, int, float, bool, string )
type: enum          # <- type
values:             # <- values
    SimpleThreshold
    Dither
    ErrorDiffusion
```

**例）ini ファイルの情報を template に展開する**
初期値 `1` の `int num1` をメンバーに持つ `Sample1` クラスを作成することを考える。
そのために、次の ini ファイルと template を作成する。
```
// num1.ini

[Number]
key: num1
exif: 1
type: int
```

```
// Sample1.template
// 実際には別の変数から element を得る必要があるがここでは割愛

class Sample1 {
    {{ element.type }} {{ element.key }};
    init() {
        {{ element.key }} = {{ element.exif }};
    }
}
```

これらの ini と template から生成される結果は次のようになる。
```
class Sample1 {
    int num1;
    init() {
        num1 = 1;
    }
}
```

#### element_set/\*.ini ファイル
これらの ini ファイルは、主に template 内で element 集合を表すための情報を持っており、スクリプト内では element_set 構造体として扱われる。ファイル名は element_set に読み込まれないため任意に設定してよい。
ここの ini ファイルで記述できる属性（element_set が持つ属性）は以下：

* meta : element_set の名前 \*
* keys : どの element の集合なのかを表す \*
* elements : element 構造体の配列 \*
* section : element セットの種類分け ( 補助的属性 ) \*
* nullname : 無効な値が入ったの時の名前

(\* がつく属性は必須項目。)

**例）ini ファイルを記載する**
```
[model_spec_legacy]     # <- section
meta: ModelSpecLegacy   # <- meta
keys:                   # <- keys
    ModelMajor
    ModelInterface[]
...
    ModelSpecLegacyPrinterSettingCategoryBluetooth{ModelInterface}[]
...
```

**例）ini ファイルの情報を template に展開する**
初期値 `1` の `int num1` と初期値 `2` の `int num2` をメンバーに持つ `Sample2` クラスを作成することを考える。
そのために、次の ini ファイルと template を作成する。
```
// element/num1.ini

[Number]
key: num1
exif: 1
type: int
```

```
// element/num2.ini

[Number]
key: num2
exif: 2
type: int
```

```
// element_set/nums.ini

[Numbers]
meta: nums
keys:
    num1
    num2
```

```
// Sample2.template
// 実際には別の変数から element_set を得る必要があるがここでは割愛

class Sample2 {
    {% for element in element_set %}
    {{ element.type }} {{ element.key }};
    {% endfor %}
    init() {
        {% for element in element_set %}
        {{ element.key }} = {{ element.exif }};
        {% endfor %}
    }
}
```

これらの ini と template から生成される結果は次のようになる。
    ```
class Sample {
    int num1;
    int num2;
    init() {
        num1 = 1;
        num2 = 2;
    }
}
```

#### element_set 内の特殊なkey

通常、key は以下のように記述する。
```
keys:
    ModelMajor
    ModelSpecLegacyBatteryCommandType
```

これに加え、プリンターのスペック情報などを表現するために以下のような形式を追加している。

##### 配列 element

以下のように、key の配列を定義できる。 ( class ArrayOfElement: )
key の配列は element と互換性があり型 (type) は array になる。

```
keys:
    ModelInterface[]
```

element 配列の属性
* element : 参照している element のオブジェクト ( 上の例では ModelInterface オブジェクト )
* key : element の名前 ( 上の例では ModelInterface )
* type : 'array'

##### 配列の連想配列 element
以下のように、key の配列の連想配列を定義できる。 ( class DictionaryOfArrayOfElement: )
key の配列の連想配列は element と互換性があり型 (type) は dict_of_array になる

```
keys:
    ModelSpecLegacyPrinterSettingCategoryBluetooth{ModelInterface}[]
```

DictionaryOfArrayOfElementの属性
* key_element : 先頭の element ( 上の例では ModelSpecLegacyPrinterSettingCategoryBluetooth オブジェクト )
* extra_key_element : 括弧の中の element ( 上の例では ModelInterface オブジェクト )
* key : key_element の名前 ( 上の例ではModelInterface )
* type : 'dict_of_array'

これがプログラム上で展開されると以下のようになる。
```
{ ModelInterface, ModelSpecLegacyPrinterSettingCategoryBluetooth[] }
```
