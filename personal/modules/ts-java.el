(condition-case nil
    (require 'use-package)
  (file-error
   (require 'package)
   (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
   (package-initialize)
   (package-refresh-contents)
   (package-install 'use-package)
   (require 'use-package)))

(use-package lsp-mode
  :ensure t
  :init (setq lsp-eldoc-render-all nil
              lsp-highlight-symbol-at-point nil))

(use-package company-lsp
  :after  company
  :ensure t
  :config
  (add-hook 'java-mode-hook (lambda () (push 'company-lsp company-backends)))
  (setq company-lsp-cache-candidates t)
  ;; (push 'java-mode company-global-modes)
  )

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-sideline-update-mode 'point))

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode t)
  (dap-ui-mode t))

(use-package dap-java
  :after 'lsp-java)

;; (use-package lsp-java
;;   :ensure t
;;   :config
;;   (add-hook 'java-mode-hook  'lsp-java-enable)
;;   (add-hook 'java-mode-hook  'flycheck-mode)
;;   (add-hook 'java-mode-hook  'company-mode)
;;   (add-hook 'java-mode-hook  'lsp-ui-mode))
(provide 'ts-java)
