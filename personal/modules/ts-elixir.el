;; (defun auto-activate-ruby-end-mode-for-elixir-mode ()
;;   (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re)
;;        "\\(?:^\\|\\s-+\\)\\(?:do\\)")
;;   (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers) nil)
;;   (ruby-end-mode +1))
;; (add-hook 'elixir-mode-hook 'auto-activate-ruby-end-mode-for-elixir-mode)

;; (require 'alchemist)
;; (add-hook
;;  'alchemist-mode-hook
;;  (lambda ()
;;    (define-key alchemist-mode-map (kbd "\C-c\C-h") 'alchemist-help-search-at-point)
;;    (define-key alchemist-mode-map (kbd "\C-c n") 'elixir-format)
;;    ))
;; (setq alchemist-help-ansi-color t)

;; (add-hook 'elixir-mode-hook
;;           (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

(add-hook 'elixir-mode-hook #'lsp)

;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-stdio-connection '("~/codes/source/elixir/elixir-ls/language_server.sh"))
;;                   :major-modes '(elixir-mode)
;;                   :server-id 'elixir-ls
;;                   ))


;; enable elixir-mix
;; (global-elixir-mix-mode)
(setq lsp-ui-doc-delay 100)
(provide 'ts-elixir)
