;; emacs 25.x
;; Save as file: ~/.emacs
;; OS: Linux
;; Update:2017-08-01, by:YantaoZhao


;;------packages------
;; 'M-x package-list-packages' then manually install packages

;; use proxy if needed
;(setq url-proxy-services
;      '(("http"     . "proxyhost:port")
;        ("https"    . "proxyhost:port")
;        ("no_proxy" . "^\\(localhost\\|10.*\\)")))

(require 'package)
;; Package repositories, see: https://www.emacswiki.org/emacs/ELPA/
;; Option 1, official site:
;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Option 2, melpa mirror:
(add-to-list 'package-archives '("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))
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

;; package:helm
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)
(helm-autoresize-mode 1)

;; package:evil
(require 'evil)
(evil-mode 1)
;(setq evil-default-state 'emacs)
;; vim style incremental search and persistent highlight
(evil-select-search-module 'evil-search-module 'evil-search)
(define-key evil-insert-state-map (kbd "TAB") 'tab-to-tab-stop)

;; package:company
(require 'company)
(setq company-idle-delay t)
(setq company-minimum-prefix-length 2)
(setq company-dabbrev-downcase nil)
(add-hook 'after-init-hook 'global-company-mode)
;(global-company-mode 1)

;; package:rainbow-delimiters
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; package:highlight-thing
(require 'highlight-thing)
(global-highlight-thing-mode)
(setq highlight-thing-case-sensitive-p t)
;(setq highlight-thing-what-thing 'word)
;(setq highlight-thing-delay-seconds 0.2)

;; package:indent-guide [no]
;(require 'indent-guide)
;(indent-guide-global-mode)
;(setq indent-guide-delay 0.1)
;(setq indent-guide-char "┆")
;;(setq indent-guide-recursive t)

;; package:sr-speedbar
(require 'sr-speedbar)
;(add-hook 'after-init-hook '(lambda () (sr-speedbar-toggle)))

;; package:ecb
;(require 'ecb)

;; package:tabbar
;(require 'tabbar)
(setq tabbar-use-images nil)

;; package:powerline [no]
;(require 'powerline)
;(powerline-default-theme)

;; package:undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; package:chinese-fonts-setup
;; command: M-x cnfonts-edit-profile
;; Set fonts. e.g. for org-mode, recommendation:
;; Windows:en_font=Dejavu Sans Mono or Consolas, zh_font=Microsoft Yahei
;; Linux:en_font=Dejavu Sans Mono, zh_font=wenquanyi weimihei(apt-get install ttf-wqy-microhei)
;; Mac:...
(require 'cnfonts)
(cnfonts-enable)
;; show spacemacs mode-line Unicode icon correctly
;(cfs-set-spacemacs-fallback-fonts)

;; package:ggtags
;; Install `global` from source code: www.gnu.org/software/global/
(require 'ggtags)
(add-hook 'c-mode-common-hook
  (lambda ()
    (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
      (ggtags-mode 1))))
(define-key ggtags-mode-map (kbd "M-[") 'ggtags-find-definition)
;; Meanwhile, "M-]" is already assigned to ggtags-find-reference
;; and "M-." to ggtags-find-tag-dwim

;; package:rtags
(require 'rtags)
(rtags-enable-standard-keybindings)
;(setq-default rtags-tramp-enabled t)
(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
(add-hook 'objc-mode-hook 'rtags-start-process-unless-running)

;; package:rscope [no]
;; Download from: https://github.com/rjarzmik/rscope
;; Instead of package xcscope
;(add-to-list 'load-path "~/.emacs.d/rscope-master")
;(load "rscope.el")
;(load "rscope-nav.el")


;;------local adjustment------
(prefer-coding-system 'utf-8)
(setq make-backup-files nil)  ;; no backup~ file
(setq auto-save-default nil)  ;; no #autosave# file
(global-linum-mode t)         ;; show line number

;; CC Mode
(setq-default c-default-style "bsd"
              c-basic-offset 4
              tab-width 4
              indent-tabs-mode t)

;; display filepath in the title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                   "%b"))))

;; start maximized (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; scroll(less "jumpy" than defaults)
;(setq mouse-wheel-scroll-amount '(3 ((shift) . 3)))  ;; 3 line at a time
(setq mouse-wheel-progressive-speed nil)  ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)  ;; scroll window under mouse
;(setq scroll-step 3)  ;; keyboard scroll 3 line at a time

;; keep highlight from isearch
;(setq lazy-highlight-cleanup nil)
;(setq lazy-highlight-interval 0)

;; re-visit file modified external
(global-auto-revert-mode 1)

;; tramp setting
;; For Linux: ssh
;; For Windows: make sure PuTTY and plink.exe is on your PATH
(setq password-cache-expiry nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
	(ggtags evil rtags undo-tree tabbar sr-speedbar rainbow-delimiters helm ecb company chinese-fonts-setup)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

