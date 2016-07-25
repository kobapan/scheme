# htmlprag-0.20.scm

[htmlprag.rkt (htmlprag-0.20)](http://planet.racket-lang.org/package-source/neil/htmlprag.plt/1/7/htmlprag.rkt) code patch to be used in scheme.

This patch file was made by the command "diff -urN htmlprag.rkt htmlprag.scm > scm.patch".

Tested with Gauche 0.9.4

# usage

>$ ls

>htmlprag.rkt  scm.patch

>$ patch -p0 < scm.patch

>patching file 'htmlprag.rkt'

>$ mv htmlprag.rkt htmlprag.scm

