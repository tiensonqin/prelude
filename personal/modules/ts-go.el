(defun my-go-mode-hook ()
  ;; Call Gofmt before saving 
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; Godef jump key binding                                                      
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(provide 'ts-go)
