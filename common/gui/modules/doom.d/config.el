;;(cua-mode +1)

(load-library "find-lisp")
(setq org-agenda-files
      (find-lisp-find-files "~/ownCloud/Personal/Org" "\.org$"))

(unless (org-kill-is-subtree-p tree)
  (user-error
   (substitute-command-keys
    "The kill is not a (set of) tree(s).  Use `\\[yank]' to yank anyway")))

