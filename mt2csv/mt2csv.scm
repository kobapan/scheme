#!/usr/bin/env gosh
;----------------
; movableTypeからエクスポートしたブログのデータを
; csv形式に変換する
;----------------

(use util.match)

(define %sanitize
  (lambda (in)
    (regexp-replace-all "\"" in "'") ))

(define %make-entry
  (lambda (iport body?)
    (let1 line (read-line iport)
      (when (not (eof-object? line))
        (let1 entry (%sanitize line) 
          (cond ((string-scan entry "TITLE: " 'after) => (cut format #t "\"~a\"\," <>))
                ((string-scan entry "PRIMARY CATEGORY: ") #f)
                ((string-scan entry "CATEGORY: " 'after) => (cut format #t "\"~a\"\," <>))
                ((string-scan entry "DATE: " 'after) => (cut format #t "\"~a\"\," <>))
                ((string-scan entry "BODY:") (display "\"") (body? #t))
                ((string-scan entry "-----") (when (body?) (body? #f)))
                ((string-scan entry "--------") ; end of 1 post
                 (display "\"")
                 (newline (current-output-port)) )
                ((body?) (print entry))
                (else #f))
          (%make-entry iport body?) )))))

(define %doit
  (lambda (iport)
    (%make-entry iport 
                 (let1 flag #f
                   (lambda args
                     (cond ((pair? args) (set! flag (car args)))
                           (else flag) ))))))


;; クロージャ ← 環境（この場合はlet）の中で手続きを宣言する。静的スコープ
;; (define body?
;;   (let ((flag #f))
;;     (lambda args
;;       (cond ((pair? args) (set! flag (car args)))
;;             (else flag) ))))
;;
;; 下記はよく似ているように思うが、手続きの中でletが呼ばれている。これは手続きの環境にはならない。
;; (define body?
;;   (lambda args
;;     (let ((flag #f))
;;       (cond ((pair? args) (set! flag (car args)))
;;             (else flag) ))))

(define main
  (lambda (args)
    (match args
      ((_ ifile ofile)
       (with-output-to-file ofile
         (lambda () (call-with-input-file ifile %doit))) )
      (else
       (print #`"Usage: ,(car args) <ifile> <ofile>\n")
       (exit 0) ))))
