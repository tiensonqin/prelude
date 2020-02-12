;; enable elixir-mix
;; (global-elixir-mix-mode)

(require 'lsp-mode)
(require 'lsp-clients)
;; (require 'lsp-ui)
(require 'company)

;; (require 'alchemist)
;; (add-hook
;;  'alchemist-mode-hook
;;  (lambda ()
;;    (define-key alchemist-mode-map (kbd "\C-c\C-h") 'alchemist-help-search-at-point)
;;    (define-key alchemist-mode-map (kbd "\C-c n") 'elixir-format)
;;    ))
;; (setq alchemist-help-ansi-color t)

(setq lsp-ui-flycheck-enable 1)
(push 'company-lsp company-backends)

(setq lsp-ui-doc-delay 100)

;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'elixir-mode-hook #'lsp)

;; (lsp-register-client
;;  (make-lsp-client :new-connection (lsp-stdio-connection '("~/codes/source/elixir/elixir-ls/language_server.sh"))
;;                   :major-modes '(elixir-mode)
;;                   :server-id 'elixir-ls
;;                   ))

(add-hook
 'elixir-mode-hook
 (lambda ()
   (lsp)
   (flycheck-mode)
   ;; (add-hook 'before-save-hook 'lsp-format-buffer nil t)
   ))

(provide 'ts-elixir)
