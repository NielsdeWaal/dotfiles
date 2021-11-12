;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;(setq doom-font (font-spec :family "monospace" :size 12))
(setq doom-font (font-spec :family "mononoki Nerd Font" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'modus-vivendi)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq-default tab-width 4)

(setq undo-limit 80000000
      evil-want-fine-undo t
      auto-save-default t
      )

(delete-selection-mode 1)

;; Org mode configuration

;; (use-package! org-cliplink)

;; (use-package! org-cliplink
;;   :bind ("C-x p i" . org-cliplink))

;; Hide emphasis markers like * and _
(setq org-hide-emphasis-markers t)
;; Refresh images after running src block
;; (eval-after-load 'org
;;   (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images))

;; (setq org-capture-templates '(("t" "TODO [inbox]" entry
;;                                (file+headline "~/gtd/inbox.org" "Tasks")
;;                                "* TODO %i%?")
;;                               ("l" "org-procol-capture" entry
;;                                (file "~/gtd/inbox.org")
;;                                "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)
;;                               ("n" "Take a note")
;;                               ("nl" "Note link" entry
;;                                (file+headline "~/gtd/inbox.org" "Resources")
;;                                "* %(org-cliplink-capture) \n %i\n" :empty-lines 1)
;;                               ("nn" "Note" entry
;;                                (file+headline "~/gtd/inbox.org" "Resources")
;;                                "* NOTE \n %i\n" :empty-lines 1)
;;                                )
;;                               )

;; GTD workflow
(setq org-agenda-files (list "~/gtd/inbox.org"
                             "~/gtd/todo.org"
                             "~/gtd/Resources.org"))
(setq org-refile-targets '(("~/gtd/gtd.org" :maxlevel . 3)
                           ("~/gtd/someday.org" :level . 1)
                           ("~/gtd/tickler.org" :maxlevel . 2)))
(setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/gtd/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/gtd/tickler.org" "Tickler")
                               "* %i%? \n %U")))
;; (setq org-capture-templates
;;         '(("t" "TODO [inbox]" entry
;;         (file+headline "~/gtd/inbox.org" "Tasks")
;;         "* TODO %i%?")
;;         ("T" "Tickler" entry
;;         (file-headline "~/gtd/tickler.org" "Tickler")
;;         "I %i%? \n %U")
;;         ("l" "org-procol-capture" entry
;;         (file "~/gtd/inbox.org")
;;         "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)
;;         ("n" "Take a note")
;;         ("nl" "Note link" entry
;;         (file+headline "~/gtd/inbox.org" "Resources")
;;         "* %(org-cliplink-capture) \n %i\n" :empty-lines 1)
;;         ("nn" "Note" entry
;;         (file+headline "~/gtd/inbox.org" "Resources")
;;         "* NOTE \n %i\n" :empty-lines 1)
;;         ))

;; (setq org-refile-targets '((("~/gtd/todo.org" "~/gtd/Projects.org" "~/gtd/Resources.org") :maxlevel . 3)))

;; Org roam
(after! org-roam
  (require 'org-roam-protocol)
  (setq org-roam-capture-ref-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "websites/${slug}"
           :head "#+TITLE: ${title}
#+ROAM_KEY: ${ref}
- source :: ${ref}"
           :unnarrowed t))))

;; (defun make-capture-frame (&optional capture-url)
;;   "Create a new frame and run org-capture."
;;   (interactive)
;;   (make-frame '((name . "CAPTURE")
;;                 (width . 120)
;;                 (height . 15)))
;;   (select-frame-by-name "CAPTURE")
;;   (setq word-wrap 1)
;;   (setq truncate-lines nil)
;;   (if capture-url (org-protocol-capture capture-url) (org-protocol-capture)))

;; (org-roam-protocol-open-ref "org-protocol://roam-ref?ref='+aaaaa+'&title='+bbbbbbb")
;; (org-protocol-capture "org-protocol://roam-ref?ref='+aaaaa+'&title='+bbbbbbb")
;; (org-roam-protocol-open-file)
;; (defun make-roam-capture-frame (&optional capture-url)
;;   "Create a new frame and run org-capture."
;;   (interactive)
;;   (make-frame '((name . "CAPTURE")
;;                 (width . 120)
;;                 (height . 15)))
;;   (select-frame-by-name "CAPTURE")
;;   (setq word-wrap 1)
;;   (setq truncate-lines nil)
;;   (if capture-url (org-roam-protocol-open-ref capture-url) (org-roam-protocol-open-file)))

;; (defadvice org-roam-pro)

;; (use-package org-roam-protocol
;;   :after org-protocol)
;; (use-package! org-roam
;;   :commands (org-roam-insert org-roam-find-file org-roam)
;;   :init
;;   (setq org-roam-buffer-width 0.1)
;;   (map! :leader
;;         :prefix "n"
;;         :desc "Org-Roam-Insert" "i" #'org-roam-insert
;;         :desc "Org-Roam-Find"   "/" #'org-roam-find-file
;;         :desc "Org-Roam-Buffer" "r" #'org-roam)
;;   )


(setq mu4e-maildir "~/Mail")
(set-email-account! "nielsdwaal"
                    '((user-mail-address . "nielsdwaal@gmail.com")
                      (user-full-name . "Niels de Waal")
                      (smtpmail-smtp-server . "smtp.gmail.com")
                      (smtpmail-smtp-service . 465)
                      (smtpmail-stream-type . ssl)
                      (mu4e-sent-folder . "/Verzonden")
                      (mu4e-drafts-folder . "/Concepten")
                      (mu4e-trash-folder . "/Prullenbak")
                      (mu4e-refile-folder . "/All Mail"))
                    t)

;; In order to get src highlighting to work in org pdf exports
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq magit-process-password-prompt-regexps
      '("^\\(Enter \\)?[Pp]assphrase\\( for \\(RSA \\)?key '.*'\\)?: ?$"
        ;; match-group 99 is used to identify a host
        "^\\(Enter \\)?[Pp]assword\\( for '\\(?99:.*\\)'\\)?: ?$"
        "^.*'s password: ?$"
        "^Yubikey for .*: ?$"
        "^Enter PIN for '.*': ?$"))

(setenv "KEYID"
        "0x0F87C4C2C61A99111A92A1C75772008B324C463F")
(setenv "SSH_AUTH_SOCK"
        "/run/user/1000/gnupg/S.gpg-agent.ssh")

(require 'elfeed-goodies)
(elfeed-goodies/setup)
(setq elfeed-goodies/entry-pane-size 0.5)
(setq elfeed-feeds (quote
                    (("http://feeds.feedburner.com/tweakers/nieuws" tweakers))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ipython . t)
   (clojure . t)
   ))

;; (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;; Uncomment this for colemak layout
;; (setq avy-keys '(?a ?r ?s ?t ?g ?m ?n ?e ?i ?o))

;; (add-hook! 'c-mode-hook
;;            (unless (locate-dominating-file default-directory ".clang-format")
;;              (format-all-mode -1)
;;              (setq-hook! +format-with-lsp nil)))

;; (setq-hook! 'c-mode-hook +format-with-lsp nil)

;; LSP
(setq lsp-ui-doc-enable nil)
