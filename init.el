(menu-bar-mode -1)
(show-paren-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default
 column-number-mode t
 inhibit-startup-message t
 indent-tabs-mode nil
 buffers-menu-max-size 30
 indent-tabs-mode nil
 delete-selection-mode t
 make-backup-files nil
 set-mark-command-repeat-pop t
 truncate-lines nil
 vc-follow-symlinks nil
 ring-bell-function 'ignore
 inferior-lisp-program "sbcl"
 slime-contribs '(slime-fancy)
 scroll-step 1
 scroll-conservatively 10000
 c-basic-offset 2
 tab-width 2
 ns-use-native-fullscreen nil
 custom-theme-load-path (list "~/.emacs.d/lib")
 custom-file "~/.emacs.d/custom.el"
 backup-directory-alist `((".*" . ,temporary-file-directory))
 auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(load-theme 'night t)
(load custom-file 'noerror)

(add-to-list 'load-path "~/.emacs.d/lib")
(require 'utility)

(if (display-graphic-p)
    (progn
      (add-to-list 'default-frame-alist '(alpha . (90 . 90)))
      (add-to-list 'default-frame-alist '(height . 40))
      (add-to-list 'default-frame-alist '(width . 100))
      (scroll-bar-mode -1)
      (tool-bar-mode -1)
      (blink-cursor-mode -1)
      (tooltip-mode nil)
      (if (eq system-type 'darwin)
          (set-frame-font "Inconsolata Bold 16")
        (set-frame-font "Inconsolata Bold 19"))))

(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-c i") (aif (find-file "~/.emacs.d/init.el")))
(global-set-key (kbd "C-j") 'newline)
(global-set-key (kbd "M-g") 'mark-paragraph)
(global-set-key (kbd "M-k") 'paredit-forward-barf-sexp)
(global-set-key (kbd "M-l") 'paredit-forward-slurp-sexp)
(global-set-key (kbd "M-j") (aif (next-line) (join-line)))
(global-set-key (kbd "M-RET") 'toggle-frame-fullscreen)
(global-set-key (kbd "M-'") 'ido-find-in-project)
(global-set-key (kbd "C-c l") 'magit-log-head)
(global-set-key (kbd "C-c 1") (aif (set-frame-size (selected-frame) 160 50)))
(global-set-key (kbd "C-c 2") (aif (set-frame-size (selected-frame) 100 40)))
(global-set-key (kbd "M-RET") 'toggle-frame-fullscreen)

(defun code-hook ()
  (setq-local show-trailing-whitespace t))

(dolist (hook
         '(ruby-mode-hook
           clojure-mode-hook
           emacs-lisp-mode-hook))
  (add-hook hook 'code-hook))

(ido-mode t)
(setq ido-enable-flex-matching t)

(defun bind-ido-keys ()
  "Keybindings for ido mode."
  (define-key ido-completion-map (kbd "`") 'ido-exit-minibuffer)
  (define-key ido-completion-map (kbd "C-w") 'ido-delete-backward-word-updir)
  (define-key ido-completion-map (kbd "SPC") 'ido-exit-minibuffer)
  (define-key ido-completion-map (kbd "TAB") 'ido-exit-minibuffer))
(add-hook 'ido-setup-hook #'bind-ido-keys)

(defun ido-find-in-project ()
  (interactive)
  (save-excursion
    (let ((git-root (shell-command-to-string
                     "echo -ne $(git rev-parse --show-toplevel || echo \".\")"))
          (enable-recursive-minibuffers t))
      (find-file
       (concat
        git-root
        "/"
        (ido-completing-read
         ">>> "
         (split-string
          (shell-command-to-string
           (concat "cd " git-root " && git ls-files")) "\n")
         nil
         t))))))

(defun compile-in-project ()
  (interactive)
  (let ((default-directory (shell-command-to-string
                            "echo -ne $(git rev-parse --show-toplevel || echo \".\")")))
    (call-interactively #'compile)))

(setq package-enable-at-startup nil)
(package-initialize)

(add-to-list 'package-archives `("melpa" . "http://melpa.org/packages/"))

(require 'use-package)

(use-package diminish :ensure t)
(use-package ag :ensure t)
(use-package inf-ruby :ensure t)
(use-package company :ensure t :diminish company-mode)
(use-package go-mode :ensure t)
(use-package js2-mode :ensure t :mode ("\\.js\\'"))
(use-package paredit
  :ensure t
  :diminish paredit-mode
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
    (add-hook 'lisp-mode-hook 'paredit-mode)
    (add-hook 'clojure-mode-hook 'paredit-mode)
    (add-hook 'clojurescript-mode-hook 'paredit-mode)
    (add-hook 'clojurec-mode-hook 'paredit-mode)
    (add-hook 'cider-repl-mode-hook 'paredit-mode)
    (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
    (add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))))
(use-package slime :ensure t)
(use-package clojure-mode
  :ensure t
  :mode ("\\.edn\\'")
  :config
  (progn
    (use-package cider
      :ensure t
      :config (setq cider-boot-parameters "dev")
      :bind (("C-]" . cider-find-dwim)
             ;; ("C-c r" . (cider-run "(user/reset"))
             ("C-c b" . cider-eval-buffer)))
    (use-package clj-refactor :ensure t)))
(use-package ess
  :ensure t
  :init (require 'ess-site)
  :config
  (progn
    (ess-toggle-underscore nil)
    (setq ess-r-package-auto-activate nil
          ess-r-package-auto-set-evaluation-env nil)))
(use-package yaml-mode :ensure t :mode ("\\.yml$" . yaml-mode))
(use-package markdown-mode
  :ensure t
  :mode (("\\.markdown$" . markdown-mode)
         ("\\.md$" . markdown-mode))
  :init (add-hook 'markdown-mode-hook 'auto-fill-mode))
(use-package magit :ensure t)
(use-package rainbow-mode
  :ensure t
  :config (add-hook 'css-mode-hook 'rainbow-mode))
(use-package rainbow-delimiters :ensure t)

(if window-system (set-exec-path-from-shell-PATH))
