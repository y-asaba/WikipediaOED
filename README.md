# WikipediaOED
Wikipediaのデータを使ってMicrosoft Office IME2010 オープン拡張辞書を作るスクリプトです。

## 使い方
* BuildDictionary.ps1とwiki2oed.xslをダウンロードします。
* WikipediaのXMLファイルを以下の場所からダウンロードします。jawiki-latest-abstract.xmlを使います。
** http://download.wikimedia.org/jawiki/latest/
** （注）WikipediaのデータはCreative Commons Attribution-ShareAlike licenseに従って配布されています。詳細はリンク先をご覧ください。
* コマンドプロンプトを起動し、ダウンロードしたフォルダへ移動し、以下のコマンドを実行します。

    powershell -File BuildDictionary.ps1

少し時間がかかりますが、完了するとWikipediaDictionary.dctxが作成されます。これをダブルクリックしてインストールしてください。

## オープン拡張辞書フォーマット

オープン拡張辞書のXML形式のドキュメントはダウンロード可能です。以下のURLにアクセスし、上から2番目の” PackageForDLC\Open Extended Dictionary Format-Japanese.xps“をダウンロードしてください。

http://www.microsoft.com/downloads/details.aspx?FamilyID=f138dcd4-edb3-4319-bb69-82784e3ea52f&DisplayLang=ja

## ライセンス
LICENSE を参照してください。

## 問い合わせ先
コメントや要望などがありましたら、以下のアドレスへメールしてください。
ysyk.asaba _at_ gmail _dot_ com
