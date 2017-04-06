(prelude-require-packages '(ghc shm company-ghc))

(require 'shm)
(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map [f8] 'haskell-navigate-imports))

(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
  (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
  (add-to-list 'exec-path my-cabal-path))

;; hasktags
;; (custom-set-variables '(haskell-tags-on-save t))

(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t))

(setq haskell-process-generate-tags nil)

(eval-after-load 'haskell-mode '(progn
                                  (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
                                  (define-key haskell-mode-map (kbd "C-`") 'haskell-interactive-bring)
                                  (define-key haskell-mode-map (kbd "C-M-i") 'ghc-complete)
                                  (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
                                  (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
                                  (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
                                  (define-key haskell-mode-map (kbd "C-c c") 'haskell-process-cabal)
                                  (define-key haskell-mode-map (kbd "SPC") 'haskell-mode-contextual-space)))
(eval-after-load 'haskell-cabal '(progn
                                   (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-bring)
                                   (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-ode-clear)
                                   (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
                                   (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(custom-set-variables '(haskell-process-type 'cabal-repl))

;; Docs

(dolist (hook '(haskell-mode-hook inferior-haskell-mode-hook haskell-interactive-mode-hook))
  (add-hook hook 'turn-on-haskell-doc-mode)
  (add-hook hook (lambda ()
                   (haskell-indentation-mode 0)
                   (subword-mode +1)
                   (smartparens-strict-mode +1))))

;; (setq haskell-font-lock-symbols t)

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)

;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(add-to-list 'company-backends 'company-ghc)
(custom-set-variables '(company-ghc-show-info t))

(add-hook 'haskell-mode-hook (lambda ()
                               (ghc-init)
                               (structured-haskell-mode t)))

;; hindent
(add-to-list 'load-path "/opt/haskell/hindent/elisp")
(require 'hindent)
(setq hindent-style "gibiansky")
(add-hook 'haskell-mode-hook #'hindent-mode)
(add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)

(require 'haskell-debug)

;; copy from chrisdone
(defun haskell-who-calls (&optional prompt)
  "Grep the codebase to see who uses the symbol at point."
  (interactive "P")
  (let ((sym (if prompt
                 (read-from-minibuffer "Look for: ")
               (haskell-ident-at-point))))
    (let ((existing (get-buffer "*who-calls*")))
      (when existing
        (kill-buffer existing)))
    (let ((buffer
           (grep-find (format "cd %s && find . -name '*.hs' -exec grep -inH -e %s {} +"
                              (haskell-session-current-dir (haskell-session))
                              sym))))
      (with-current-buffer buffer
        (rename-buffer "*who-calls*")
        (switch-to-buffer-other-window buffer)))))

(defun shm-repl-tab ()
  "TAB completion or jumping."
  (interactive)
  (unless (shm/jump-to-slot)
    (call-interactively 'haskell-interactive-mode-tab)))

(defun haskell-interactive-toggle-print-mode ()
  (interactive)
  (setq haskell-interactive-mode-eval-mode
        (intern
         (ido-completing-read "Eval result mode: "
                              '("fundamental-mode"
                                "haskell-mode"
                                "espresso-mode"
                                "ghc-core-mode"
                                "org-mode")))))

(defun haskell-insert-doc ()
  "Insert the documentation syntax."
  (interactive)
  (unless (= (line-beginning-position)
             (line-end-position))
    (shm/backward-paragraph))
  (unless (= (line-beginning-position)
             (line-end-position))
    (save-excursion (insert "\n")))
  (insert "-- | "))

(defun haskell-insert-undefined ()
  "Insert undefined."
  (interactive)
  (if (and (boundp 'structured-haskell-mode)
           structured-haskell-mode)
      (shm-insert-string "undefined")
    (insert "undefined")))

(defun haskell-move-right ()
  (interactive)
  (haskell-move-nested 1))

(defun haskell-move-left ()
  (interactive)
  (haskell-move-nested -1))

(defun haskell-process-cabal-build-and-restart ()
  "Build and restart the Cabal project."
  (interactive)
  (cond
   (haskell-process-use-ghci
    (when (buffer-file-name)
      (save-buffer))
    ;; Reload main module where `main' function is
    (haskell-process-reload-devel-main))
   (t
    (haskell-process-cabal-build)
    (haskell-process-queue-without-filters
     (haskell-process)
     (format ":!cd %s && scripts/restart\n" (haskell-session-cabal-dir (haskell-session)))))
   (t (turbo-devel-reload))))

(defun haskell-who-calls (&optional prompt)
  "Grep the codebase to see who uses the symbol at point."
  (interactive "P")
  (let ((sym (if prompt
                 (read-from-minibuffer "Look for: ")
               (haskell-ident-at-point))))
    (let ((existing (get-buffer "*who-calls*")))
      (when existing
        (kill-buffer existing)))
    (cond
     ;; Use grep
     (nil (let ((buffer
                 (grep-find (format "cd %s && find . -name '*.hs' -exec grep -inH -e %s {} +"
                                    (haskell-session-current-dir (haskell-session))
                                    sym))))
            (with-current-buffer buffer
              (rename-buffer "*who-calls*")
              (switch-to-buffer-other-window buffer))))
     ;; Use ag
     (t (ag-files sym
                  "\\.hs$"
                  (haskell-session-current-dir (haskell-session)))))))

(defun haskell-auto-insert-module-template ()
  "Insert a module template for the newly created buffer."
  (interactive)
  (when (and (= (point-min)
                (point-max))
             (buffer-file-name))
    (insert
     "-- | "
     "\n"
     "\n"
     "module "
     )
    (let ((name (haskell-guess-module-name)))
      (if (string= name "")
          (progn (insert "Main")
                 (shm-evaporate (- (point) 5)
                                (point)))
        (insert name)))
    (insert " where"
            "\n"
            "\n")
    (goto-char (point-min))
    (forward-char 4)))

(defun shm-contextual-space ()
  "Do contextual space first, and run shm/space if no change in
the cursor position happened."
  (interactive)
  (progn
    (let ((ident (haskell-ident-at-point)))
      (when ident
        (and interactive-haskell-mode
             (haskell-process-do-try-type ident))))
    (call-interactively 'shm/space)))

(defun shm/insert-putstrln ()
  "Insert a putStrLn."
  (interactive)
  (let ((name
         (save-excursion
           (goto-char (car (shm-decl-points)))
           (buffer-substring-no-properties
            (point)
            (1- (search-forward " "))))))
    (insert
     (format "putStrLn \"%s:%s:%d\""
             (file-name-nondirectory (buffer-file-name))
             name
             (line-number-at-pos)))))

(add-hook 'w3m-display-hook 'w3m-haddock-display)

(define-key haskell-mode-map (kbd "C-c i") 'hindent/reformat-decl)
(define-key haskell-mode-map (kbd "C-c C-d") 'haskell-w3m-open-haddock)
(define-key haskell-mode-map (kbd "C-c C-u") 'haskell-insert-undefined)
(define-key haskell-mode-map (kbd "C-c C-a") 'haskell-insert-doc)
(define-key haskell-mode-map (kbd "M-,") 'haskell-who-calls)
(define-key haskell-mode-map (kbd "C-<right>") 'haskell-move-right)
(define-key haskell-mode-map (kbd "C-<left>") 'haskell-move-left)
(define-key haskell-mode-map (kbd "<space>") 'haskell-mode-contextual-space)

(define-key shm-repl-map (kbd "TAB") 'shm-repl-tab)
(define-key shm-map (kbd "C-c C-p") 'shm/expand-pattern)
(define-key shm-map (kbd "C-c C-s") 'shm/case-split)
(define-key shm-map (kbd "SPC") 'shm-contextual-space)
(define-key shm-map (kbd "C-\\") 'shm/goto-last-point)
(define-key shm-map (kbd "C-c C-f") 'shm-fold-toggle-decl)
(define-key shm-map (kbd "C-c i") 'hindent-reformat-buffer)

(defun haskell-process-all-types ()
  "List all types in a grep-mode buffer."
  (interactive)
  (let ((session (haskell-session)))
    (switch-to-buffer (get-buffer-create (format "*%s:all-types*"
                                                 (haskell-session-name (haskell-session)))))
    (setq haskell-session session)
    (cd (haskell-session-current-dir session))
    (let ((inhibit-read-only t))
      (erase-buffer)
      (let ((haskell-process-log nil))
        (insert (haskell-process-queue-sync-request (haskell-process) ":all-types")))
      (unless (eq major-mode  'compilation-mode)
        (compilation-mode)
        (setq compilation-error-regexp-alist
              haskell-compilation-error-regexp-alist)))))

(defvar haskell-stack-commands
  '("build"
    "update"
    "test"
    "bench"
    "install")
  "Stack commands.")

;;;###autoload
(defun haskell-process-stack-build ()
  "Build the Stack project."
  (interactive)
  (haskell-process-do-stack "build")
  (haskell-process-add-cabal-autogen))

;;;###autoload
(defun haskell-process-stack (p)
  "Prompts for a Stack command to run."
  (interactive "P")
  (if p
      (haskell-process-do-stack
       (read-from-minibuffer "Stack command (e.g. install): "))
    (haskell-process-do-stack
     (funcall haskell-completing-read-function "Stack command: "
              (append haskell-stack-commands
                      (list "build --ghc-options=-fforce-recomp")
                      (list "build --ghc-options=-O0"))))))

(defun haskell-process-do-stack (command)
  "Run a Cabal command."
  (let ((process (haskell-interactive-process)))
    (cond
     ((let ((child (haskell-process-process process)))
        (not (equal 'run (process-status child))))
      (message "Process is not running, so running directly.")
      (shell-command (concat "stack " command)
                     (get-buffer-create "*haskell-process-log*")
                     (get-buffer-create "*haskell-process-log*"))
      (switch-to-buffer-other-window (get-buffer "*haskell-process-log*")))
     (t (haskell-process-queue-command
         process
         (make-haskell-command
          :state (list (haskell-interactive-session) process command 0)

          :go
          (lambda (state)
            (haskell-process-send-string
             (cadr state)
             (format ":!stack %s"
                     (cl-caddr state))))

          :live
          (lambda (state buffer)
            (let ((cmd (replace-regexp-in-string "^\\([a-z]+\\).*"
                                                 "\\1"
                                                 (cl-caddr state))))
              (cond ((or (string= cmd "build")
                         (string= cmd "install"))
                     (haskell-process-live-build (cadr state) buffer t))
                    (t
                     (haskell-process-cabal-live state buffer)))))

          :complete
          (lambda (state response)
            (let* ((process (cadr state))
                   (session (haskell-process-session process))
                   (message-count 0)
                   (cursor (haskell-process-response-cursor process)))
              (haskell-process-set-response-cursor process 0)
              (while (haskell-process-errors-warnings session process response)
                (setq message-count (1+ message-count)))
              (haskell-process-set-response-cursor process cursor)
              (let ((msg (format "Complete: cabal %s (%s compiler messages)"
                                 (cl-caddr state)
                                 message-count)))
                (haskell-interactive-mode-echo session msg)
                (when (= message-count 0)
                  (haskell-interactive-mode-echo
                   session
                   "No compiler messages, dumping complete output:")
                  (haskell-interactive-mode-echo session response))
                (haskell-mode-message-line msg)
                (when (and haskell-notify-p
                           (fboundp 'notifications-notify))
                  (notifications-notify
                   :title (format "*%s*" (haskell-session-name (car state)))
                   :body msg
                   :app-name (cl-ecase (haskell-process-type)
                               ('ghci haskell-process-path-cabal)
                               ('cabal-repl haskell-process-path-cabal)
                               ('cabal-ghci haskell-process-path-cabal))
                   :app-icon haskell-process-logo)))))))))))

(defun haskell-setup-stack-commands ()
  "Setup stack keybindings."
  (interactive)
  (define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-process-stack-build)
  (define-key interactive-haskell-mode-map (kbd "C-c c") 'haskell-process-stack))

(defun stack-mode-save-flycheck ()
  "Save the buffer and flycheck it."
  (interactive)
  (save-buffer)
  (flycheck-buffer))

(provide 'ts-haskell)
