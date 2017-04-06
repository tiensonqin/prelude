(auto-image-file-mode 1)

(defun image-mode-settings ()
  "Settings for `image-mode'."
  (define-key image-mode-map (kbd "'") 'switch-to-other-buffer))

(eval-after-load "image-mode"
  `(image-mode-settings))

(provide 'ts-image)
