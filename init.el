(menu-bar-mode -1)
(setq inhibit-startup-message t)

(show-paren-mode 1)

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default
 column-number-mode t
 buffers-menu-max-size 30
 indent-tabs-mode nil
 delete-selection-mode t
 make-backup-files nil
 set-mark-command-repeat-pop t
 truncate-lines nil
 show-trailing-whitespace t)

(add-to-list 'load-path "~/.emacs.d/lib")
(setq custom-theme-load-path (list "~/.emacs.d/lib"))

(load-theme 'night t)

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
(global-set-key (kbd "C-c i") (lambda () (interactive) (find-file "~/.emacs.d/init.el")))
(global-set-key (kbd "C-j") 'newline)

(ido-mode t)
(setq ido-enable-flex-matching t)

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


(setq package-enable-at-startup nil)
(package-initialize)

(add-to-list 'package-archives `("melpa" . "http://melpa.org/packages/"))

(require 'use-package)

(use-package paredit
  :ensure t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
    (add-hook 'clojure-mode-hook 'paredit-mode)
    (add-hook 'clojurescript-mode-hook 'paredit-mode)
    (add-hook 'clojurec-mode-hook 'paredit-mode)
    (add-hook 'cider-repl-mode-hook 'paredit-mode)))
(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'"))
(use-package clojure-mode
  :ensure t
  :mode ("\\.edn\\'")
  :config
  (progn
    (use-package cider :ensure t)
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ess rainbow-delimiters rainbow-delimiters-mode rainbow-delimters-mode clj-refactor cider markdown-mode yaml-mode clojure-mode js2-mode true))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
