(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(defun jao-toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (if selective-display nil (or column 3))))

;;; sdcv dictionary
;; author: pluskid
;; 调用 stardict 的命令行程序 sdcv 来查辞典
;; 如果选中了 region 就查询 region 的内容，否则查询当前光标所在的单词
;; 查询结果在一个叫做 *sdcv* 的 buffer 里面显示出来，在这个 buffer 里
;; 面
;; 按 q 可以把这个 buffer 放到 buffer 列表末尾，按 d 可以查询单词
(defun kid-sdcv-to-buffer ()
  (interactive)
  (let ((word (if mark-active
                  (buffer-substring-no-properties (region-beginning) (region-end))
                (current-word nil t))))
    (setq word (read-string (format "Search the dictionary for (default %s): " word)
                            nil nil word))
    ;; (call-process-shell-command (format "flite -voice /opt/voices/cmu_us_rms.flitevox -t %s &" word) nil 0)
    (call-process-shell-command (format "proxychains tts -w '%s' &" word) nil 0)
    (call-process-shell-command (format "grep -q -F '%s' ~/Dropbox/orgs/words || echo '%s' >> ~/Dropbox/orgs/words &" word word) nil 0)
    (set-buffer (get-buffer-create "*sdcv*"))
    (buffer-disable-undo)
    (erase-buffer)
    (let ((process (start-process-shell-command "sdcv" "*sdcv*" "sdcv" "-n" word))) ; "trans" ":en+zh"
      (set-process-sentinel
       process
       (lambda (process signal)
         (when (memq (process-status process) '(exit signal))
           (unless (string= (buffer-name) "*sdcv*")
             (setq kid-sdcv-window-configuration (current-window-configuration))
             (switch-to-buffer-other-window "*sdcv*")
             (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
             (local-set-key (kbd "q") (lambda ()
                                        (interactive)
                                        (bury-buffer)
                                        (unless (null (cdr (window-list))) ; only one window
                                          (delete-window)))))
           (goto-char (point-min))))))))

(defun my-shell-command-on-current-file (command &optional output-buffer error-buffer)
  "Run a shell command on the current file (or marked dired files).
In the shell command, the file(s) will be substituted wherever a '%' is."
  (interactive (list (read-from-minibuffer "Shell command: "
                                           nil nil nil 'shell-command-history)
                     current-prefix-arg
                     shell-command-default-error-buffer))
  (cond ((buffer-file-name)
         (setq command (replace-regexp-in-string "%" (buffer-file-name) command nil t)))
        ((and (equal major-mode 'dired-mode) (save-excursion (dired-move-to-filename)))
         (setq command (replace-regexp-in-string "%" (mapconcat 'identity (dired-get-marked-files) " ") command nil t))))
  (shell-command command output-buffer error-buffer))

(defun ocaml-make-command ()
  (interactive)
  (with-output-to-temp-buffer "*ocaml-compile*"
    (shell-command "./make")
    (pop-to-buffer "*ocaml-compile*"))

  (call-process-shell-command "./make" nil 0))

(defun jao-toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (if selective-display nil (or column 3))))

;; (defun projectile-regenerate-tags ()
;;   "Regenerate the project's etags."
;;   (interactive)
;;   (let* ((project-root (projectile-project-root))
;;          (tags-exclude (projectile-tags-exclude-patterns))
;;          (default-directory project-root))
;;     (shell-command (format projectile-tags-command tags-exclude project-root))
;;     (if (not (and (boundp 'gtags-mode) gtags-mode))
;;         (visit-tags-table project-root))))

(defun find-java-src ()
  (interactive)
  (er/mark-word)
  (let* ((project-root (locate-dominating-file (file-name-directory (buffer-file-name)) "project.clj"))
         (the-str (buffer-substring-no-properties (region-beginning) (region-end))))
    (if project-root
        (progn
          (grep-string-in the-str
                          (concat project-root "lib/sources"))
          (switch-to-grep)
          (sit-for 0.25)
          (search-forward (concat (expand-file-name project-root) "lib/sources/"))
          (compile-goto-error)
          (let* ((current-point (point)))
            (search-forward-regexp ".*\.jar")
            (switch-to-buffer (buffer-substring-no-properties current-point (point))))
          (search-forward the-str)
          (archive-extract))
      (message (concat "no project.clj found at or below " (buffer-file-name))))))

(define-key minibuffer-local-map [f3]
  (lambda () (interactive)
    (insert (buffer-name (window-buffer (minibuffer-selected-window))))))

(defun prelude-cleanup-on-save ()
  (add-hook 'before-save-hook #'prelude-cleanup-buffer-or-region))

(defun cider-eval-expression-at-point-in-repl ()
  (interactive)
  (let ((form (cider-sexp-at-point)))
    ;; Strip excess whitespace
    (while (string-match "\\`\s+\\|\n+\\'" form)
      (setq form (replace-match "" t t form)))
    (set-buffer (cider-find-or-create-repl-buffer))
    (goto-char (point-max))
    (insert form)
    (cider-repl-return)))

(defun remove-html ()
  (interactive)
  (goto-char 1)
  (while (search-forward-regexp "<[/]*[-_A-Za-z0-9]+>" nil t)
    (replace-match "" t nil)))

;; Append result of evaluating previous expression (Clojure):
(defun cider-eval-last-sexp-and-append ()
  "Evaluate the expression preceding point and append result."
  (interactive)
  (let ((last-sexp (cider-last-sexp)))
    ;; we have to be sure the evaluation won't result in an error
    (cider-eval-and-get-value last-sexp)
    (with-current-buffer (current-buffer)
      (insert "\n;; => "))
    (cider-interactive-eval-print last-sexp)))

(defun speak ()
  (interactive)
  (write-region (region-beginning) (region-end) "/tmp/speak_content_region")
  (call-process-shell-command "proxychains tts -f /tmp/speak_content_region" nil 0))

(defun speak-buffer ()
  (interactive)
  (write-region (point-min) (point-max) "/tmp/speak_content_buffer")
  (shell-command "proxychains tts -f /tmp/speak_content_buffer &"))

(defun clear-comint-buffer ()
  (interactive)
  (let ((old-max comint-buffer-maximum-size))
    (setq comint-buffer-maximum-size 0)
    (comint-truncate-buffer)
    (setq comint-buffer-maximum-size old-max)
    (goto-char (point-max))))

(provide 'ts-defuns)
