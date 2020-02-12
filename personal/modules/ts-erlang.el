(setq edts-man-root "/usr/lib/erlang/")
(setq erlang-root-dir "/usr/lib/erlang/")
(add-to-list 'exec-path "/usr/lib/erlang/bin/")

;; The lsp-ui sideline can become a serious distraction, so you
;; may want to disable it
(setq lsp-ui-sideline-enable nil)
;; Ensure docs are visible
(setq lsp-ui-doc-enable t)

;; Enable LSP automatically for Erlang files
(add-hook 'erlang-mode-hook #'lsp)

(push 'company-lsp company-backends)

;; Override the key bindings from erlang-mode to use LSP for completion
(eval-after-load 'erlang
  '(define-key erlang-mode-map (kbd "C-M-i") #'company-lsp))

(defun my-erlang-mode-hook ()
  ;; when starting an Erlang shell in Emacs, default in the node name
  ;; (setq inferior-erlang-machine-options '("-sname" "emacs"))
  ;; customize keys
  (lsp)
  ;; (local-set-key [return] 'newline-and-indent)
  ;; (local-set-key (kbd "C-c C-d f") 'erlang-man-function)
  (setq indent-tapbs-mode nil)
  (setq erlang-indent-level 4)
  (smartparens-strict-mode 1))

;; Some Erlang customizations
(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)

(setq lsp-log-io t)

(provide 'ts-erlang)
