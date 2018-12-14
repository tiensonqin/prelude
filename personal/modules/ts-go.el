(defun my-go-mode-hook ()
  ;; Call Gofmt before saving 
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 4)
  (setq indent-tabs-mode 1)
  ;; Godef jump key binding                                                      
  (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(add-hook 'go-mode-hook 'go-eldoc-setup)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))
(setenv "GOPATH" "/home/tienson/codes/go")
(provide 'ts-go)
