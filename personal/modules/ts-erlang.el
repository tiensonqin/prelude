(setq edts-man-root "/opt/erlang/18.3")
(setq erlang-root-dir "/opt/erlang/18.3/")
(add-to-list 'exec-path "/opt/erlang/18.3/bin/")
(add-to-list 'load-path "/opt/erlang/edts")
;; (require 'edts-start)

;; distel
;; (add-to-list 'load-path "/usr/local/share/distel/elisp")
;; (require 'distel)
;; (distel-setup)

;; ;; prevent annoying hang-on-compile
;; (defvar inferior-erlang-prompt-timeout t)
;; ;; default node name to emacs@localhost
;; (setq inferior-erlang-machine-options '("-sname" "emacs"))
;; ;; tell distel to default to that node
;; (setq erl-nodename-cache
;;       (make-symbol
;;        (concat
;;         "emacs@"
;;         ;; Mac OS X uses "name.local" instead of "name", this should work
;;         ;; pretty much anywhere without having to muck with NetInfo
;;         ;; ... but I only tested it on Mac OS X.
;;         (car (split-string (shell-command-to-string "hostname"))))))

(defun my-erlang-mode-hook ()
  ;; when starting an Erlang shell in Emacs, default in the node name
  ;; (setq inferior-erlang-machine-options '("-sname" "emacs"))
  ;; customize keys
  (local-set-key [return] 'newline-and-indent)
  (local-set-key (kbd "C-c C-d f") 'erlang-man-function)
  (setq indent-tapbs-mode nil)
  (setq erlang-indent-level 4)
  (smartparens-strict-mode 1))

;; Some Erlang customizations
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

(provide 'ts-erlang)
