#!/usr/bin/env gosh
;----------------
; movableTypeからエクスポートしたブログのデータを
; csv形式に変換する gauche-schemeスクリプト
;
; TODO
; 
;----------------

(use util.match)

(define %sanitize
  (lambda (in)
    (regexp-replace-all "\"" in "'") ))

; make-parameter で同じことができるが、勉強のためにあえて
(define on?
  (lambda ()
    (let1 flag #f
      (lambda args
        (cond ((null? args) flag)
              (else (set! flag (car args))) )))))

(define %make-entry
  (lambda (body? comment?)
    (let1 line (read-line)
      (unless (eof-object? line)
        (let1 entry (%sanitize line) 
          (cond 
           ((string=? entry "COMMENT:") (comment? #t))
           ((string-scan entry "TITLE: " 'after) => (lambda (s) (comment? #f) (format #t "\"~a\"\," s)))
           ((string-scan entry "PRIMARY CATEGORY:") #f)
           ((string-scan entry "CATEGORY: " 'after) => (cut format #t "\"~a\"\," <>))
           ((string-scan entry "DATE: " 'after) => (lambda (s) (unless (comment?) (format #t "\"~a\"\," s))))
           ((string=? entry "BODY:") (display "\"") (body? #t))
           ((string=? entry "-----") (when (body?) (body? #f)))
           ((string=? entry "--------") (display "\"\n") (body? #f)) ; end of 1 post
           ((and (body?) (not (comment?))) (display #`",|entry|<br/ >")) ; content body of a post
           (else #f) )
          (%make-entry body? comment?) )))))

(define main
  (lambda (args)
    (match args
      ((_ ifile ofile)
       (with-output-to-file ofile
         (lambda () (with-input-from-file ifile
                      (lambda () (%make-entry (on?) (on?))) ))))
      (else
       (print #`"Usage: ,(car args) <ifile> <ofile>\n")
       (exit 0) ))))
