#!/usr/bin/env gosh

;; flickcurlのラッパー
;; Flickcurl: C library for the Flickr API <http://librdf.org/flickcurl/>

;; 引数にflickrIDとファイル名を取り
;; ファイル内に1行ずつ記述された画像ファイルを
;; flickcurlに渡して、flickrにアップロードし
;; 得られたphotoIDとflickrIDをflickrdfに渡して、画像のURLを取得し
;; 標準出力に返す
;;
;; regexp <http://practical-scheme.net/gauche/man/gauche-refj/Zheng-Gui-Biao-Xian-.html#index-regexp-1>
;; rxmatch-if <http://practical-scheme.net/gauche/man/gauche-refj/Zheng-Gui-Biao-Xian-.html#index-rxmatch_002dif>
;; コマンドの出力を取る <https://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A%E3%83%86%E3%82%AD%E3%82%B9%E3%83%88%E5%87%A6%E7%90%86#H-mocs7o>

(use util.match); match
(use gauche.process); process-output->string,process-output->string-list

(define usage
  (lambda (err)
    (when err (print "ERROR: " err))
    (print #"Usage: ~(sys-basename *program-name*) <flickr-id> <infile>

infile's syntax
--------
/path/to/image.(jpg|jpeg|png|gif)[ title]
.
.
.
----
")
    (exit 2) ))

(define main
  (lambda (args)
    (match args
      ((_ user infile)
       (with-input-from-file infile (lambda () (%do user) )))
      (else
       (usage "args error.") ))
    0 ))

;; 現在の入力ポートから1行ずつ読み取り
;; 画像ファイルパスとタイトルを
;; %uploadに渡して帰ったIDを%geturlに渡して
;; 自身を呼び出す
(define %do
  (lambda (uid)
    (let1 line (read-line)
      (unless (eof-object? line)
        (rxmatch-if (#/([^ ]+\.(jpg|jpeg|png|gif))( ([^ ]+))?/ line)
          (#f file #f #f title)
          (%geturl uid (%upload file title))
         (usage "file syntax error.") )
        (%do uid) ))))

;; UID と ID で flickrdf を呼び出して
;; flickr画像のurlを取得して
;; "URL[photoURL]\n"を現在の標準出力に印字
(define %geturl
  (lambda (uid id)
    (format #t "URL[~a]\n"
     (process-output->string
               #"flickrdf http://www.flickr.com/photos/~|uid|/~|id|/\
 | grep '\"Medium\"' | grep -o 'https://.*jpg'") )))

;; img-path と title で flickcurl upload を呼び出して
;; "ID[photoID] TITLE[photoTITLE] "を現在の標準出力に印字
;; IDを返す
(define %upload
  (lambda (img-path title)
    (let* ((up-title (if title (format #f "title \"~a\"" title) ""))
           (res (process-output->string-list
                 #"flickcurl upload \"~|img-path|\" ~|up-title| public") )
           (id (rxmatch->string #/: (.+)/ (caddr res) 1)) )
      (format #t "ID[~a] TITLE[~a] " id (if title title ""))
      id )))


