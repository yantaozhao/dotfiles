;; emacs 25.x
;; Save as file: ~/.emacs
;;   Linux: ~
;;   Windows: %AppData%
;; Update:2018-02-28, by:YantaoZhao


;;------the earliest------
(setq gc-cons-threshold 8000000)


;;------packages------
;; 'M-x package-list-packages'
;; 'M-x package-refresh-contents'
;; then manually install packages

;; use proxy if needed
;(setq url-proxy-services
;      '(("http"     . "proxyhost:port")
;        ("https"    . "proxyhost:port")
;        ("no_proxy" . "^\\(localhost\\|10.*\\)")))

(require 'package)
;; Package repositories, see: https://www.emacswiki.org/emacs/ELPA/
;; Option 1, official site:
;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t) ; Org-mode repository
;; Option 2, melpa mirror:
(add-to-list 'package-archives '("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))
(add-to-list 'package-archives '("org" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/") t) ; Org-mode repository
;; Option 3, melpa mirror:
;(add-to-list 'package-archives '("popkit" . "https://elpa.popkit.org/packages/"))
;; Other option, marmalade is not recommended:
;(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
;; Add gnu package for old version emacs:
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  ;(add-to-list 'package-archives '("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/"))
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
;; For more repositories see: http://elpa.emacs-china.org/
;; and https://mirrors.tuna.tsinghua.edu.cn/help/elpa/
(package-initialize)


;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (message "Error: Please install `use-package` first!"))
(eval-when-compile
  (require 'use-package))

;; command: M-x cnfonts-edit-profile
;; Set fonts. e.g. for org-mode, recommendation:
;; Windows:en_font=Dejavu Sans Mono or Consolas, zh_font=Microsoft Yahei
;; Linux:en_font=Dejavu Sans Mono, zh_font=wenquanyi weimihei(apt-get install ttf-wqy-microhei)
(use-package cnfonts
  :ensure t
  :config
    (cnfonts-enable)
    ;(when (package-installed-p 'evil)
    ;  (eval-after-load "evil"
    ;    '(evil-set-initial-state 'cnfonts-ui-mode 'emacs)))
  )

(use-package helm
  :ensure t
  :bind ( ;("M-x"     . helm-M-x)
         ("C-x r b" . helm-filtered-bookmarks)
         ("C-x C-f" . helm-find-files))
  :config
    (setq helm-buffers-fuzzy-matching t)
    (helm-mode 1)
    (helm-autoresize-mode 1))

(use-package evil-leader
  :ensure t
  :commands global-evil-leader-mode
  :init
    (add-hook 'after-init-hook 'global-evil-leader-mode)
  :config
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key "<SPC>" 'helm-M-x)  ; keybinding for helm
    (which-key-add-key-based-replacements "SPC t" "toggle"))

(use-package evil
  :ensure t
  ;:after evil-leader
  :commands evil-mode
  :init
  ;(when (package-installed-p 'evil-leader)
  ;  (global-evil-leader-mode))
    (add-hook 'emacs-startup-hook (lambda()(evil-mode 1)))
  :config
    ;(setq evil-default-state 'emacs)
    ;; vim style incremental search and persistent highlight
    (evil-select-search-module 'evil-search-module 'evil-search)
    (define-key evil-normal-state-map "ZZ" nil)
    (define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)
    (evil-leader/set-key "." 'repeat)  ; repeat "C-x z"
    ;; enter emacs-state when switch to evil's insert-state
    (setq evil-insert-state-map (make-sparse-keymap))
    (define-key evil-insert-state-map (kbd "<escape>") 'evil-normal-state)
    (define-key evil-insert-state-map (kbd "C-o") 'evil-execute-in-normal-state))

(use-package evil-visualstar
  :ensure t
  :after evil
  :config
    (global-evil-visualstar-mode))

(use-package evil-avy
  :ensure t
  :after evil
  :config
    (evil-avy-mode))

(use-package expand-region
  :ensure t
  :after evil
  ;; press the bind key, then press `=`/`-` key to expand/contract the region
  ;:bind ("C-=" . er/expand-region)
  :config
    (eval-after-load "evil" '(setq expand-region-contract-fast-key "c"))
    (evil-leader/set-key "ve" 'er/expand-region)
    (which-key-add-key-based-replacements "SPC v" "visual"))

(use-package helm-swoop
  :ensure t
  :defer 1
  :config
    (setq helm-swoop-move-to-line-cycle nil)
    (evil-leader/set-key "vo" 'helm-swoop))

(use-package which-key
  :ensure t
  :pin melpa
  :commands which-key-mode
  :init
    (add-hook 'emacs-startup-hook 'which-key-mode))

(use-package beacon
  :ensure t
  :pin melpa
  :defer 2
  :config
    (beacon-mode 1))

(use-package company
  :ensure t
  :commands global-company-mode
  :init
    (add-hook 'emacs-startup-hook 'global-company-mode)
  :config
    (setq company-idle-delay t)
    (setq company-minimum-prefix-length 2)
    (setq company-dabbrev-downcase nil))

(use-package yasnippet
  :ensure t
  :defer 2
  :pin melpa
  :config
    (yas-global-mode 1))

(use-package smartparens
  :ensure t
  :commands smartparens-mode
  :init
    (add-hook 'prog-mode-hook 'smartparens-mode))

(use-package rainbow-delimiters
  :ensure t
  :commands rainbow-delimiters-mode
  :init
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package highlight-thing
  :ensure t
  :commands global-highlight-thing-mode
  :init
    (add-hook 'emacs-startup-hook 'global-highlight-thing-mode)
  :config
    ;(setq highlight-thing-what-thing 'word)
    ;(setq highlight-thing-delay-seconds 0.2)
    (setq highlight-thing-case-sensitive-p t))

(use-package anzu
  :ensure t
  :commands global-anzu-mode
  :init
    (add-hook 'emacs-startup-hook (lambda() (global-anzu-mode +1))))

(use-package evil-anzu
  :ensure t
  :after (evil))

(use-package visual-regexp-steroids
  :ensure t
  :defer 1
  :config
    (evil-leader/set-key "vr" 'vr/query-replace))

(use-package window-numbering
  :ensure t
  :commands window-numbering-mode
  :init
    (add-hook 'emacs-startup-hook (lambda()(window-numbering-mode t))))

(use-package zoom-window
  :ensure t
  :bind ([f11] . zoom-window-zoom))

(use-package buffer-move
  :ensure t
  :bind (("<C-S-up>"    . buf-move-up)
         ("<C-S-down>"  . buf-move-down)
         ("<C-S-left>"  . buf-move-left)
         ("<C-S-right>" . buf-move-right)))

(use-package indent-guide
  :disabled
  :config
    ;(indent-guide-global-mode)
    ;(setq indent-guide-delay 0.1)
    ;;(setq indent-guide-recursive t)
    (setq indent-guide-char "┆"))

(use-package nyan-mode
  :disabled
  :config
    (nyan-mode t))

(use-package multiple-cursors
  :disabled
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)))

(use-package neotree
  :ensure t
  :after evil
  :config
    (setq neo-smart-open t)
    (evil-leader/set-key "tn" 'neotree-toggle)
    (evil-set-initial-state 'neotree-mode 'emacs))

(use-package imenu-list
  :ensure t
  :after evil
  :config
    (setq imenu-list-auto-resize t)
    (setq imenu-list-idle-update-delay 2)
    (setq imenu-list-focus-after-activation t)
    (evil-leader/set-key "ti" 'imenu-list-smart-toggle)
    (evil-set-initial-state 'imenu-list-major-mode 'emacs))

(use-package sr-speedbar
  :ensure t
  :defer 1)

(use-package ecb
  :ensure t
  :defer 3)

(use-package tabbar
  :ensure t
  :config
    (setq tabbar-use-images nil))

(use-package undo-tree
  :disabled
  :pin melpa)

;; 'M-x org-version' to check org-mode version
(use-package org
  :ensure org-plus-contrib
  :pin org)

;; org-mode official exporter: 'C-c C-e m *'
;(eval-after-load "org"
;  '(require 'ox-md nil t))

;; 'M-x org-gfm-export-to-markdown' to export Org to gfm markdown. NOT 'C-c C-e m'
(use-package ox-gfm
  :ensure t
  :config
    (eval-after-load "org"
      '(require 'ox-gfm nil t)))

(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :init (setq markdown-command "multimarkdown")
  :config
    (setq markdown-fontify-code-blocks-natively t))

(use-package modern-cpp-font-lock
  :ensure t
  :init
    (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode))

;; Install `global` from source code: www.gnu.org/software/global/
(use-package ggtags
  :disabled
  :commands ggtags-mode
  :init
    (add-hook 'c-mode-common-hook
      (lambda()
        (when (derived-mode-p 'c-mode 'c++-mode 'asm-mode 'java-mode)
          (ggtags-mode 1))))
  :config
    ;; Meanwhile, "M-]" is already assigned to ggtags-find-reference
    ;; and "M-." to ggtags-find-tag-dwim
    (define-key ggtags-mode-map (kbd "M-[") 'ggtags-find-definition))

;; etags: recommend using `ctags -e ...` to generate TAGS
(use-package etags-table
  :disabled
  :after ggtags
  :config
    (setq etags-table-search-up-depth 10)
    (evil-leader/set-key "ed" 'xref-find-definitions-other-window)
    (evil-leader/set-key "er" 'xref-find-references)
    (which-key-add-key-based-replacements "SPC e" "etags")
    (when (package-installed-p 'evil)
      (eval-after-load "evil"
        '(evil-set-initial-state 'xref--xref-buffer-mode 'emacs))))

(use-package rtags
  :disabled
  :commands rtags-start-process-unless-running
  :init
    (if (executable-find "rdm")
      (add-hook 'c-mode-hook 'rtags-start-process-unless-running)
      (add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
      (add-hook 'objc-mode-hook 'rtags-start-process-unless-running))
  :config
    ;(setq-default rtags-tramp-enabled t)
    (rtags-enable-standard-keybindings)
    (when (package-installed-p 'evil)
      (eval-after-load "evil"
        '(progn
          (add-hook 'rtags-jump-hook 'evil-set-jump)
          (evil-set-initial-state 'rtags-mode 'emacs)))))

;(use-package dtrt-indent
;  :disabled
;  :config
;    (dtrt-indent-mode t))

;; Use command 'M-x auto-package-update-now' to update packages now
(use-package auto-package-update
  :ensure t
  :defer 3
  :config
    (setq auto-package-update-interval 180)
    (setq auto-package-update-delete-old-versions t)
    (setq auto-package-update-prompt-before-update t))


;;------emacs adjustment------
(prefer-coding-system 'utf-8)
(setq make-backup-files nil)   ; no backup~ file
(setq auto-save-default nil)   ; no #autosave# file
(global-linum-mode t)          ; show line number
(setq inhibit-splash-screen t) ; disable the welcome screen

;; CC Mode
;; Or maybe have a look at package 'dtrt-indent'
(setq-default c-default-style "bsd"
              tab-width 4
              indent-tabs-mode nil)
(defvaralias 'c-basic-offset 'tab-width)

;; display filepath in the title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                   "%b"))))

;; start maximized (cross-platform)
;(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; scroll(less "jumpy" than defaults)
;(setq mouse-wheel-scroll-amount '(3 ((shift) . 3)))  ; 3 line at a time
(setq mouse-wheel-progressive-speed nil)  ; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)        ; scroll window under mouse
(setq scroll-step 3)  ; keyboard scroll 3 line at a time

;; keep highlight from isearch
;(setq lazy-highlight-cleanup nil)
;(setq lazy-highlight-interval 0)

;; re-visit file modified external
(global-auto-revert-mode 1)

;; tramp setting
;; For Linux: ssh
;; For Windows: make sure PuTTY and plink.exe is on your PATH
(setq password-cache-expiry nil)

;; window switching
;(windmove-default-keybindings 'meta)

;; open file with external program
;; See: bbatsov/crux, and http://emacsredux.com/blog/2013/03/27/open-file-in-external-program/
(defun open-current-file-with-external-gvim (arg)
  "Open visited file in external program.
  With a prefix ARG always prompt for command to use."
  (interactive "P")
  (when buffer-file-name
    (async-shell-command (concat
    ;(shell-command (concat
                      ;(cond
                        ;((and (not arg) (eq system-type 'darwin)) "open")
                        ;((and (not arg) (member system-type '(gnu gnu/linux gnu/kfreebsd))) "xdg-open")
                        ;(t (read-shell-command "Open current file with program: ")))
                      "gvim"
                      " "
                      buffer-file-name
                      " "
                      (shell-quote-argument (concat "+" (number-to-string (line-number-at-pos))))))))

;; misc
(setq sentence-end-double-space nil)
(setq display-time-format "%a%R")
(display-time-mode 1)
(column-number-mode 1)
(setq ad-redefinition-action 'accept)  ; suppress the ad-handle-definition warning

;;======End======


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
