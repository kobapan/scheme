# htmlprag.scm

HtmlPrag provides permissive HTML parsing and emitting capability to Scheme programs.  The parser is useful for software agent extraction of information from Web pages, for programmatically transforming HTML files, and for implementing interactive Web browsers.  HtmlPrag emits SHTML, which is an encoding of HTML in [SXML](http://okmij.org/ftp/Scheme/SXML.html), so that conventional HTML may be processed with XML tools such as SXPath.

This is based on [htmlprag.rkt (htmlprag-0.20)](http://planet.racket-lang.org/package-source/neil/htmlprag.plt/1/7/htmlprag.rkt) to be used in Gauche.


## Tokenizing

### (make-html-tokenizer in normalized?)
Constructs an HTML tokenizer procedure on input port in. If boolean normalized? is true, then tokens will be in a format conducive to use with a parser emitting normalized SXML. Each call to the resulting procedure yields a successive token from the input. When the tokens have been exhausted, the procedure returns the null list. 

    (define input (open-input-string "<a href=\"foo\">bar</a>"))
    (define next  (make-html-tokenizer input #f))
    (next) ==> (a (@ (href "foo")))
    (next) ==> "bar"
    (next) ==> (*END* a)
    (next) ==> ()
    (next) ==> ()

### (tokenize-html in normalized?)
Returns a list of tokens from input port in, normalizing according to boolean normalized?. This is probably most useful as a debugging convenience.

    (tokenize-html (open-input-string "<a href=\"foo\">bar</a>") #f)
    ==>
    ((a (@ (href "foo"))) "bar" (*END* a))
    
## Parsing

### (html->sxml input)
### (html->shtml input)
Permissively parse HTML from input, which is either an input port or a string, and emit an SHTML equivalent or approximation.

    (html->shtml
     "<html><head><title></title><title>whatever</title></head><body>\n<a href=\"url\">link</a><p align=center><ul compact style=\"aa\">\n<p>BLah<!-- comment <comment> --> <i> italic <b> bold <tt> ened</i>\nstill &lt; bold </b></body><P> But not done yet...")
    ==>
    (*TOP* (html (head (title) (title "whatever"))
      (body "\n"
        (a (@ (href "url")) "link")
          (p (@ (align "center"))
          (ul (@ (compact) (style "aa")) "\n"))
          (p "BLah"
             (*COMMENT* " comment <comment> ")
             " "
             (i " italic " (b " bold " (tt " ened")))
             "\n"
             "still < bold "))
           (p " But not done yet...")))
           
## Emitting HTML
### (write-shtml-as-html shtml out foreign-filter)
Writes a conventional HTML transliteration of the SHTML shtml to output port out. If out is not specified, the default is the current output port. HTML elements of types that are always empty are written using HTML4-compatible XHTML tag syntax.

If foreign-filter is specified, it is a procedure of two argument that is applied to any non-SHTML (“foreign”) object encountered in shtml, and should yield SHTML. The first argument is the object, and the second argument is a boolean for whether or not the object is part of an attribute value.

No inter-tag whitespace or line breaks not explicit in shtml is emitted. The shtml should normally include a newline at the end of the document.

    (write-shtml-as-html
      '((html (head (title "My Title"))
        (body (@ (bgcolor "white"))
              (h1 "My Heading")
              (p "This is a paragraph.")
              (p "This is another paragraph.")))))
    ==>
    <html><head><title>My Title</title></head><body bgcolor="white"><h1>My Heading</h1><p>This is a paragraph.</p><p>This is another paragraph.</p></body></html>
    
### (shtml->html shtml)
Yields an HTML encoding of SHTML shtml as a string

  (shtml->html
    '((html (head (title "My Title"))
            (body (@ (bgcolor "white"))
                  (h1 "My Heading")
                  (p "This is a paragraph.")
                  (p "This is another paragraph.")))))
    ==>
   "<html><head><title>My Title</title></head><body bgcolor=\"white\"><h1>My Heading</h1><p>This is a paragraph.</p><p>This is another paragraph.</p></body></html>"
