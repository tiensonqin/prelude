(add-hook 'scheme-mode-hook 'geiser-mode)
(setq geiser-active-implementations '(racket))

(add-hook 'geiser-repl-mode-hook 'smartparens-strict-mode)
(provide 'ts-scheme)
