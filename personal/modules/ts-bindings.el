;; comment-or-uncomment-region-or-line
(global-set-key (kbd "M-=") 'comment-or-uncomment-region-or-line)

(global-set-key (kbd "M-!") 'my-shell-command-on-current-file)

(global-set-key (kbd "s-i") 'kid-sdcv-to-buffer)
;; (global-set-key (kbd "s-i") 'osx-dictionary-search-pointer)

(global-set-key (kbd "M-i") 'helm-imenu)

(global-set-key (kbd "M-g") 'goto-line)

(global-set-key (kbd "C-c C-d m") 'erlang-man-module)

(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key global-map (kbd "C-j") 'newline-and-indent)

(add-hook 'c-mode-common-hook
          (lambda () (define-key c-mode-base-map (kbd "C-c C-l") 'compile)
            (local-set-key (kbd "C-h d")
                           (lambda ()
                             (interactive)
                             (manual-entry (current-word))))))

;; paredit
(define-key global-map (kbd "M-(") 'paredit-wrap-round)

(global-set-key (kbd "C-'") #'imenu-list-minor-mode)
(global-set-key (kbd "C-c C-s") 'speak)
(global-set-key (kbd "s-e") 'mc/edit-lines)

(provide 'ts-bindings)
