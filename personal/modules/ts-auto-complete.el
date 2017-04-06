;; (require 'auto-complete-config)
;; (ac-config-default)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")

;; ;; resetting ac-sources
;; (setq-default ac-sources '(
;;                            ac-source-yasnippet
;;                            ac-source-abbrev
;;                            ac-source-dictionary
;;                            ac-source-words-in-same-mode-buffers
;;                            ))
;; (ac-flyspell-workaround)
;; ;; support coffee-mode
;; (add-to-list 'ac-modes  'coffee-mode)
;; (add-to-list 'ac-modes  'web-mode)
;; (add-to-list 'ac-modes  'cc-mode)
;; (add-to-list 'ac-modes  'html-mode)
(add-to-list 'ac-modes  'java-mode)

(provide 'ts-auto-complete)
