;; emacs 24.5/25.1
;; save as file: ~/.emacs
;; update:2016-9-30, by:YantaoZhao


;;-----packages-----
;; 'M-x package-list-packages' to manually install packages

(require 'package)
;; package repositories, see: https://www.emacswiki.org/emacs/ELPA/
;(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("popkit" . "https://elpa.popkit.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
;; For more repositories see: http://elpa.emacs-china.org/
;; and: https://mirrors.tuna.tsinghua.edu.cn/help/elpa/
(package-initialize)

;; package:helm
(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)
(helm-autoresize-mode 1)

;; package:company
(require 'company)
(setq company-idle-delay t)
(setq company-minimum-prefix-length 2)
(setq company-dabbrev-downcase nil)
(add-hook 'after-init-hook 'global-company-mode)
;(global-company-mode 1)

;; package: yasnippet [no]
;(require 'yasnippet)
;(yas-global-mode 1)

;; package:sr-speedbar
(require 'sr-speedbar)
;(add-hook 'after-init-hook '(lambda () (sr-speedbar-toggle)))

;; package:undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; package:rainbow-delimiters
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; package:ggtags [no]
;(require 'ggtags)
;(add-hook 'c-mode-common-hook
;        (lambda ()
;          (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
;            (ggtags-mode 1))))

;; package:helm-gtags [no]
;(require 'helm-gtags)
;(add-hook 'c-mode-hook 'helm-gtags-mode)
;(add-hook 'c++-mode-hook 'helm-gtags-mode)
;(add-hook 'java-mode-hook 'helm-gtags-mode)
;(add-hook 'asm-mode-hook 'helm-gtags-mode)
;(custom-set-variables
; '(helm-gtags-path-style 'relative)
; '(helm-gtags-ignore-case t)
; '(helm-gtags-auto-update t))

;; package:ecb
;(require 'ecb)

;; package:tabbar
;(require 'tabbar)
(setq tabbar-use-images nil)

;; package:powerline [no]
;(require 'powerline)
;(powerline-default-theme)

;; package:indent-guide [no]
;(require 'indent-guide)
;(indent-guide-global-mode)
;(setq indent-guide-delay 0.1)
;(setq indent-guide-recursive t)
;(setq indent-guide-char "┆")

;; package:chinese-fonts-setup
;; Set font, especially for org-mode, recommendation:
;; Windows:英文=Dejavu Sans Mono或Consolas, 中文=微软雅黑
;; Linux:英文=Dejavu Sans Mono, 中文=文泉驿微米黑(apt-get install ttf-wqy-microhei)
;; Mac:...
(require 'chinese-fonts-setup)
;; 让 chinese-fonts-setup 随着 emacs 自动生效
(chinese-fonts-setup-enable)
;; 让 spacemacs mode-line 中的 Unicode 图标正确显示
;(cfs-set-spacemacs-fallback-fonts)


;;-----local adjustment-----

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

;; Start maximized (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; scroll(less "jumpy" than defaults)
;(setq mouse-wheel-scroll-amount '(3 ((shift) . 3)))  ;; 3 line at a time
(setq mouse-wheel-progressive-speed nil)  ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)  ;; scroll window under mouse
;(setq scroll-step 3)  ;; keyboard scroll 3 line at a time

;; re-visit file modified external
(global-auto-revert-mode 1)

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
