(global-set-key [f8] 'sr-speedbar-toggle)

(require 'speedbar)

;; imenu list
(add-to-list 'load-path "~/.emacs.d/personal/vendor/imenu-list")
(require 'imenu-list)


;; (setq speedbar-smart-directory-expand-flag t)

(setq sr-speedbar-auto-refresh nil)
(setq sr-speedbar-width 30)
(setq sr-speedbar-max-width 30)
(setq speedbar-use-images nil)

(custom-set-variables
 '(speedbar-show-unknown-files t)
 )

(setq speedbar-tag-hierarchy-method '(speedbar-simple-group-tag-hierarchy))

;; extensions
(speedbar-add-supported-extension ".clj")
(speedbar-add-supported-extension ".cljs")
(speedbar-add-supported-extension ".cljc")
(speedbar-add-supported-extension ".rs")
(speedbar-add-supported-extension ".edn")
(speedbar-add-supported-extension ".erl")
(speedbar-add-supported-extension ".hrl")
(speedbar-add-supported-extension ".beam")
(speedbar-add-supported-extension ".hs")
(speedbar-add-supported-extension ".c")
(speedbar-add-supported-extension ".cpp")
(speedbar-add-supported-extension ".rb")
(speedbar-add-supported-extension ".rake")
(speedbar-add-supported-extension ".js")
(speedbar-add-supported-extension ".cmm")
(speedbar-add-supported-extension ".html")
(speedbar-add-supported-extension ".erb")
(speedbar-add-supported-extension ".sql")
(speedbar-add-supported-extension ".sh")
(speedbar-add-supported-extension ".css")
(speedbar-add-supported-extension ".scss")
(speedbar-add-supported-extension ".yml")
(speedbar-add-supported-extension ".coffee")
(speedbar-add-supported-extension ".ts")
(speedbar-add-supported-extension ".json")
(speedbar-add-supported-extension ".jbuilder")
(speedbar-add-supported-extension ".slim")

(provide 'ts-speedbar)
