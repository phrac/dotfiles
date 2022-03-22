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
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 20))

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
                                        ;(setq org-agenda-files '("~/notes/roam/todo.org"))
(after! org
  ;;  (add-to-list 'org-file-apps  '("\\.pdf" . "mupdf %s"))
  (setq org-agenda-window-setup 'other-window)
  (setq org-id-locations-file "~/.doom.d/.state")
  (setq org-default-notes-file (concat org-directory "~/refile.org"))
  (setq org-capture-templates
        '(("t" "New TODO" entry (file "~/notes/roam/todo.org")
           "* TODO %?\n+ Added: %U")
          ("w" "New Work Order" entry (file "~/notes/roam/todo.org")
           "* W/O %?\n %i\n")
          ("b" "Buy Item" entry (file "~/notes/roam/todo.org")
           "* BUY %?\n  %i\n")
          ("s" "Sell Item" entry (file "~/notes/roam/todo.org")
           "* SELL %?\n  %i\n")
          ("p" "Project" entry (file "~/notes/roam/todo.org")
           "* PROJ %?\n  %i\n")
          ("m" "Schedule Meeting" entry (file "~/notes/roam/todo.org")
           "* MEET %?\n %i\n")))
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n@/!)" "PROJ(p@/!)" "WAIT(w@/!)" "ASSIGNED(a@/!)" "W/O(o@/!)" "MEET(m@/!)" "|" "DONE(d@/!)" "MET(M@/!)" "CANCELED(c@/!)")
          (sequence "BUY(b)" "|" "BOUGHT(B@/!)" "CANCELED(c@)")
          (sequence "SELL(s)" "LISTED(l@/!)" "|" "SOLD(S@/!)" "CANCELED(c@)")
          (sequence "HABIT(h)" "|" "DONE(H@/!)")
          ))
  (setq org-todo-keyword-faces
        (quote (("BUY" :foreground "orchid" :weight bold)
                ("BOUGHT" :foreground "purple" :weight bold)
                ("WAIT" :foreground "goldenrod1" :weight bold)
                ("SELL" :foreground "tomato" :weight bold)
                ("LISTED" :foreground "rosy brown" :weight bold)
                ("SOLD" :foreground "sienna brown" :weight bold)
                ("PROJ" :foreground "deep pink" :weight bold)
                ("ASSIGNED" :foreground "spring green" :weight bold)
                ("W/O" :foreground "magenta" :weight bold)
                ("NEXT" :foreground "deep sky blue" :weight bold)
                ("MEET" :foreground "forest green" :weight bold))))
  (setq org-capture-bookmark nil)
  )


;; deft settings
(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/notes")
  (deft-use-filename-as-title t))

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
                            (:name "Due Today"
                             :date today
                             :order 1)
                            (:name "Next Tasks"
                             :todo "NEXT"
                             :order 0)
                            (:name "On Hold"
                             :todo "WAIT"
                             :order 6)
                            (:name "Marketplace"
                             :todo ("BUY" "SELL" "LISTED")
                             :order 4)
                            (:name "Assigned/Not Complete"
                             :todo ("ASSIGNED")
                             :order 5)
                            (:name "Important"
                             :priority "A"
                             :order 3)
                            (:name "Low Effort Tasks (< 1 hour)"
                             :effort< "00:59")
                            (:name "Medium Effort Tasks (1-3 hours)"
                             :and (:effort> "00:59" :effort< "03:00"))
                            (:name "High Effort Tasks (> 3 hours)"
                             :effort> "03:00")
                            (:name "Upcoming Meetings"
                             :todo ("MEET")
                             :order 3)
                            (:name "Scheduled Soon"
                             :scheduled future
                             :order 3)
                            (:name "Overdue"
                             :deadline past
                             :order 2)
                            (:name "Unfinished Projects"
                             :todo "PROJ"
                             :order 5)
                            (:discard (:not (:todo "TODO")))
                            ))))))

          ("b" "Business Super view"
           ((agenda "" ((org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "Today"
                            :time-grid t
                            :and (:date today :file-path "business\\.org")
                            :order 1)))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '(
                            (:log t)
                            (:name "Due Today"
                             :and (:date today :file-path "business\\.org")
                             :order 1)
                            (:name "To refile"
                             :file-path "refile\\.org"
                             :order 2)
                            (:name "Upcoming Meetings"
                             :and (:todo "MEET" :file-path "business\\.org")
                             :order 2
                             )
                            (:name "Work Orders"
                             :and (:todo "W/O" :file-path "business\\.org")
                             :order 2)
                            (:name "On Hold"
                             :and (:todo "WAIT" :file-path "business\\.org")
                             :order 6)
                            (:name "Assigned Tasks"
                             :and (:todo "ASSIGNED" :file-path "business\\.org")
                             )
                            (:name "Business Purchases"
                             :and (:todo "BUY" :file-path "business\\.org")
                             )
                            (:name "Important"
                             :and (:priority "A" :file-path "business\\.org")
                             :order 3)
                            (:name "Low Effort Tasks"
                             :and (:effort< "0:11" :file-path "business\\.org")
                             )
                            (:name "High Effort Tasks"
                             :and (:effort> "00:29" :file-path "business\\.org")
                             )
                            (:name "Scheduled Soon"
                             :and (:scheduled future :file-path "business\\.org")
                             :order 3)
                            (:name "Overdue"
                             :and (:deadline past :file-path "business\\.org")
                             :order 0)
                            (:name "Meetings"
                             :and (:todo "MEET" :scheduled future :file-path "business\\.org")
                             :order 10)
                            (:name "Unfinished Business Projects"
                             :and (:todo "PROJ" :file-path "business\\.org")
                             :order 5)
                            (:discard (:not(:file-path "business\\.org")))
                            ))))))
          ))
  :config
  (org-super-agenda-mode))
