(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))

;; (add-to-list 'load-path "/opt/tern/emacs")
;; (autoload 'tern-mode "tern.el" nil t)
(add-hook 'js2-mode-hook (lambda ()
                           (auto-complete-mode t)
                           (setq js2-basic-offset 2)
                           ;; (tern-mode t)
                           ))
;; (eval-after-load 'tern
;;   '(progn
;;      (require 'tern-auto-complete)
;;      (tern-ac-setup)))

(provide 'ts-javascript)
