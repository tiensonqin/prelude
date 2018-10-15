;; (quelpa '(reason-mode :repo "reasonml-editor/reason-mode" :fetcher github :stable t))

;;----------------------------------------------------------------------------
;; Reason setup
;;----------------------------------------------------------------------------

(defun shell-cmd (cmd)
  "Returns the stdout output of a shell command or nil if the command returned
   an error"
  (car (ignore-errors (apply 'process-lines (split-string cmd)))))

(let* ((refmt-bin (shell-cmd "which bsrefmt"))
       (merlin-bin (shell-cmd "which ocamlmerlin"))
       (merlin-base-dir (when merlin-bin
                          (replace-regexp-in-string "bin/ocamlmerlin$" "" merlin-bin))))
  ;; Add npm merlin.el to the emacs load path and tell emacs where to find ocamlmerlin
  (when merlin-bin
    (add-to-list 'load-path (concat merlin-base-dir "share/emacs/site-lisp/"))
    (setq merlin-command merlin-bin))

  (when refmt-bin
    (setq refmt-command refmt-bin)))

(require 'reason-mode)
(add-hook 'reason-mode-hook (lambda ()
                              (setq show-trailing-whitespace t)
                              (setq indicate-empty-lines t)

                              (add-hook 'before-save-hook 'refmt-before-save)
                              (merlin-mode)

                              (define-key merlin-mode-map (kbd "M-.") 'merlin-locate)
                              (define-key merlin-mode-map (kbd "M-,") 'merlin-pop-stack)
                              (define-key merlin-mode-map (kbd "M-t") 'merlin-type-enclosing)

     ;;                          (defun merlin-switch ()
   ;;                              (interactive)
   ;;                              (let* ((cur buffer-file-name)
   ;;                                     (file (cond
   ;;                                            ((string-suffix-p ".rei" cur) (substring cur 0 (- (length cur) 1)))
   ;;                                            ((string-suffix-p ".rel" cur) (concat cur "i"))
   ;;                                            (t (error (concat "Not an reason source file: " cur))))))
   ;;                                (if (file-exists-p file)
   ;;                                    (merlin--goto-file-and-point (list (cons 'file file)))
   ;;                                  (error (concat "File does not exist: " file)))))

   ;;                            (define-key merlin-mode-map (kbd "C-c m") 'merlin-switch)

   ;; ;;; opens up an interface when present
   ;;                            (setq merlin-locate-preference 'ml)
   ;;                            (setq merlin-locate-in-new-window 'never)
                              ))

(setq merlin-ac-setup t)

;; (require 'merlin-iedit)
;; (defun evil-custom-merlin-iedit ()
;;   (interactive)
;;   (if iedit-mode (iedit-mode)
;;     (merlin-iedit-occurrences)))
;; (define-key merlin-mode-map (kbd "C-c C-e") 'evil-custom-merlin-iedit)

(provide 'ts-reason)
