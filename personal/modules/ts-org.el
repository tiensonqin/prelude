;; asciidoc export
(add-to-list 'load-path "~/.emacs.d/personal/vendor/org-asciidoc")
(require 'ox-asciidoc)

(add-to-list 'load-path "~/.emacs.d/personal/vendor/adoc-mode")
(require 'adoc-mode)

;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/orgs")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/orgs/from-mobile.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/orgs")

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Dropbox/orgs/tasks.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("h" "Hidiffernt Todo" entry (file+headline "~/codes/projects/hidifferent/backend/docs/todo.org" "Tasks")
         "* TODO %?\n  %i\n  %a")
        ("j" "Journal" entry (file+datetree "~/Dropbox/orgs/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ))

(setq org-agenda-files (list "~/Dropbox/orgs/tasks.org"
                             "~/codes/projects/hidifferent/backend/docs/todo.org"))

(setq org-log-done t)

(global-set-key "\C-cc" 'org-capture)

(require 'ox-org)

(provide 'ts-org)
