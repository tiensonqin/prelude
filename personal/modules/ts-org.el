;; ;; asciidoc export
;; (add-to-list 'load-path "~/.emacs.d/personal/vendor/org-asciidoc")
;; (require 'ox-asciidoc)

;; (add-to-list 'load-path "~/.emacs.d/personal/vendor/adoc-mode")
;; (require 'adoc-mode)

(add-to-list 'load-path "~/.emacs.d/personal/vendor/org-present")
(require 'org-present)


;; Set to the location of your Org files on your local system
(setq org-directory "~/notes")
;; (setq org-todo-keywords '((sequence "TODO(t)" "DOING(D)" "|" "WAITING(w)" "CANCELLED(c)" "DONE(d)")))

(setq org-todo-keywords
      '((sequence "NOW(n!)" "LATER(l!)" "|" "DONE(d!)" "CANCELED(c@)")))
(setq org-log-done t)


(add-hook 'org-mode-hook
          (lambda ()
            (local-set-key (kbd "C-h n") 'org-insert-heading-after-current)))


(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/notes/tasks.org" "Tasks")
         "* NOW %?\n  %i\n  %a")
        ))

(setq org-agenda-files (list "~/notes/tasks.org"))

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
(org-babel-do-load-languages 'org-babel-load-languages '((python . t) (C . t) (shell . t) (ruby . t) (js . t) (clojure . t) (ocaml . t) (haskell . t)))
;; (org-babel-do-load-languages 'org-babel-load-languages '((sh . t) (python . t) (C . t) (ruby . t) (js . t) (clojure . t) (ocaml . t) (haskell . t)))
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))


(require 'cl)   ; for delete*
(setq org-emphasis-alist
      (cons '("+" '(:strike-through t :foreground "gray"))
            (delete* "+" org-emphasis-alist :key 'car :test 'equal)))

;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (plantuml . t)))

(setq org-plantuml-jar-path
      (expand-file-name "/opt/plantuml/plantuml.jar"))

(org-babel-do-load-languages
 'org-babel-load-languages
   '((dot . t)))

(defun my/log-todo-creation-date (&rest ignore)
  "Log TODO creation time in the property drawer under the key 'CREATED'."
  (when (and (org-get-todo-state)
             (not (org-entry-get nil "CREATED")))
    (org-entry-put nil "CREATED" (format-time-string (cdr org-time-stamp-formats)))))

(advice-add 'org-insert-todo-heading :after #'my/log-todo-creation-date)
(advice-add 'org-insert-todo-heading-respect-content :after #'my/log-todo-creation-date)
(advice-add 'org-insert-todo-subheading :after #'my/log-todo-creation-date)

;; org roam
(setq org-roam-directory "~/codes/projects/org-roam-example")

;; (add-hook 'after-init-hook 'org-roam-mode)

(provide 'ts-org)
