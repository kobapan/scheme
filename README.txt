■とにかく読む

なんでもλ | http://practical-scheme.net/docs/lambda-j.html
なんでも継続 | http://practical-scheme.net/docs/cont-j.html
なんでも再帰 | http://practical-scheme.net/docs/tailcall-j.html


■カリー化？

(pa$ cons 2) == (cut cons 2 <>) == (lambda (x) (cons 2 x))

'<>'が最後に 来る場合は 'pa$' の方が短いし、いずれにせよGaucheでは両方サポートする ことになるでしょう。

■テスト

Scheme:テストファースト https://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A%E3%83%86%E3%82%B9%E3%83%88%E3%83%95%E3%82%A1%E3%83%BC%E3%82%B9%E3%83%88

GaUnit
http://www.cozmixng.org/~kou/gauche/gaunit
http://www.cozmixng.org/~kou/download/

Gauche で Unit Test - GaUnitを使う - 【はてな】ガットポンポコ http://d.hatena.ne.jp/kobapan/touch/20100203/1265206057


■開発支援

gca.el https://github.com/yinkyweb/dot_files/blob/master/elisp/scheme/gca.el


■ファイル入出力

https://practical-scheme.net/wiliki/wiliki.cgi?kou

call-with-input-file | http://practical-scheme.net/wiliki/wiliki.cgi?ytaki%3A200503-04

https://www.shido.info/lisp/scheme9.html

Scheme:使いたい人のための継続入門 |  http://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A%E4%BD%BF%E3%81%84%E3%81%9F%E3%81%84%E4%BA%BA%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AE%E7%B6%99%E7%B6%9A%E5%85%A5%E9%96%80


■Peg

GaucheのPeg(Parser Expression Grammar)で漢数字の構文解析 | http://uid0130.blogspot.jp/2014/12/gauchepegparser-expression-grammar.html

Rui:ParsingExpressionGrammar | http://practical-scheme.net/wiliki/wiliki2.cgi?Rui%3AParsingExpressionGrammar

Gauche:parser.pegの使い方 | http://practical-scheme.net/wiliki/wiliki2.cgi?Gauche%3Aparser.peg%E3%81%AE%E4%BD%BF%E3%81%84%E6%96%B9


■サンプルプログラム集

独習 Scheme 三週間 Teach Yourself Scheme in Fixnum Days http://www.sampou.org/scheme/t-y-scheme/t-y-scheme-Z-H-1.html

(Scheme と Lisp のプログラミングテクニック) http://www.geocities.co.jp/SiliconValley-PaloAlto/7043/index.html#tech

Gauche:Cookbook | https://practical-scheme.net/wiliki/wiliki.cgi?Gauche%3ACookbook

目次 - Gaucheクックブック | http://d.hatena.ne.jp/rui314/20061219/p1

説明のないとってもシンプルなサンプルプログラム集 | http://simplesandsamples.com/hello.scm.html

M.Hiroi's Home Page / Scheme Progamming | http://www.geocities.jp/m_hiroi/func/scheme.html

ろんりぃ読書会: tag:プログラミングGauche | http://blog.livedoor.jp/mocoh/tag/%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9F%E3%83%B3%E3%82%B0Gauche


■継続

なぜSchemeにはreturnが無いのか | http://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A%E3%81%AA%E3%81%9CScheme%E3%81%AB%E3%81%AFreturn%E3%81%8C%E7%84%A1%E3%81%84%E3%81%AE%E3%81%8B

Scheme:使いたい人のための継続入門 |  http://practical-scheme.net/wiliki/wiliki.cgi?Scheme%3A%E4%BD%BF%E3%81%84%E3%81%9F%E3%81%84%E4%BA%BA%E3%81%AE%E3%81%9F%E3%82%81%E3%81%AE%E7%B6%99%E7%B6%9A%E5%85%A5%E9%96%80

僕のIT革命: 部分継続チュートリアル | http://outer-inside.blogspot.jp/2011/03/blog-post.html

お気楽 Scheme プログラミング入門 | http://www.geocities.jp/m_hiroi/func/abcscm20.html

継続 | http://www.h4.dion.ne.jp/~unkai/scm/scm02.html

Gauche ユーザリファレンス: 9.21 gauche.partcont - 部分継続 | http://practical-scheme.net/gauche/man/gauche-refj_97.html#g_t_00e9_0083_00a8_00e5_0088_0086_00e7_00b6_0099_00e7_00b6_009a


■librarys

scheme-faq-standards | http://community.schemewiki.org/?scheme-faq-standards
