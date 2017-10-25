(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(defmacro aif (&rest forms)
    "Create an anonymous interactive function.
    Mainly for use when binding a key to a non-interactive function."
    `(lambda () (interactive) ,@forms))

(defun backward-kill-word-or-region (prefix)
  "kill-region if active, otherwise backward-kill-word"
  (interactive "P")
  (if (and (mark) (use-region-p))
      (kill-region (min (point) (mark)) (max (point) (mark)))
    (backward-kill-word 1)))

(autoload 'zap-up-to-char "misc" "Kill up to, but not including ARGth occurrence of CHAR.")

(provide 'utility)
