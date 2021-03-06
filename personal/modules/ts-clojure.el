(prelude-require-packages '(inf-clojure))

;; kibit
;; Teach compile the syntax of the kibit output
(require 'compile)
(add-to-list 'compilation-error-regexp-alist-alist
             '(kibit "At \\([^:]+\\):\\([[:digit:]]+\\):" 1 2 nil 0))
(add-to-list 'compilation-error-regexp-alist 'kibit)

;; A convenient command to run "lein kibit" in the project to which
;; the current emacs buffer belongs to.
(defun kibit ()
  "Run kibit on the current project.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile "lein kibit"))

(defun kibit-current-file ()
  "Run kibit on the current file.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile (concat "lein kibit " buffer-file-name)))

;; from https://github.com/eigenhombre/emacs-config/blob/master/org/init.org
(defun jj-cider-eval-and-get-value (v)
  (let ((nrepl-sync-request-timeout nil))
    (nrepl-dict-get (nrepl-sync-request:eval v) "value")))

(defun jj-cider-interactive-eval-print (form)
  "Evaluate the given FORM and print value in current buffer."
  (let ((buffer (current-buffer)))
    (cider-eval form
                (cider-eval-print-handler buffer)
                (cider-current-ns))))

(defun jj-cider-move-forward-and-eval ()
  (interactive)
  (paredit-forward)
  (cider-eval-last-sexp))

(defun jj-cider-eval-last-sexp-and-append ()
  "Evaluate the expression preceding point and append result."
  (interactive)
  (let ((last-sexp (cider-last-sexp)))
    ;; we have to be sure the evaluation won't result in an error
    (jj-cider-eval-and-get-value last-sexp)
    (with-current-buffer (current-buffer)
      (insert ";;=>\n"))
    (jj-cider-interactive-eval-print last-sexp)))


(defun jj-cider-format-with-out-str-pprint-eval (form)
  "Return a string of Clojure code that will return pretty-printed FORM."
  (format "(clojure.core/let [x %s] (with-out-str (clojure.pprint/pprint x)))"
          form))


(defun jj-cider-eval-last-sexp-and-pprint-append ()
  "Evaluate the expression preceding point and append pretty-printed result."
  (interactive)
  (let ((last-sexp (cider-last-sexp)))
    ;; we have to be sure the evaluation won't result in an error
    (with-current-buffer (current-buffer)
      (insert (concat "\n;;=>\n"
                      (read
                       (jj-cider-eval-and-get-value
                        (jj-cider-format-with-out-str-pprint-eval last-sexp))))))))


(add-hook 'after-init-hook 'global-company-mode)

;; indentation
(require 'clojure-mode)
(dolist
    (macro
     '(fresh conde run run* for-all defroutes describe it transact! build-all
             a
             abbr
             address
             area
             article
             aside
             audio
             b
             base
             bdi
             bdo
             big
             blockquote
             body
             br
             button
             canvas
             caption
             cite
             code
             col
             colgroup
             data
             datalist
             dd
             del
             dfn
             div
             dl
             dt
             em
             embed
             fieldset
             figcaption
             figure
             footer
             form
             h1
             h2
             h3
             h4
             h5
             h6
             head
             header
             hr
             html
             i
             iframe
             img
             ins
             kbd
             keygen
             label
             legend
             li
             link
             main
             map
             mark
             menu
             menuitem
             meta
             meter
             nav
             noscript
             object
             ol
             optgroup
             output
             p
             param
             pre
             progress
             q
             rp
             rt
             ruby
             s
             samp
             script
             section
             select
             small
             source
             span
             strong
             style
             sub
             summary
             sup
             table
             tbody
             td
             tfoot
             th
             thead
             time
             title
             tr
             track
             u
             ul
             var
             video
             wbr

             ;; svg
             circle
             ellipse
             g
             line
             path
             polyline
             rect
             svg
             text
             defs
             linearGradient
             polygon
             radialGradient
             stop
             tspan
             ;; end of om
             ;; compojure
             defroutes
             GET
             POST
             PUT
             DELETE
             HEAD
             ANY
             context
             fact
             defapi
             swagger-
             swagger-
             swaggered
             GET*
             POST*
             PUT*
             DELETE*
             HEAD*
             ANY*
             cond->

             apply
             match

             ;; om
             render
             query
             params
             ident
             reconciler
             add-root!

             ;; utils
             for-loop
             ))
  (put-clojure-indent macro 'defun))

;; FIXME: make clojure-mode only
(add-hook 'clojure-mode-hook
          (lambda ()
            (global-set-key "\C-o1" (lambda ()
                                      (interactive)
                                      (let ((bname (buffer-file-name)))
                                        (cider-load-file bname))))))
;; (eval-after-load 'clojure-mode '(progn
;;                                   (define-key clojure-mode-map (kbd "M-i") 'helm-swoop)))

(defun clojure-match-next-def ()
  "Scans the buffer backwards for the next \"top-level\" definition.
Called by `imenu--generic-function'."
  (when (re-search-backward "^([s/]*def\\sw*" nil t)
    (save-excursion
      (let (found?
            (start (point)))
        (down-list)
        (forward-sexp)
        (while (not found?)
          (forward-sexp)
          (or (if (char-equal ?[ (char-after (point)))
                              (backward-sexp))
                  (if (char-equal ?) (char-after (point)))
                (backward-sexp)))
          (destructuring-bind (def-beg . def-end) (bounds-of-thing-at-point 'sexp)
            (if (char-equal ?^ (char-after def-beg))
                (progn (forward-sexp) (backward-sexp))
              (setq found? t)
              (set-match-data (list def-beg def-end)))))
        (goto-char start)))))

(add-hook 'cider-mode-hook #'eldoc-mode)

;; (add-hook 'cider-mode-hook
;;           '(lambda () (add-hook 'after-save-hook
;;                                 '(lambda ()
;;                                    (if (and (boundp 'cider-mode) cider-mode)
;;                                        (cider-refresh))))))


(setq enable-local-variables nil)

(setq nrepl-log-messages t)

;; (setf inf-clojure-lein-cmd '("localhost" . 5555))
(defun jp-around-cider-find-var (fn &rest args)
  (let* ((sess (sesman-current-session 'CIDER))
         (orig-buf (current-buffer))
         (result (apply fn args)))
    (unless (eq orig-buf (current-buffer))
      (sesman-link-with-buffer (current-buffer) sess))
    result))

;; Workaround for https://github.com/clojure-emacs/cider/issues/2408#issuecomment-413768401
(advice-add #'cider--find-var :around #'jp-around-cider-find-var)

(setq cider-clojure-cli-global-options "-A:dev")

(defun cljfmt ()
  (when (or (eq major-mode 'clojure-mode)
            (eq major-mode 'clojurescript-mode))
    (shell-command-to-string (format "cljfmt %s" buffer-file-name))
    (revert-buffer :ignore-auto :noconfirm)))

;; (add-hook 'after-save-hook #'cljfmt)
;; (remove-hook 'after-save-hook #'cljfmt)

(provide 'ts-clojure)
