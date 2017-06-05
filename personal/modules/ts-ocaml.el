;; (setq auto-mode-alist
;;       (append '(("\\.ml[ily]?$" . tuareg-mode))
;;               auto-mode-alist))

;; ;; -- Tweaks for OS X -------------------------------------
;; ;; Tweak for problem on OS X where Emacs.app doesn't run the right
;; ;; init scripts when invoking a sub-shell
;; (cond
;;  ((eq window-system 'ns) ; macosx
;;   ;; Invoke login shells, so that .profile or .bash_profile is read
;;   (setq shell-command-switch "-lc")))

;; ;; -- opam and utop setup --------------------------------
;; ;; Setup environment variables using opam
;; (defun opam-vars ()
;;   (let* ((x (shell-command-to-string "opam config env"))
;;          (x (split-string x "\n"))
;;          (x (remove-if (lambda (x) (equal x "")) x))
;;          (x (mapcar (lambda (x) (split-string x ";")) x))
;;          (x (mapcar (lambda (x) (car x)) x))
;;          (x (mapcar (lambda (x) (split-string x "=")) x))
;;          )
;;     x))
;; (dolist (var (opam-vars))
;;   (setenv (car var) (substring (cadr var) 1 -1)))
;; ;; The following simpler alternative works as of opam 1.1
;; ;; (dolist
;; ;;    (var (car (read-from-string
;; ;;             (shell-command-to-string "opam config env --sexp"))))
;; ;;  (setenv (car var) (cadr var)))
;; ;; Update the emacs path
;; (setq exec-path (split-string (getenv "PATH") path-separator))
;; ;; Update the emacs load path
;; (push (concat (getenv "OCAML_TOPLEVEL_PATH")
;;               "/../../share/emacs/site-lisp") load-path)
;; ;; Automatically load utop.el
;; (autoload 'utop "utop" "Toplevel for OCaml" t)
;; (autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
;; (add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)

;; ;; -- merlin setup ---------------------------------------
;; ;; Add opam emacs directory to the load-path
;; (setq opam-share (substring (shell-command-to-string "opam config var share 2> /dev/null") 0 -1))
;; (add-to-list 'load-path (concat opam-share "/emacs/site-lisp"))
;; ;; Load merlin-mode
;; (require 'merlin)
;; ;; Start merlin on ocaml files
;; (add-hook 'tuareg-mode-hook 'merlin-mode t)
;; (add-hook 'caml-mode-hook 'merlin-mode t)
;; ;; Enable auto-complete
;; (setq merlin-use-auto-complete-mode 'easy)
;; ;; Use opam switch to lookup ocamlmerlin binary
;; (setq merlin-command 'opam)

;; ;; -- enable auto-complete -------------------------------
;; ;; Not required, but useful along with merlin-mode
;; (require 'auto-complete)
;; (add-hook 'tuareg-mode-hook 'auto-complete-mode)
;; (provide 'ts-ocaml)
;; (add-to-list 'load-path "~/.emacs.d/personal/vendor/ocp-indent")
;; (load-file (expand-file-name "~/.emacs.d/personal/vendor/ocp-indent/ocp-indent.el"))

(prelude-require-packages '(ocp-indent))

(require 'ocp-indent)

(setq tuareg-indent-align-with-first-arg nil)

(add-hook
 'tuareg-mode-hook
 (lambda ()
   (setq show-trailing-whitespace t)
   (setq indicate-empty-lines t)

   (sp-with-modes 'tuareg-mode
     ;; disable ', it's the quote character!
     (sp-local-pair "'" nil :actions nil)
     (sp-local-pair "`" nil :actions nil))

   (which-function-mode -1)

   (setq tuareg-use-smie nil)

   (when (functionp 'prettify-symbols-mode)
     (prettify-symbols-mode -1))

   (define-key merlin-mode-map (kbd "M-.") 'merlin-locate)
   (define-key merlin-mode-map (kbd "M-,") 'merlin-pop-stack)
   (define-key tuareg-mode-map (kbd "\C-c\C-h") 'merlin-document)
   (define-key tuareg-mode-map (kbd "\C-c\C-m") 'ocaml-make-command)
   (defun merlin-switch ()
     (interactive)
     (let* ((cur buffer-file-name)
            (file (cond
                   ((string-suffix-p ".mli" cur) (substring cur 0 (- (length cur) 1)))
                   ((string-suffix-p ".ml" cur) (concat cur "i"))
                   (t (error (concat "Not an ocaml source file: " cur))))))
       (if (file-exists-p file)
           (merlin--goto-file-and-point (list (cons 'file file)))
         (error (concat "File does not exist: " file)))))

   (define-key merlin-mode-map (kbd "C-c m") 'merlin-switch)

   ;;; opens up an interface when present
   (setq merlin-locate-preference 'ml)
   (setq merlin-locate-in-new-window 'never)
   ;; See README
   ;;(setq tuareg-match-patterns-aligned t)
   ;; (electric-indent-mode 0)
   ))

(load "~/.emacs.d/personal/vendor/PG/generic/proof-site")

(provide 'ts-ocaml)
