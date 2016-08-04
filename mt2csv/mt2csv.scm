#!/usr/bin/env gosh
;----------------
; movableTypeからエクスポートしたブログのデータを
; csv形式に変換する
;----------------

(use util.match)

(define %sanitize
  (lambda (in)
    (regexp-replace-all "\"" in "'") ))

(define on?
  (let1 flag #f
    (lambda args
      (cond ((null? args) flag)
            (else (set! flag (car args))) ))))

(define %make-entry
  (lambda (body-on?)
    (let1 line (read-line)
      (unless (eof-object? line)
        (let1 entry (%sanitize line) 
          (cond 
           ((string-scan entry "TITLE: " 'after) => (cut format #t "\"~a\"\," <>))
           ((string-scan entry "PRIMARY CATEGORY: ") #f)
           ((string-scan entry "CATEGORY: " 'after) => (cut format #t "\"~a\"\," <>))
           ((string-scan entry "DATE: " 'after) => (cut format #t "\"~a\"\," <>))
           ((string-scan entry "BODY:") (display "\"") (body-on? #t))
           ((string-scan entry "-----") (when (body-on?) (body-on? #f)))
           ((string-scan entry "--------") ; end of 1 post
            (display "\"")
            (newline) )
           ((body-on?) (print entry))
           (else #f) )
          (%make-entry body-on?) )))))

(define main
  (lambda (args)
    (match args
      ((_ ifile ofile)
       (with-output-to-file ofile
         (lambda () (with-input-from-file ifile
                      (lambda () (%make-entry on?)) ))))
      (else
       (print #`"Usage: ,(car args) <ifile> <ofile>\n")
       (exit 0) ))))

