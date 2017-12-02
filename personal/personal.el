(prelude-require-packages '(auto-complete company js2-mode ag multiple-cursors geiser markdown-mode helm-swoop helm-gtags imenu-list solarized-theme))
;; (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;; (add-to-list 'package-archives '("elpa" . "http://elpa.gnu.org/packages/"))

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (disable-theme 'zenburn)
;; (require 'color-theme)
(load-theme 'solarized-dark)
;; (load-theme 'zenburn)

;; Gotta do UTF-8
(require 'un-define "un-define" t)
(set-buffer-file-coding-system 'utf-8 'utf-8-unix)
(set-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(set-default buffer-file-coding-system 'utf-8-unix)

(add-hook 'before-make-frame-hook
          #'(lambda ()
              (add-to-list 'default-frame-alist '(height . 48))
              (add-to-list 'default-frame-alist '(width  . 80))))

(defun setup-frame-hook (frame)
  "This function will be applied to all new emacs frames."
  (set-frame-parameter frame 'alpha '(95 95)) ; translucency
  (mouse-avoidance-mode 'cat-and-mouse) ; avoid mouse
  (scroll-bar-mode 0)                   ; no scrollbar
  (set-frame-parameter (selected-frame) 'alpha '(95 95))) ; translucency)
(add-hook 'after-make-frame-functions 'setup-frame-hook)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; set default fonts
(set-frame-font "Monaco-13")
(setq default-frame-alist '((font . "Monaco-13")))

;;; registers
;; open init file C-x r j e
(set-register ?e (cons 'file "~/.emacs.d/personal/personal.el"))

;; set default browser to chromium
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium")

;; quiet, please! No dinging!
(setq visible-bell t)

(setq prelude-whitespace nil)

(global-unset-key "\C-o")

(defun haskell-cleanup-buffer-or-region ()
  "Cleanup a region if selected, otherwise the whole buffer."
  (interactive)
  (call-interactively 'untabify)
  (whitespace-cleanup))

(defun haskell-cleanup-on-save ()
  (add-hook 'before-save-hook #'haskell-cleanup-buffer-or-region))

(defun clojure-cleanup-buffer-or-region ()
  "Cleanup a region if selected, otherwise the whole buffer."
  (interactive)
  (call-interactively 'untabify)
  (whitespace-cleanup))

(defun clojure-cleanup-on-save ()
  (add-hook 'before-save-hook #'clojure-cleanup-buffer-or-region))

;; (add-hook 'ruby-mode-hook #'prelude-cleanup-on-save)
;; (add-hook 'erlang-mode-hook #'prelude-cleanup-on-save)
(add-hook 'clojure-mode-hook #'clojure-cleanup-on-save)
;; (add-hook 'scheme-mode-hook #'prelude-cleanup-on-save)
;; (add-hook 'c-mode-hook #'prelude-cleanup-on-save)
(add-hook 'haskell-mode-hook #'haskell-cleanup-on-save)
;; (add-hook 'ocaml-mode-hook #'prelude-cleanup-on-save)
;; (add-hook 'lisp-mode-hook #'prelude-cleanup-on-save)

(add-to-list 'load-path "~/.emacs.d/personal/modules")

(setq max-specpdl-size 5)  ; default is 1000, reduce the backtrace level
(setq debug-on-error t)    ; now you should get a backtrace

(setq ring-bell-function #'ignore)
(setq ns-use-native-fullscreen nil)

(setq erc-autojoin-channels-alist '(("freenode.net" "#haskell" "#erlang" "#clojure")))

;; (global-set-key (kbd "s-<return>") 'toggle-frame-fullscreen)

;; (prelude-swap-meta-and-super)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doc-view-ghostscript-options
   (quote
    ("-dSAFER" "-dNOPAUSE" "-sDEVICE=png16m" "-dTextAlphaBits=4" "-dBATCH" "-dGraphicsAlphaBits=4" "-dQUIET" "-r100")))
 '(doc-view-resolution 300))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(shm-quarantine-face ((t (:background "#073642")))))

;; pretty-symbol
(global-prettify-symbols-mode 1)

(eval-after-load "flyspell"
  ;; '(define-key flyspell-mode-map (kbd "C-.") nil)
  '(define-key flyspell-mode-map (kbd "C-M-i") nil)
  )

(global-undo-tree-mode -1)

(setq sp-highlight-pair-overlay nil)

(setq erc-hide-list '("JOIN" "PART" "QUIT"))

;; google translate
(global-set-key (kbd "C-c g t") 'google-translate-at-point)
(global-set-key (kbd "C-c g q") 'google-translate-query-translate)
(setq google-translate-default-source-language "en")
(setq google-translate-default-target-language "zh-CN")

;; mermaid
;; (add-to-list 'load-path "~/.emacs.d/personal/vendor/mermaid-mode")
;; (load-file "~/.emacs.d/personal/vendor/mermaid-mode/mermaid.el")

;; image+
;; (eval-after-load 'image
;;   '(progn
;;      (require 'image+)
;;      (imagex-global-sticky-mode 1)
;;      (imagex-auto-adjust-mode 1)
;;      ))

(require 'ts-defuns)
(require 'ts-bindings)
(require 'ts-org)
(require 'ts-javascript)
(require 'ts-clojure)
(require 'ts-haskell)
(require 'ts-scheme)
(require 'ts-java)
(require 'ts-erlang)
(require 'ts-image)
(require 'ts-sql)
(require 'ts-speedbar)
;; (require 'ts-rust)
(require 'ts-ocaml)
(require 'ts-c)
(require 'ts-ats)
(require 'ts-reason)

(setq erc-autojoin-channels-alist '(("freenode.net" "#ocaml")))

;; (require 'ts-android)
;; (require 'ts-go)
;; (require 'ts-elixir)
;; (require 'ts-html)
;; (require 'ts-scala)
;; (require 'ts-mail)
;; (require 'ts-magit-flow)
;; (add-hook 'magit-mode-hook 'turn-on-magit-flow)
;; (require 'ts-auto-complete)
;; (require 'ts-smartparens)

;; temp workaround
(setq projectile-mode-line
      '(:eval (format " Projectile[%s]"
                      (projectile-project-name))))
(setq create-lockfiles nil)
