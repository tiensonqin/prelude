(prelude-require-packages '(ocp-indent))

(require 'ocp-indent)

(add-to-list 'load-path "~/.emacs.d/personal/vendor/ocamlformat")

(load-file "~/.emacs.d/personal/vendor/ocamlformat/ocamlformat.el")

(require 'ocamlformat)

(setq tuareg-indent-align-with-first-arg nil)

(add-hook
 'tuareg-mode-hook
 (lambda ()
   (define-key merlin-mode-map (kbd "C-c n") 'ocamlformat)
   (add-hook 'before-save-hook 'ocamlformat-before-save)
   
   (setq show-trailing-whitespace t)
   (setq indicate-empty-lines t)

   (sp-with-modes 'tuareg-mode
     ;; disable ', it's the quote character!
     (sp-local-pair "'" nil :actions nil)
     (sp-local-pair "`" nil :actions nil))

   (which-function-mode -1)

   ;; (setq tuareg-use-smie nil)

   (when (functionp 'prettify-symbols-mode)
     (prettify-symbols-mode -1))

   ;; (define-key merlin-mode-map (kbd "M-.") 'merlin-locate)
   ;; (define-key merlin-mode-map (kbd "M-,") 'merlin-pop-stack)
   ;; (define-key merlin-mode-map (kbd "M-t") 'merlin-type-enclosing)
   ;; (define-key tuareg-mode-map (kbd "\C-c\C-h") 'merlin-document)
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
   ))

;; (load "~/.emacs.d/personal/vendor/PG/generic/proof-site")

(require 'lsp-mode)
(require 'lsp-ocaml)

(add-hook 'tuareg-mode-hook #'lsp-ocaml-enable)
(add-hook 'caml-mode-hook #'lsp-ocaml-enable)
(add-hook 'reason-mode-hook #'lsp-ocaml-enable)

(provide 'ts-ocaml)
