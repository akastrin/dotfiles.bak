;; ---------------------------------------------------------------
;; init.el emacs configuration file
;; author  Andrej Kastrin
;; ---------------------------------------------------------------

;; Identification
(setq user-full-name "Andrej Kastrin")
(setq user-mail-address "andrej.kastrin@gmail.com")

;; Package management
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
	     
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Disable toolbar
(tool-bar-mode -1)

;; Backups at .saves folder in the current folder
(setq backup-by-copying t      ; don't clobber symlinks
      backup-directory-alist
      '(("." . "~/.emacs.d/backup/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Bar cursor
(setq-default cursor-type '(bar . 1))
;; Don't blink the cursor
(blink-cursor-mode -1)


;; Display column number
(setq column-number-mode t)

;; Set default fonts
;;(add-to-list 'default-frame-alist
;;	     '(font . "monaco-12"))

;; Auto fill mode (wraps line automatically)
(setq-default fill-column 78)
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'turn-on-auto-fill)

(use-package fill-column-indicator
  :ensure t
  :config
  (setq fci-rule-color "red")
  (setq fci-rule-column 80)
  (setq fci-rule-width 5))

;; Theme management
;(use-package zenburn-theme
;  :ensure t
;  :config
;  (load-theme 'zenburn t))

(use-package moe-theme
  :ensure t
  :config
  (moe-light))

;; AUCTeX
(use-package tex-mode
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (add-hook 'LaTeX-mode-hook 'visual-line-mode)
  (setq TeX-PDF-mode t)
  )

(use-package latex-preview-pane
  :ensure t
  ;:config
  ;; (add-hook 'LaTeX-mode-hook 'latex-preview-pane-mode)
)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

;; ESS
;;;(setq ess-write-to-dribble nil)
;;(require 'ess-site)

;;;(use-package ess-site
;;;  :init(require 'ess-site)
;  ;;:commands R
;  ;;:init (require 'ess-site)
;;;  :mode (("\\.[rR]\\'" . R-mode)
;;;         ;;("\\.Rnw\\'" . Rnw-mode)
;;;	 )
;;;  :bind
;;;  (:map ess-r-mode-map
;;;	("_" . ess-insert-assign))
;;;  (:map inferior-ess-r-mode-map
;;;	("_" . ess-insert-assign))
;;;  :config
;;;  (setq ess-default-style 'RStudio-)
;;;)
;; (use-package ess
;;   :init (require 'ess-site)
;;   :mode (("\\.[rR]\\'" . R-mode)
;;          ("\\.Rnw\\'" . Rnw-mode))
;; )

(use-package ess
  :ensure t
  :init (require 'ess-site))

;;(custom-set-variables
;; '(markdown-command "/usr/bin/pandoc"))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "pandoc"))




(use-package polymode
  :ensure markdown-mode
  :ensure poly-R
  :ensure poly-noweb
  :config
  ;; R/tex polymodes
  (add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
  (add-to-list 'auto-mode-alist '("\\.rnw" . poly-noweb+r-mode))
  (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
  ;; org-mode poly (not working at the moment)
  ;; (add-to-list 'auto-mode-alist '("\\.org" . poly-org-mode))
  ;; Make sure r-mode is loaded
  ;; (autoload 'r-mode "ess-site.el" "Major mode for editing R source." t)

  ;; Add a chunk for rmarkdown
  ;; Need to add a keyboard shortcut
  ;; https://emacs.stackexchange.com/questions/27405/insert-code-chunk-in-r-markdown-with-yasnippet-and-polymode
  ;; (defun insert-r-chunk (header) 
  ;;   "Insert an r-chunk in markdown mode. Necessary due to interactions between polymode and yas snippet" 
  ;;   (interactive "sHeader: ") 
  ;;   (insert (concat "```{r " header "}\n\n\n```")) 
  ;;   (forward-line -2))
  ;; (define-key poly-markdown+r-mode-map (kbd "M-c") #'insert-r-chunk)
)





;(use-package polymode
;  :ensure t
;  :config
;  :mode (("\\.md" . poly-markdown-mode)
;	 ("\\.Rnw" . poly-noweb+R-mode)
;	 ("\\.Rmd" . poly-markdown+R-mode))
;  :config
;  (use-package poly-R)
;  (use-package poly-markdown)
;  (markdown-toggle-math t)
;  from https://gist.github.com/benmarwick/ee0f400b14af87a57e4a
;  compile rmarkdown to HTML or PDF with M-n s
;  use YAML in Rmd doc to specify the usual options
;  which can be seen at http://rmarkdown.rstudio.com/
;  thanks http://roughtheory.com/posts/ess-rmarkdown.html
;  (defun ess-rmarkdown ()
;    "Compile R markdown (.Rmd). Should work for any output type."
;    (interactive)
;    ; Check if attached R-session
;    (condition-case nil
;        (ess-get-process)
;      (error
;       (ess-switch-process)))
;    (let* ((rmd-buf (current-buffer)))
;      (save-excursion
;        (let* ((sprocess (ess-get-process ess-current-process-name))
;               (sbuffer (process-buffer sprocess))
;               (buf-coding (symbol-name buffer-file-coding-system))
;               (R-cmd
;                (format "library(rmarkdown); rmarkdown::render(\"%s\")"
;                        buffer-file-name)))
;          (message "Running rmarkdown on %s" buffer-file-name)
;          (ess-execute R-cmd 'buffer nil nil)
;          (switch-to-buffer rmd-buf)
;          (ess-show-buffer (buffer-name sbuffer) nil)))))
;  (define-key polymode-minor-mode-map (kbd "<f5>") 'ess-rmarkdown)
; )

;; Magit
(use-package magit
  :ensure t)

;; Don't let Customize mess with my init.el
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(use-package web-mode
  :ensure t
  :config

  ;; Subpackage
  (use-package web-beautify :ensure t)
  (use-package web-completion-data :ensure t)
  (use-package web-mode-edit-element :ensure t)

  ;; Association
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))


;; Matching parentheses
(use-package paren-face
  :ensure t
  :config
  (progn
    (show-paren-mode t)
    (setq blink-matching-paren -1)
    (setq blink-matching-delay 0)
    ) 
)

(use-package auto-complete
  :ensure t
  :init
  (progn
   (ac-config-default)
   (global-auto-complete-mode t)
   )
  )

(defun then_R_operator ()
  "R - %>% operator or 'then' pipe operator"
  (interactive)
  (just-one-space 1)
  (insert "%>%")
  (reindent-then-newline-and-indent))
(define-key ess-mode-map (kbd "C-%") 'then_R_operator)
(define-key inferior-ess-mode-map (kbd "C-%") 'then_R_operator)


(use-package mu4e
  :load-path "/usr/share/emacs/site-lisp/mu4e"
  :commands mu4e
  :config
  (setq mu4e-maildir "~/Maildir/gmail")
  (setq mu4e-drafts-folder "/draft")
  (setq mu4e-sent-folder "/sent")
  (setq mu4e-trash-folder "/trash")
  (setq mu4e-refile-folder "/all")
  ;; Don't save massages to Sent Messages, Gmail/IMAP takes care of this
  (setq mu4e-sent-messages-behavior 'delete)
  ;; Rename files when moving (mbsync)
  (setq mu4e-change-filenames-when-moving t)
  )

; smtp
;;(require 'smtpmail)
(use-package smtpmail
  :config (progn
	   (setq message-send-mail-function 'smtpmail-send-it)
           (setq smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil)))
           (setq smtpmail-default-smtp-server "smtp.gmail.com")
           (setq smtpmail-smtp-server "smtp.gmail.com")
           (setq smtpmail-smtp-service 587)
           (setq smtpmail-debug-info t)))


(use-package ibuffer
  :ensure t
  :bind ("C-x C-b" . ibuffer)
  :config (setq ibuffer-expert t)
  (setq ibuffer-saved-filter-groups
	(quote (("default"
		 ("org" (name . "^.*org$"))
		 ("R" (or (mode . ess-mode)
			  (mode . inferior-ess-mode)
			  (mode . ess-help-mode)))
		 ("latex" (or (mode . latex-mode)
			      (mode . LaTeX-mode)
			      (mode . bibtex-mode)
			      (mode . reftex-mode)))))))
  (add-hook 'ibuffer-mode-hook
	    (lambda ()
	      (ibuffer-auto-mode 1)
	      (ibuffer-switch-to-saved-filter-groups "default")))
  )

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config (ivy-mode t))


;;(use-package elpy
;;  :ensure t
;;  :commands (elpy-enable))

(use-package python
  :ensure t
  :mode ("\\.py" . python-mode)
  :config
  (use-package elpy
    :ensure t
    :commands elpy-enable
    :config
    (setq elpy-rpc-python-command "python3"
	  elpy-modules (dolist (elem '(elpy-module-highlight-indentation
				       elpy-module-yasnippet))
			 (remove elem elpy-modules)))
    (setq python-shell-interpreter "ipython"
          python-shell-interpreter-args "-i --simple-prompt"))
  (elpy-enable)
  (require 'smartparens-python)
(add-hook 'python-mode-hook #'smartparens-strict-mode))


(use-package pdf-tools
 ;;:pin manual ;;manually update
 :ensure t
 :config
 ;; initialise
 (pdf-tools-install)
 (setq-default pdf-view-display-size 'fit-page)
?*? )

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if (executable-find "python3") 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-evil
  :after treemacs evil
  :ensure t)

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

