(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(defmacro aif (&rest forms)
    "Create an anonymous interactive function.
    Mainly for use when binding a key to a non-interactive function."
    `(lambda () (interactive) ,@forms))

(provide 'utility)
