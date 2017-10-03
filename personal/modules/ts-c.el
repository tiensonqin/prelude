(prelude-require-packages '(helm-gtags irony irony-eldoc company-c-headers rtags))

;; copy from http://tuhdo.github.io/c-ide.html
;; (setq
;;  helm-gtags-ignore-case t
;;  helm-gtags-auto-update t
;;  helm-gtags-use-input-at-cursor t
;;  helm-gtags-pulse-at-cursor t
;;  helm-gtags-prefix-key "\C-cg"
;;  helm-gtags-suggested-key-mapping t
;;  )

;; (require 'helm-gtags)
;; ;; Enable helm-gtags-mode
;; (add-hook 'dired-mode-hook 'helm-gtags-mode)
;; (add-hook 'eshell-mode-hook 'helm-gtags-mode)
;; (add-hook 'c-mode-hook 'helm-gtags-mode)
;; (add-hook 'c++-mode-hook 'helm-gtags-mode)
;; (add-hook 'asm-mode-hook 'helm-gtags-mode)

;; (define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;; (define-key helm-gtags-mode-map (kbd "C-c g j") 'helm-gtags-select)
;; (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;; (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;; (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;; (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;; (add-hook 'c-mode-common-hook 'hs-minor-mode)

(global-company-mode)
(require 'company-c-headers)

(require 'rtags) ;; optional, must have rtags installed
;; (cmake-ide-setup)

;; ;; add completion source for irony mode
;; (eval-after-load 'company
;;   '(add-to-list 'company-backends 'company-irony))

;; ; enable irony-mode for c++ mode
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)

;; ;; replace the `completion-at-point' and `complete-symbol' bindings in
;; ;; irony-mode's buffers by irony-mode's function
;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; make .h files open in c++ mode instead of c-mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-to-list 'company-backends 'company-c-headers)

(setq company-backends (delete 'company-semantic company-backends))
(eval-after-load "cc-mode"
  '(progn
     (add-to-list 'company-c-headers-path-system "/usr/include/c++/4.9/")
     ))

(setq company-idle-delay 0.3
      company-minimum-prefix-length 2)

(defun use-rtags (&optional useFileManager)
  (and (rtags-executable-find "rc")
       (cond
        ;; ((not (gtags-get-rootpath)) t)
        ((and (not (eq major-mode 'c++-mode))
              (not (eq major-mode 'c-mode))) (rtags-has-filemanager))
        (useFileManager (rtags-has-filemanager))
        (t (rtags-is-indexed)))))

(defun tags-find-symbol-at-point (&optional prefix)
  (interactive "P")
  (if (and (not (rtags-find-symbol-at-point prefix)) rtags-last-request-not-indexed)
      (gtags-find-tag)))
(defun tags-find-references-at-point (&optional prefix)
  (interactive "P")
  (if (and (not (rtags-find-references-at-point prefix)) rtags-last-request-not-indexed)
      (gtags-find-rtag)))
(defun tags-find-symbol ()
  (interactive)
  (call-interactively (if (use-rtags) 'rtags-find-symbol 'gtags-find-symbol)))
(defun tags-find-references ()
  (interactive)
  (call-interactively (if (use-rtags) 'rtags-find-references 'gtags-find-rtag)))
(defun tags-find-file ()
  (interactive)
  (call-interactively (if (use-rtags t) 'rtags-find-file 'gtags-find-file)))

(defun tags-imenu ()
  (interactive)
  (call-interactively (if (use-rtags t) 'rtags-imenu 'helm-imenu)))

(define-key c-mode-base-map (kbd "M-.") (function tags-find-symbol-at-point))
(define-key c-mode-base-map (kbd "M-,") (function rtags-location-stack-back))
(define-key c-mode-base-map (kbd "C-M-i") (function tags-find-references-at-point))
;; (define-key c-mode-base-map (kbd "M-;") (function tags-find-file))
(define-key c-mode-base-map (kbd "C-.") (function tags-find-symbol))
(define-key c-mode-base-map (kbd "C-,") (function tags-find-references))
(define-key c-mode-base-map (kbd "C-<") (function rtags-find-virtuals-at-point))
;; (define-key c-mode-base-map (kbd "M-i") (function tags-imenu))

;; (define-key global-map (kbd "M-.") (function tags-find-symbol-at-point))
;; (define-key global-map (kbd "M-,") (function tags-find-references-at-point))
;; ;; (define-key global-map (kbd "M-;") (function tags-find-file))
;; (define-key global-map (kbd "C-.") (function tags-find-symbol))
;; (define-key global-map (kbd "C-,") (function tags-find-references))
;; (define-key global-map (kbd "C-<") (function rtags-find-virtuals-at-point))
;; (define-key global-map (kbd "M-i") (function tags-imenu))

(add-hook 'c++-mode-hook 'flycheck-mode)

(setq rtags-use-helm t)

(provide 'ts-c)
