# flickcurlのラッパー

FlickrのコマンドラインAPI、flickcurlが便利なので、複数ファイルを一度にアップロードするためのラッパープログラムを作りました。

# flickcurl
[Flickcurl公式](http://librdf.org/flickcurl/)

事前にflickcurlをインストール＆設定しておく必要があります。  
→ [Flickr/flickcurl-コマンドラインでFlickr](https://www20.atwiki.jp/kobapan/pages/332.html#id_53b77e44)

# 使い方
flickrのユーザ名と、アップロードする画像ファイルのパス名を記述したファイル名を、引数にとります。
アップロードした画像のflickrでのIDと、タイトル、URLを返します。 
> $ flickr-upload.scm FLICKR-USERNAME INFILE  
> ID[NNN] TITLE[name] URL[xxx.jpg]  
> .  
> .  
> .  

## INFILEの構文
1行に一つの画像ファイルを記述します。スペースに続いて画像タイトルを記述します（省略可）。 
> /path/to/image.(jpg|jpeg|png|gif)[ title]  
> .  
> .  
> .

