;;;
;;; Test htmlprag
;;;

(use gauche.test)

(test-start "htmlprag")
(use htmlprag)
(test-module 'htmlprag)

(define input (open-input-string "<a href=\"foo\">bar</a>"))
(define next (make-html-tokenizer input #f))

(test* "make-html-tokenizer"
       `(a (|@| (href "foo")))
       (next))

(test* "tokenize-html"
       `((a (|@| (href "foo"))) "bar" (*END* a))
       (tokenize-html (open-input-string "<a href=\"foo\">bar</a>") #f))

(test* "html->shtml"
       `(*TOP* (html (head (title) (title "whatever")) (body "\n" (a (|@| (href "url")) "link") (p (|@| (align "center")) (ul (|@| (compact) (style "aa")) "\n")) (p "BLah" (*COMMENT* " comment <comment> ") " " (i " italic " (b " bold " (tt " ened"))) "\n" "still < bold ")) (p " But not done yet...")))
       (html->shtml
        "<html><head><title></title><title>whatever</title></head><body>\n<a href=\"url\">link</a><p align=center><ul compact style=\"aa\">\n<p>BLah<!-- comment <comment> --> <i> italic <b> bold <tt> ened</i>\nstill &lt; bold </b></body><P> But not done yet..."))

(test* "shtml->html"
       "<html><head><title>My Title</title></head><body bgcolor=\"white\"><h1>My Heading</h1><p>This is a paragraph.</p><p>This is another paragraph.</p></body></html>"
       (shtml->html
  '((html (head (title "My Title"))
          (body (@ (bgcolor "white"))
                (h1 "My Heading")
                (p "This is a paragraph.")
                (p "This is another paragraph."))))))

(test-end :exit-on-failure #t)
