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
  (lambda (program-name)
      (format (current-error-port)
          "Usage: ~a <user> <infile>
infile
--------
image-path[ title]
.
.
.
----
" program-name)
      (exit 2)))


;; id で flickrdf を呼び出して
;; flickr画像のurlを取得して
;; TITLE[~a] ID[~a] URL[~a]\nを返す
(define %geturl
  (lambda (uid title id)
    (format #t "TITLE[~a] URL[~a]\n"
     title
     (process-output->string
               #"flickrdf http://www.flickr.com/photos/~|uid|/~|id|/\
 | grep '\"Medium\"' | grep -o 'https://.*jpg'") )))

;; img-path と title で  flickcurl upload を呼び出して
;; photoIDを返す
(define %upload
  (lambda (img-path title)
    (let* ((res (process-output->string-list
                 #"flickcurl upload \"~|img-path|\" title \"~|title|\" public"))
           (id (rxmatch->string #/: (.+)/ (caddr res) 1)))
      (format #t "ID[~a] " id)
      id )))

;; 現在の入力ポートから1行ずつ読み取り
;; 画像ファイルパスとタイトルを
;; %uploadに渡して帰ったIDを
;; %geturlに渡して
;; 自身を呼び出す
(define %do
  (lambda (uid)
    (let1 line (read-line)
      (unless (eof-object? line)
        (rxmatch-cond
         ((#/([^ ]+\.[jpg|png|gif]+) ([^ ]+)/ line)
          (#f file title)
          (%geturl uid title (%upload file title)) )
         ((#/([^ ]+\.[jpg|png|gif]+)/ line)
          (#f file)
          (let1 base-name (sys-basename file)
            (%geturl uid base-name (%upload file base-name)) )))
        (%do uid) ))))

(define main
  (lambda (args)
    (match args
      ((program-name user infile)
       (with-input-from-file infile
                      (lambda () (%do user) )))
      (else
       (usage program-name) ))
    0 ))
