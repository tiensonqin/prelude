;; enable elixir-mix
;; (global-elixir-mix-mode)

(require 'lsp-mode)
(require 'lsp-clients)
;; (require 'lsp-ui)
(require 'company)

(setq lsp-ui-flycheck-enable 1)
(push 'company-lsp company-backends)

(setq lsp-ui-doc-delay 100)

;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)

(add-hook
 'elixir-mode-hook
 (lambda ()
   (lsp)
   (flycheck-mode)
   ;; (add-hook 'before-save-hook 'lsp-format-buffer nil t)
   ))

(provide 'ts-elixir)
