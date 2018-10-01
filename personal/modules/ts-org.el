;; ;; asciidoc export
;; (add-to-list 'load-path "~/.emacs.d/personal/vendor/org-asciidoc")
;; (require 'ox-asciidoc)

;; (add-to-list 'load-path "~/.emacs.d/personal/vendor/adoc-mode")
;; (require 'adoc-mode)

(add-to-list 'load-path "~/.emacs.d/personal/vendor/org-present")
(require 'org-present)


;; Set to the location of your Org files on your local system
(setq org-directory "~/Sync/orgs")

(setq org-todo-keywords
      '((sequence "TODO(!)" "DOING(!)" "DONE")))


(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-h n") 'org-insert-heading-after-current)))


(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Sync/orgs/tasks.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("h" "Reading" entry (file+headline "~/Sync/orgs/notes/read.org" "Read")
         "* TODO %?\n  %i\n  %a")))

(setq org-agenda-files (list "~/Sync/orgs/tasks.org"
                             "~/Sync/orgs/notes/read.org"))

(setq org-log-done t)

(global-set-key "\C-cc" 'org-capture)

(setq org-enforce-todo-dependencies t)
(setq org-enforce-todo-checkbox-dependencies t)

(require 'ox-org)
(require 'ox-beamer)
(require 'ox-latex)
(setq org-export-allow-bind-keywords t)
(setq org-latex-listings 'minted)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(org-babel-do-load-languages 'org-babel-load-languages '((sh . t) (python . t) (C . t) (ruby . t) (js . t) (clojure . t) (ocaml . t) (haskell . t)))
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))


(provide 'ts-org)
