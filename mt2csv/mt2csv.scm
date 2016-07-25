#!/usr/bin/env gosh
;----------------
; movableTypeからエクスポートしたブログのデータを
; csv形式に変換する
;----------------

(use util.match)

(define %body-flag #f)

(define %sanitize
  (lambda (in)
    (regexp-replace-all "\"" in "'") ))

(define %make-entry
  (lambda (line)
    (let1 entry (%sanitize line) 
      (cond ((string-scan entry "TITLE: " 'after) => (cut format #t "\"~a\"\," <>))
            ((string-scan entry "PRIMARY CATEGORY: ") #f)
            ((string-scan entry "CATEGORY: " 'after) => (cut format #t "\"~a\"\," <>))
            ((string-scan entry "DATE: " 'after) => (cut format #t "\"~a\"\," <>))
            ((string-scan entry "BODY:") (set! %body-flag #t) (display "\""))
            ((string-scan entry "-----") (when %body-flag (set! %body-flag #f)))
            ((string-scan entry "--------") ; end of 1 post
             (display "\"")
             (newline (current-output-port)) )
            (%body-flag (print entry))
          (else #f)) )))

(define %doit
  (lambda (iport)
    (port-for-each %make-entry (lambda () (read-line iport))) ))

(define main
  (lambda (args)
    (match args
      ((_ ifile ofile)
       (with-output-to-file ofile
         (lambda () (call-with-input-file ifile %doit))) )
      (else
       (print #`"Usage: ,(car args) <ifile> <ofile>\n")
       (exit 0) ))))
