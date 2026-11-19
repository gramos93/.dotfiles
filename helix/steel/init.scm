(require-builtin steel/random as rand::)

(require "cogs/keymaps.scm")
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require "helix/configuration.scm")
(require "splash.scm")
(require "focus.scm")

;;;;;;;;;;;;;;;;;;;;;;;; Default modes ;;;;;;;;;;;;;;;;;;;;;;;

;; Enable the recentf snapshot, will watch every 2 minutes for active files,
;; and flush those down to disk
(recentf-snapshot)

;;;;;;;;;;;;;;;;;;;;;;;;;; Plugins ;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 1. Auto File Reloading (File Watcher)
;; This runs in the background automatically
(require "helix-file-watcher/file-watcher.scm")

(spawn-watcher)

;;;;;;;;;;;;;;;;;;;;;;;;;; Keybindings ;;;;;;;;;;;;;;;;;;;;;;;

;; To remove a binding, set it to 'no_op
;; For example, this will make it impossible to enter insert mode:
;; (hash "normal" (hash "i" 'no_op))
(keymap (global)
        (normal (C-r (f ":recentf-open-files")) (space (l ":load-buffer") (o ":eval-sexpr"))))

(define scm-keybindings (hash "insert" (hash "ret" ':scheme-indent "C-l" ':insert-lambda)))

;; Grab whatever the existing keybinding map is
(define standard-keybindings (deep-copy-global-keybindings))

(define file-tree-base (deep-copy-global-keybindings))

(merge-keybindings standard-keybindings scm-keybindings)
(merge-keybindings file-tree-base FILE-TREE-KEYBINDINGS)

;; <scratch> + <doc id> is probably the best way to handle this?
(set-global-buffer-or-extension-keymap (hash "scm" standard-keybindings FILE-TREE file-tree-base))

;;;;;;;;;;;;;;;;;;;;;;;;;; Options ;;;;;;;;;;;;;;;;;;;;;;;;;;;

(file-picker (fp-hidden #f))
(cursorline #t)
(soft-wrap (sw-enable #t))

;; New LSP definitions
(define-lsp "steel-language-server" (command "steel-language-server") (args '()))
(define-lsp "rust-analyzer" (config (experimental (hash 'testExplorer #t))))

;; New language definition
(define-language "scheme"
                 (formatter (command "raco") (args '("fmt" "-i")))
                 (auto-format #true)
                 (language-servers '("steel-language-server")))

(when (equal? (command-line) '("hx"))
  (show-splash))

;; Probably should be a symbol?
; (register-hook! 'post-insert-char 'prompt-on-char-press)


