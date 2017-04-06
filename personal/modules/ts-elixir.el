(defun auto-activate-ruby-end-mode-for-elixir-mode ()
  (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re)
       "\\(?:^\\|\\s-+\\)\\(?:do\\)")
  (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers) nil)
  (ruby-end-mode +1))
(add-hook 'elixir-mode-hook 'auto-activate-ruby-end-mode-for-elixir-mode)

(require 'alchemist)
(setq alchemist-help-ansi-color t)

;; enable elixir-mix
;; (global-elixir-mix-mode)
(provide 'ts-elixir)
