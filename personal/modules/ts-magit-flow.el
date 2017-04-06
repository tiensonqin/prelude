;;; magit-flow.el --- git-flow plug-in for Magit

;; Copyright (C) 2012  Phil Jackson

;; Magit is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; Magit is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with Magit.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This plug-in provides git-flow functionality as a separate
;; component of Magit. Only supports `feature' commands at the moment.

;;; Code:

(require 'magit)
(eval-when-compile
  (require 'cl))

(defun magit-run-git-flow (&rest args)
  (apply 'magit-run-git (cons "flow" args)))

(defun magit-run-git-lines-flow (&rest args)
  (apply 'magit-git-lines (cons "flow" args)))

(defun magit-flow-init ()
  (interactive)
  (magit-run-git-flow "init" "-d")
  (magit-process))

(defun magit-flow-feature-create ()
  (interactive)
  (let ((name (read-string "Create feature branch: ")))
    (magit-run-git-flow "feature" "start" name)))

(defun magit-flow-feature-list-inner ()
  "List the feature branches managed by flow."
  (let ((current-feature nil)
        (all-features nil))
    (dolist (name (magit-run-git-lines-flow "feature" "list"))
      ;; is this the branch we're on
      (when (string-match "^\\* \\(.+\\)$" name 0)
        (setq current-feature (match-string 1 name)))
      ;; clean and append this line
      (let ((clean-name (replace-regexp-in-string "^\\*? +\\(.+\\)" "\\1" name)))
        (setq all-features (nconc all-features (list clean-name)))))
    (cons current-feature all-features)))

(defun magit-flow-feature-list ()
  (interactive)
  (magit-run-git-flow "feature" "list")
  (magit-process))

(defun magit-flow-feature-publish ()
  (interactive)
  (let* ((all (magit-flow-feature-list-inner))
         (current (car all))
         (names (cdr all))
         (name (magit-completing-read "feature to publish: " names nil t current)))
    (magit-run-git-flow "feature" "publish" name)
    (magit-process)))

(defun magit-flow-feature-finish ()
  (interactive)
  (let* ((all (magit-flow-feature-list-inner))
         (current (car all))
         (names (cdr all))
         (name (magit-completing-read "Branch to finish: " names nil t current)))
    (magit-run-git-flow "feature" "finish" name)
    (magit-process)))

(defun magit-flow-feature-diff ()
  (let ((dir default-directory)
        (buf (get-buffer-create "*magit-diff*")))
    (display-buffer buf)
    (with-current-buffer buf
      (magit-mode-init dir
                       'magit-diff-mode
                       '(lambda ()
                          (magit-create-buffer-sections
                           (magit-git-section 'diffbuf
                                              "Divergence from develop:"
                                              'magit-wash-diffs
                                              "flow" "feature" "diff")))))))
(defun magit-flow-release-list-inner ()
  "List the release branches managed by flow."
  (let ((current-release nil)
        (all-releases nil))
    (dolist (name (magit-run-git-lines-flow "release" "list"))
      ;; is this the branch we're on
      (when (string-match "^\\* \\(.+\\)$" name 0)
        (setq current-release
              (match-string 1 name)))
      ;; clean and append this line
      (let ((clean-name (replace-regexp-in-string "^\\*? +\\(.+\\)" "\\1" name)))
        (setq all-releases (nconc all-releases (list clean-name)))))
    (cons current-release all-releases)))

(defun magit-flow-release-list ()
  "List the release branches managed by flow."
  (interactive)
  (magit-run-git-flow "release" "list")
  (magit-process))

(defun magit-flow-release-start ()
  "Start new release."
  (interactive)
  (let ((name (read-string ":Start release branch: ")))
    (magit-run-git-flow "release" "start" name)))

(defun magit-flow-release-finish ()
  (interactive)
  (let* ((all (magit-flow-release-list-inner))
         (current (car all))
         (names (cdr all))
         (name (magit-completing-read "Release to finish: " names nil t current)))
    (magit-run-git-flow "release" "finish" "-mp" name) ; push to both master and develop branches, remove remote branch
    (magit-process)))

(defun magit-flow-release-publish ()
  (interactive)
  (let* ((all (magit-flow-release-list-inner))
         (current (car all))
         (names (cdr all))
         (name (magit-completing-read "Release to publish: " names nil t current)))
    (magit-run-git-flow "release" "publish" name)
    (magit-process)))

(defun magit-flow-release-track ()
  (interactive)
  (let* ((all (magit-flow-release-list-inner))
         (current (car all))
         (names (cdr all))
         (name (magit-completing-read "Release to track: " names nil t current)))
    (magit-run-git-flow "release" "track" name)
    (magit-process)))

(defun magit-flow-hotfix-list-inner ()
  "List the hotfix branches managed by flow."
  (let ((current-hotfix nil)
        (all-hotfixs nil))
    (dolist (name (magit-run-git-lines-flow "hotfix" "list"))
      ;; is this the branch we're on
      (when (string-match "^\\* \\(.+\\)$" name 0)
        (setq current-hotfix
              (match-string 1 name)))
      ;; clean and append this line
      (let ((clean-name (replace-regexp-in-string "^\\*? +\\(.+\\)" "\\1" name)))
        (setq all-hotfixs (nconc all-hotfixs (list clean-name)))))
    (cons current-hotfix all-hotfixs)))

(defun magit-flow-hotfix-list ()
  "List the hotfix branches managed by flow."
  (interactive)
  (magit-run-git-flow "hotfix" "list")
  (magit-process))

(defun magit-flow-hotfix-start ()
  "Start new hotfix."
  (interactive)
  (let ((name (read-string ":Start hotfix branch: ")))
    (magit-run-git-flow "hotfix" "start" name)))

(defun magit-flow-hotfix-finish ()
  (interactive)
  (let* ((all (magit-flow-hotfix-list-inner))
         (current (car all))
         (names (cdr all))
         (name (magit-completing-read "Hotfix to finish: " names nil t current)))
    (magit-run-git-flow "hotfix" "finish" "-mp" name) ; push to both master and develop branches, remove remote branch
    (magit-process)))

;; (defvar magit-flow-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "o") 'magit-key-mode-popup-flow)
;;     map))

;;;###autoload
(define-minor-mode magit-flow-mode "FLOW support for Magit"
  :lighter " F"
  :require 'magit-flow)

;;;###autoload
(defun turn-on-magit-flow ()
  "Unconditionally turn on `magit-flow-mode'."
  (magit-flow-mode 1)
  (define-key magit-mode-map (kbd ";") 'magit-key-mode-popup-flow))

;; add the group and its keys
(progn
  ;; (re-)create the group
  (magit-key-mode-add-group 'flow)

  (magit-key-mode-insert-action
   'flow
   "i"
   "Init"
   'magit-flow-init)

  (magit-key-mode-insert-action
   'flow
   "fl"
   "List features"
   'magit-flow-feature-list)

  (magit-key-mode-insert-action
   'flow
   "fn"
   "Create feature"
   'magit-flow-feature-create)

  (magit-key-mode-insert-action
   'flow
   "fp"
   "Publish feature"
   'magit-flow-feature-publish)

  (magit-key-mode-insert-action
   'flow
   "ff"
   "Finish feature"
   'magit-flow-feature-finish)

  (magit-key-mode-insert-action
   'flow
   "rl"
   "List releases"
   'magit-flow-release-list)

  (magit-key-mode-insert-action
   'flow
   "rs"
   "Start release"
   'magit-flow-release-start)

  (magit-key-mode-insert-action
   'flow
   "rf"
   "Finish release"
   'magit-flow-release-finish)

  (magit-key-mode-insert-action
   'flow
   "rp"
   "Publish release"
   'magit-flow-release-publish)

  (magit-key-mode-insert-action
   'flow
   "rt"
   "Track release"
   'magit-flow-release-track)

  (magit-key-mode-insert-action
   'flow
   "hl"
   "List hotfixs"
   'magit-flow-hotfix-list)

  (magit-key-mode-insert-action
   'flow
   "hs"
   "Start hotfix"
   'magit-flow-hotfix-start)

  (magit-key-mode-insert-action
   'flow
   "hf"
   "Finish hotfix"
   'magit-flow-hotfix-finish)

  ;; generate and bind the menu popup function
  (magit-key-mode-generate 'flow))

(provide 'ts-magit-flow)
;;; magit-flow.el ends here
