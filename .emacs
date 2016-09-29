;; emacs24.5
;; save as file: ~/.emacs
;; update:2016-7-20, by:YantaoZhao


;;-----packages-----
;; 'M-x package-list-packages' to manually install packages

(require 'package)
;; package repositories, see: https://www.emacswiki.org/emacs/ELPA/
;(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("popkit" . "http://elpa.popkit.org/packages/"))
;; more repositories see: http://elpa.emacs-china.org/
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

;; package:ggtags
(require 'ggtags)
(add-hook 'c-mode-common-hook
        (lambda ()
          (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
            (ggtags-mode 1))))

;; package:helm-gtags
(require 'helm-gtags)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'java-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
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


;;-----local adjustment-----

(setq make-backup-files nil)  ;; no backup~ file
(setq auto-save-default nil)  ;; no #autosave# file
(global-linum-mode t)         ;; show line number

;; CC Mode
(setq-default c-default-style "bsd"
              c-basic-offset 4
              tab-width 4
              indent-tabs-mode t)

;; check OS type
(cond
 ((string-equal system-type "windows-nt")  ;; Microsoft Windows
  (progn
    (set-default-font "Consolas")
    (set-fontset-font "fontset-default" 'chinese-gbk "微软雅黑")
    (setq face-font-rescale-alist '(("宋体" . 1.2)
                ("微软雅黑" . 1.1)
                ))))
;; ((string-equal system-type "gnu/linux") ;; linux
;;  (progn
;;    (message "Linux")))
;; ((string-equal system-type "darwin")    ;; Mac OS X
;;  (progn
;;    (message "Mac OS X")))
 )

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
