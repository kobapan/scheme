;; -*-mode: gauche-mode; tab-width: 4;-*- .
;;
;; Information: <launcher.scm>
;; Last Modified: <2015/05/17 14:28:17>
;; Auther: <kobapan>
;;

;; command launcher written by gauche-gtk
;; 

;; TODO
;; gtk-entry-completion-set-match-func

(use gtk)
(use file.util) ; expand-path
(use gauche.process) ; run-process

(define *cache* #f)

(define-macro (set? x y)
  `(if (not ,x)
       (begin (set! ,x ,y) ,x)
       ,x))

(define (find pred lis)
  (cond [(null? lis) #f]
        [(pred (car lis)) (car lis)]
        [else (find pred (cdr lis))]))

(define (find-exec path)
  (call-with-input-file path find-exec*))

(define (find-exec* p)
  (let1 line (read-line p)
    (cond [(eof-object? line) #f]
          [(#/^Exec=(\/([^\/]+\/)*)?([^\/\s]*)\s?/ line) => (cut <> 3)]
          [else (find-exec* p)])))

(define (cache . args)
  (let ((cache-file (expand-path "~/.launcher"))
        (commands-list ($ delete #f
                          $ glob-fold (list "/usr/share/applications/*"
                                            (expand-path "~/.local/share/applications/*")
                                            "/usr/local/share/applications/*")
                          (^(a b) (cons (find-exec a) b))
                          '())))
    (if [null? args]
        [set? *cache*
              (call-with-input-file cache-file
                (^(p) (let1 lis (read p) (if (eof-object? lis) commands-list lis))))]
        [let1 commands
            ($ delete-duplicates
               $ cons (car args)
               $ append (cache)
               $ delete #f commands-list)
          (call-with-output-file cache-file (cut write commands <>))])))

(define (match-func completion key iter)
  (let* ((model (gtk-entry-completion-get-model completion))
         (text (gtk-tree-model-get-value model iter)))
    (string-scan text key)))

(define (create-completion-widget)
  (let ((completion (gtk-entry-completion-new)) ; エントリ補完ウィジェットの作成
        (model (gtk-list-store-new <string>))) ; モデルの作成
    (gtk-entry-completion-set-model completion model) ; 作成したモデルを登録
    (gtk-entry-completion-set-text-column completion 0)
;    (gtk-entry-completion-set-match-func completion match-func) ; FIXME Gauche-gtk にこのAPIがない！
    (gtk-entry-completion-set-inline-completion completion #t) ; 一致した部分を自動的に流し込む
    (map
     (^(c) (let1 iter (gtk-list-store-append model)
            (gtk-list-store-set-value model iter 0 c))) ; 補完用の文字列を登録
     (cache))
    completion))

(define (delete_event window) ; FIXME
  ;;(gtk-widget-destroy window))
  ;;(gtk-widget-hide-on-delete window))
  ;;(gtk-widget-hide window))
  ;;(gdk-flush))
  ;;(gtk-widget-hide window)) 
  (gtk-window-iconify window)
  #t)
  

(define (main args)
  (gtk-init args)
  (let1 window (gtk-window-new GTK_WINDOW_TOPLEVEL)
    (gtk-window-set-position window GTK_WIN_POS_CENTER) ; ウィンドウを画面の中央に配置
    (gtk-widget-set-size-request window 200 50)
    (gtk-window-set-title window "Gauche Launcher")
    (g-signal-connect window "destroy" (lambda _ (gtk-main-quit)))
    (g-signal-connect window "delete_event"
                      (lambda _ (delete_event window)))
    (g-signal-connect window "key_press_event"
                      (^(window event)
                              (let1 key (ref event 'keyval)
                                (cond 
                                 ((and (= (ref event 'state) GDK_MOD1_MASK) (= key 49)) ; Alt + 1
                                  (gtk-widget-show window)) ; FIXME
                                 ((= key 65307) ; ESCAPEキー. (char->integer #\escape) の数値とは違う
                                  (delete_event window))
                                 (else #f)))))
      (let ((entry (gtk-entry-new))
            (completion (create-completion-widget)))
        (gtk-entry-set-max-length entry 50)
        (gtk-container-add window entry)
        (gtk-entry-set-completion entry completion)
        (g-signal-connect entry "activate" ; ENTERでコマンドを非同期実行 
                          (^(entry)
                            (let* ((c (gtk-entry-get-text entry))
                                   (c* (find (^(s) (equal? 0 (string-scan s c))) (cache)))) ; 最初に先頭一致するコマンド
                              (run-process (list c*))
                              (cache c*)
                              (delete_event window))))
        (gtk-widget-show-all window)))
  (gtk-main)
  0)


