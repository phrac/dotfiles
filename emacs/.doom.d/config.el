;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name ""
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Hack Nerd Font" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-nord)

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)
(setq x-selection-timeout 10)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; org setting
(setq org-directory "~/notes")
(after! org
  (setq org-agenda-window-setup 'other-window)
  (setq org-id-locations-file "~/.doom.d/.state")
  (setq org-default-notes-file (concat org-directory "/refile.org"))
  (setq org-capture-templates
    '(("t" "New TODO" entry (file "refile.org")
       "* TODO %?\n  %i\n %T\n %a")
      ("b" "Buy Item" entry (file "refile.org")
       "* BUY %?\n  %i\n %T\n")
      ("s" "Sell Item" entry (file "refile.org")
       "* SELL %?\n  %i\n %T\n")
      ("p" "Project" entry (file "refile.org")
       "* PROJ %?\n  %i\n %T\n")
      ("n" "NOTE" entry (file+olp+datetree "refile.org")
       "* %?\nEntered on %U\n  %i %a")
      ("h" "Habit" entry (file "refile.org")
       "* TODO %?\n%U\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROJ(p@/!)" "WAIT(w@/!)" "|" "DONE(d@/!)" "CANCELED(c@)")
          (sequence "BUY(b)" "|" "BOUGHT(B@/!)" "CANCELED(c@)")
          (sequence "SELL(s)" "|" "SOLD(S@/!)" "CANCELED(c@)")
          ))
  (setq org-todo-keyword-faces
        (quote (("BUY" :foreground "orchid" :weight bold)
                ("BOUGHT" :foreground "purple")
                ("SELL" :foreground "tomato" :weight bold)
                ("SOLD" :foreground "rosy brown" :weight bold)
                ("PROJ" :foreground "deep pink" :weight bold)
                ("PHONE" :foreground "forest green" :weight bold))))
  )

;; org-journal settings
(use-package! org-journal
  :after org
  :custom
  (org-journal-dir "~/notes/journal")
  (org-journal-file-type 'monthly)
  )
       
;; org-roam settings
(use-package! org-roam
      :after org
      :hook (org-mode . org-roam-mode)
      :custom
      (org-roam-directory "~/notes/roam")
      :bind
      ("C-c n b" . org-roam--build-cache-async)
      ("C-c n l" . org-roam)
      ("C-c n t" . org-roam-today)
      ("C-c n f" . org-roam-find-file)
      ("C-c n i" . org-roam-insert)
      ("C-c n g" . org-roam-show-graph))

;; org-super-agenda settings
(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      ;org-agenda-block-separator nil
      org-agenda-compact-blocks nil
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("c" "Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Today"
                                  :time-grid t
                                  :date today
                                  :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '(
                            (:log t)
                            (:name "To refile"
                                   :file-path "refile\\.org")
                            (:name "Personal Buy/Sell"
                                   :and (:todo ("BUY" "SELL") :file-path "personal\\.org"))
                            (:name "Business Purchases"
                                   :and (:todo "BUY" :file-path "business\\.org"))
                            (:name "Important"
                                   :priority "A"
                                   :order 6)
                            (:name "Low Effort Tasks"
                                   :effort< "0:11")
                            (:name "Time consuming Tasks"
                                   :effort> "00:59")
                            (:name "Scheduled Soon"
                                   :scheduled future
                                   :order 8)
                            (:name "Overdue"
                                   :deadline past
                                   :order 2)
                            (:name "Meetings"
                                   :and (:todo "MEET" :scheduled future)
                                   :order 10)
                            ;(:discard (:not (:todo "TODO")))
                            ))))))))
  :config
  (org-super-agenda-mode))
