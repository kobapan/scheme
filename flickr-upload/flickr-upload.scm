#!/usr/bin/env gosh

;; flickcurlのラッパー
;; Flickcurl: C library for the Flickr API <http://librdf.org/flickcurl/>
;;
;; 1引数にファイル名を取り
;; ファイル内に1行ずつ記述された画像ファイルを
;; flickcurlに渡して、flickrにアップロードし
;; 得られたphotoIDで持って、画像のURLを取得しflickrdf
;; 標準出力に返す
;;
;; regexp <http://practical-scheme.net/gauche/man/gauche-refj/Zheng-Gui-Biao-Xian-.html#index-regexp-1>
;; rxmatch-let <http://practical-scheme.net/gauche/man/gauche-refj/Zheng-Gui-Biao-Xian-.html#index-rxmatch_002dpositions>
;; コマンドの出力を取る <https://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A%E3%83%86%E3%82%AD%E3%82%B9%E3%83%88%E5%87%A6%E7%90%86#H-mocs7o>
;;
;; rxmatch-let や rxmatch-if の使い方がいまいち

(use util.match); match
(use gauche.process); process-output->string,process-output->string-list

(define usage
  (lambda ()
    (print #"Usage: ~(sys-basename *program-name*) <user> <infile>
infile
--------
image-path[ title]
.
.
.
----
")
    (exit 2) ))


;; ID で flickrdf を呼び出して
;; flickr画像のurlを取得して
;; URL[~a]\nを現在の標準出力に印字
(define %geturl
  (lambda (uid id)
    (format #t "URL[~a]\n"
     (process-output->string
               #"flickrdf http://www.flickr.com/photos/~|uid|/~|id|/\
 | grep '\"Medium\"' | grep -o 'https://.*jpg'") )))

;; img-path と title で  flickcurl upload を呼び出して
;; ID[photoID] TITLE[title] を現在の標準出力に印字
;; IDを返す
(define %upload
  (lambda (img-path title)
    (let* ((res (process-output->string-list
                 #"flickcurl upload \"~|img-path|\" title \"~|title|\" public"))
           (id (rxmatch->string #/: (.+)/ (caddr res) 1)))
      (format #t "ID[~a] TITLE[~a] " id title)
      id )))

;; 画像ファイルパスとタイトルを
;; %uploadに渡して帰ったIDを
;; %geturlに渡す
(define %call
  (lambda (uid file title)
    (%geturl uid (%upload file title))))

;; 現在の入力ポートから1行ずつ読み取り
;; UIDと画像ファイルパスとタイトルを
;; %call に渡して
;; 自身を呼び出す
(define %do
  (lambda (uid)
    (let1 line (read-line)
      (unless (eof-object? line)
        (rxmatch-cond
         ((#/([^ ]+\.(jpg|png|gif)) ([^ ]+)/ line)
          (#f file #f title)
          (%call uid file title) )
         ((#/([^ ]+\.(jpg|png|gif))/ line)
          (#f file #f)
          (%call uid file (sys-basename file)) )
         (else (usage)) )
        (%do uid) ))))

(define main
  (lambda (args)
    (match args
      ((_ user infile)
       (with-input-from-file infile
                      (lambda () (%do user) )))
      (else
       (usage) ))
    0 ))
