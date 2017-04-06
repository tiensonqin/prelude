(prelude-require-packages '(rust-mode racer flycheck-rust cargo))

(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

(add-hook 'rust-mode-hook
          (lambda ()
            (racer-mode)
            (cargo-minor-mode)
            ))
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(setq rust-format-on-save t)
(setq company-tooltip-align-annotations t)

(provide 'ts-rust)