(setq org-agenda-prefix-format '(
                                 ;; (agenda  . " %i %-12:c%?-12t% s") ;; file name + org-agenda-entry-type
                                 (agenda  . "• %i %-12:c%?-12t% s")
                                 (timeline  . "• %i %-12:c%?-12t% s")
                                 (todo  . " • %-12:c%?-12t% s")
                                 (tags  . " • %-12:c%?-12t% s")
                                 (search . " • %-12:c%?-12t% s")))
                                        ;(use-package arduino-mode
                                        ;            :init
                                        ;             (setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist))
                                        ;        (autoload 'arduino-mode "arduino-mode" "Arduino editing mode." t)
                                        ;        )

;; org-roam settings
;;
(setq org-roam-capture-templates '(
                                   ("p" "Project" plain "* Goals\n\n%?\n\n* Tasks\n\n** TODO Add initial tasks\n\n* Dates\n\n"
                                    :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+category: ${title}\n#+filetags: Project")
                                    :unnarrowed t)
                                   ("d" "Default" plain "%?"
                                    :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                       "#+title: ${title}\n#+category: ${title}\n")
                                    :unnarrowed t)
                                   ("c" "Contact" plain "%?"
                                    :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                                                       "#+title: ${title}\n#+category: ${title}\n
                     \n* Details\n- Title:\n- Company:\n- Phone:\n- Email:\n")
                                    :unnarrowed t)
                                   )
      )

;; Build agendas from org-roam files
(after! org-roam
  (defun my/org-roam-filter-by-tag (tag-name)
    (lambda (node)
      (member tag-name (org-roam-node-tags node))))

  (defun my/org-roam-list-notes-by-tag (tag-name)
    (mapcar #'org-roam-node-file
            (seq-filter
             (my/org-roam-filter-by-tag tag-name)
             (org-roam-node-list))))

  (defun my/org-roam-refresh-agenda-list ()
    (interactive)
    (setq org-agenda-files (nconc
                            (my/org-roam-list-notes-by-tag "Project")
                            (my/org-roam-list-notes-by-tag "Tasks")))
    )

  ;; Build the agenda list the first time for the session
  (my/org-roam-refresh-agenda-list)

  ;; copy DONE tasks to dailies
  (defun my/org-roam-copy-todo-to-today ()
    (interactive)
    (let ((org-refile-keep t) ;; Set this to nil to delete the original!
          (org-roam-dailies-capture-templates
           '(("t" "tasks" entry "%?"
              :if-new (file+head+olp "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n" ("Tasks")))))
          (org-after-refile-insert-hook #'save-buffer)
          today-file
          pos)
      (save-window-excursion
        (org-roam-dailies--capture (current-time) t)
        (setq today-file (buffer-file-name))
        (setq pos (point)))

      ;; Only refile if the target file is different than the current file
      (unless (equal (file-truename today-file)
                     (file-truename (buffer-file-name)))
        (org-refile nil nil (list "Tasks" today-file nil pos)))))

  (add-to-list 'org-after-todo-state-change-hook
               (lambda ()
                 (cond
                  ((or
                    (equal org-state "DONE")
                    (equal org-state "MET")
                    (equal org-state "BOUGHT"))))
                 (my/org-roam-copy-todo-to-today)))

  )

;; refile to roam targets
(setq myroamfiles (directory-files "~/notes/roam" t "org$"))

;; -------- refile settings -----
(setq org-refile-targets '((org-agenda-files :maxlevel . 5) (myroamfiles :maxlevel . 5)))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-allow-creating-parent-nodes 'confirm)

;; org-roam-ui settings
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))
;; openwith
(use-package! openwith
  :config
  (openwith-mode t)
  (setq openwith-associations
            (list
             (list (openwith-make-extension-regexp
                    '("mpg" "mpeg" "mp3" "mp4"
                      "avi" "wmv" "wav" "mov" "flv"
                      "ogm" "ogg" "mkv" "gif"))
                   "mpv"
                   '(file))
             (list (openwith-make-extension-regexp
                    '("xbm" "pbm" "pgm" "ppm" "pnm"
                      "png" "bmp" "tif" "jpeg" "jpg"))
                   "sxiv"
                   '(file))
             (list (openwith-make-extension-regexp
                    '("doc" "xls" "ppt" "odt" "ods" "odg" "odp"))
                   "libreoffice"
                   '(file))
             ))
  )
