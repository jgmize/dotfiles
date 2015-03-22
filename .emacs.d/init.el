;;; This file is no longer used; in progress of converting
;;; to spacemacs -- see ~/.spacemacs

(require 'package)

(setq package-archives
  '( ;("gnu"         . "http://elpa.gnu.org/packages/")
    ("melpa"       . "http://melpa.milkbox.net/packages/")))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(cider
    clojure-mode
    evil
    evil-tabs
    jsx-mode
    markdown-mode
    paredit
    rainbow-delimiters
    yaml-mode))

(dolist (package my-packages)
  (when (not (package-installed-p package))
    (package-install package)))

(evil-mode)
(global-evil-tabs-mode t)
(elscreen-toggle-display-tab)
;;; esc ALWAYS quits
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'keyboard-quit)

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq column-number-mode t)
(global-rainbow-delimiters-mode)
(server-start)
