(package-initialize)

(setq user-full-name "Akhilesh Srikanth"
      user-mail-address "akhilesh.srikanth@gmail.com")

(setq package-enable-at-startup nil)
(setq ring-bell-function 'ignore)
(setq mac-option-modifier 'meta)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-splash-screen t)

(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  ;; (package-refresh-contents)
  )

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)

(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

(electric-pair-mode 1)

(use-package dash)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

(use-package winner
  :defer t)

(use-package helm
  :diminish helm-mode
  :init
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 20)
    (setq helm-idle-delay 0.0
          helm-input-idle-delay 0.01
          helm-yas-display-key-on-candidate t
          helm-quick-update t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t)
    (helm-mode))
  :bind (("C-c h" . helm-mini)
         ("C-h a" . helm-apropos)
         ("C-x C-b" . helm-buffers-list)
         ("C-x b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x)
         ("C-x c o" . helm-occur)
         ("C-x c s" . helm-swoop)
         ("C-x c y" . helm-yas-complete)
         ("C-x c Y" . helm-yas-create-snippet-on-region)
         ("C-x c SPC" . helm-all-mark-rings)))

(use-package helm-descbinds
  :defer t
  :bind (("C-h b" . helm-descbinds)
         ("C-h w" . helm-descbinds)))

(use-package smart-mode-line)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package which-key
  :config
  (progn
    (require 'which-key)
    (which-key-mode 1)))

(bind-key "C-x p" 'pop-to-mark-command)
(setq set-mark-command-repeat-pop t)

(use-package helm-swoop
  :bind
  (("C-S-s" . helm-swoop)
   ("M-i" . helm-swoop)
   ("M-I" . helm-swoop-back-to-last-point)
   ("C-c M-i" . helm-multi-swoop)
   ("C-x M-i" . helm-multi-swoop-all)
   )
  :config
  (progn
    (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
    (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)))

(use-package windmove)

(use-package ace-window
  :ensure t)

(use-package expand-region :defer t)

(defvar aki/windmove-map (make-sparse-keymap))
(bind-key "<right>" 'windmove-right aki/windmove-map)
(bind-key "<up>" 'windmove-up aki/windmove-map)
(bind-key "<left>" 'windmove-left aki/windmove-map)
(bind-key "<down>" 'windmove-down aki/windmove-map)
(bind-key "r" 'windresize aki/windmove-map)

(defvar aki/file-util-map (make-sparse-keymap))
(define-key aki/file-util-map "f" 'helm-find-files)
(define-key aki/file-util-map "o" 'find-file-other-window)

(use-package key-chord
  :init
  (progn
    (setq key-chord-one-key-delay 0.20)
    (key-chord-mode 1)
    (key-chord-define-global "xx" 'er/expand-region)
    (key-chord-define-global "cc" 'er/contract-region)
    (key-chord-define-global "ww" aki/windmove-map)))

(use-package jump-char)

(defun mark-backward (&optional arg   allow-extend) ;
  (interactive "P\np")
  (cond ((and allow-extend
              (or (and (eq last-command this-command) (mark t))
                  (and transient-mark-mode mark-active)))
         (setq arg (if arg (prefix-numeric-value arg)
                     (if (< (mark) (point)) -1 1)))
         (set-mark
          (save-excursion
            (goto-char (mark))
            (forward-word arg)
            (point))))
        (t   (push-mark
              (save-excursion
                (backward-word (prefix-numeric-value arg))
                (point)) nil t))))

(global-set-key (kbd "C-i") 'back-to-indentation)
(global-set-key (kbd "M-c") 'set-mark-command)
(global-set-key (kbd "M-p") 'aki/kill-back-to-indent)
(global-set-key (kbd "M-<down>") 'next-line)
(global-set-key (kbd "M-<up>") 'previous-line)
(global-set-key (kbd "M-b") 'beginning-of-buffer)
(global-set-key (kbd "M-e") 'end-of-buffer)
(global-set-key (kbd "C-c C-n") 'tabbar-forward-tab)

(defun dot-emacs ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(use-package smartscan
  :defer t
  :config (global-smartscan-mode t))

(use-package avy)

(use-package web-mode
  :mode "\\.html?\\'"
  :config
  (progn
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (setq web-mode-enable-current-element-highlight t)
    (setq web-mode-ac-sources-alist
          '(("css" . (ac-source-css-property))
            ("html" . (ac-source-words-in-buffer ac-source-abbrev))))))

(setq-default tab-width 2)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x o") 'ace-window)

(defun aki/kill-back-to-indent ()
  (interactive)
  (let ((prev-pos (point)))
    (back-to-indentation)
    (kill-region (point) prev-pos)))

(use-package "eldoc"
  :diminish eldoc-mode
  :commands turn-on-eldoc-mode
  :defer t
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
    (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
    (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)))

(use-package yasnippet
  :diminish yas-minor-mode
  :init (yas-global-mode)
  :config
  (progn
    (yas-global-mode)
    (yas-global-mode 1)))

(column-number-mode 1)

(use-package magit
  :defer t
  :bind (("C-x g" . magit-status)))

(use-package projectile
  :diminish projectile-mode
  :config
  (progn
    (setq projectile-keymap-prefix (kbd "C-c p"))
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)
    (setq projectile-indexing-method 'alien))
  :config
  (projectile-global-mode))

(use-package helm-projectile)

(show-paren-mode 1)

(use-package smartparens
  :config
  (progn
    (require 'smartparens-config)
    (add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
    (add-hook 'emacs-lisp-mode-hook 'show-smartparens-mode)))

(use-package rainbow-delimiters
	:ensure t
	:config
	(progn
		(require 'rainbow-delimiters)
		(rainbow-delimiters-mode 1)))

(use-package company
  :ensure t
  :config
  (progn
    (global-company-mode)
		;; (push '(ensime-company :with company-yasnippet) company-backends)
		))

(use-package subword
  :ensure nil
  :diminish subword-mode
  :config (global-subword-mode t))

(use-package all-the-icons)

(use-package neotree
	:ensure t
	:config
	(progn
		(require 'neotree)
		(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
		(key-chord-define-global "pd" 'neotree-toggle)))

(use-package dracula-theme
  :config
  (progn
    (load-theme 'dracula t)))

;; (use-package paredit
;; 	:ensure t
;; 	:config
;; 	(progn
;; 		(require 'paredit)
;; 		(paredit-mode 1)))

(delete-selection-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'prog-mode-hook 'paredit-mode)

(use-package windresize
  :ensure t)

(defun xah-forward-block (&optional n)
  "Move cursor beginning of next text block.
A text block is separated by blank lines.
This command similar to `forward-paragraph', but this command's behavior is the same regardless of syntax table.
URL `http://ergoemacs.org/emacs/emacs_move_by_paragraph.html'
Version 2016-06-15"
  (interactive "p")
  (let ((n (if (null n) 1 n)))
    (re-search-forward "\n[\t\n ]*\n+" nil "NOERROR" n)
		(back-to-indentation)))

(defun xah-backward-block (&optional n)
  "Move cursor to previous text block.
See: `xah-forward-block'
URL `http://ergoemacs.org/emacs/emacs_move_by_paragraph.html'
Version 2016-06-15"
  (interactive "p")
  (let ((n (if (null n) 1 n))
        (-i 1))
    (while (<= -i n)
      (if (search-backward-regexp "\n[\t\n ]*\n+" nil "NOERROR")
          (progn (skip-chars-backward "\n\t "))
        (progn (goto-char (point-min))
               (setq -i n)))
      (setq -i (1+ -i))))
	(back-to-indentation))

;; Scala
(add-to-list 'exec-path "/usr/local/bin")
(use-package ensime
	:defer t
	:init
	(setq
	 ensime-startup-notification nil
	 ensime-startup-snapshot-notification nil))

(use-package sbt-mode)
(use-package scala-mode)

(use-package tabbar-mode
	:ensure t
	:config
	(progn
		(tabbar-mode 1)))

;; (load "~/.emacs.d/elpa/idle-highlight-mode/idle-highlight-mode")
;; (idle-highlight-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
	 (quote
		(tabbar-mode tabbar find-file-in-project paredit jump-char ace-jump-mode ensime neotree ace-window windresize doremi dracula-theme doom-themes show-paren-mode show-parens-mode which-key yasnippet web-mode use-package undo-tree switch-window smartscan smartparens smart-mode-line rainbow-mode rainbow-delimiters miniedit magit key-chord helm-swoop helm-projectile helm-descbinds guide-key expand-region company auto-compile)))
 '(tabbar-mode t nil (tabbar)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
