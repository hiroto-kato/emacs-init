;;; init.el --- init.el
;; Author: Hiroto Kato
;; Package-Requires: ()
;;; Commentary:
;; windows版emacsの設定
;;; Code:

;; backspace
(global-set-key "\C-h" `delete-backward-char)

;; *.~ とかのバックアップファイルを作らない
(setq make-backup-files nil)

;; .#* とかのバックアップファイルを作らない
(setq auto-save-default nil)
                                 
;; 警告音もフラッシュもすべて無効
(setq ring-bell-function 'ignore)

;;　環境を日本語、UTF-8にする
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; dired用(windowsのみ)
;;(setq default-file-name-coding-system `shift_jis)
;; defaultのディレクトリをHOMEに
;;(setq default-directory "~/")
;;(setq command-line-default-directory "~/")

;; タブにスペースを使用する
(setq-default tab-width 2 indent-tabs-mode nil)

;; package管理
(package-initialize)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))

;; auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode 0.5)

;; メニューバーを非表示
(menu-bar-mode 0)

;; ツールバーを非表示
(tool-bar-mode 0)

;;current directory 表示
(let ((ls (member 'mode-line-buffer-identification
                  mode-line-format)))
  (setcdr ls
    (cons '(:eval (concat " ("
            (abbreviate-file-name default-directory)
            ")"))
            (cdr ls))))

;; スタートアップメッセージを表示させない
(setq inhibit-startup-message 1)

;; 1行ごとの改ページ
(setq scroll-conservatively 1)

;; タイトルにフルパス表示
(setq frame-title-format "%f")

;; 時刻をモードラインに表示
(display-time-mode t)

;; 別のウィンドウ
;;(global-set-key "\C-t" 'other-window)

;; alpha 透明化
(if window-system
    (progn
      (set-frame-parameter nil 'alpha 80)))

;; 透明度を変更するコマンド M-x set-alpha
;; http://qiita.com/marcy@github/items/ba0d018a03381a964f24
(defun set-alpha (alpha-num)
  "set frame parameter 'alpha"
  (interactive "nAlpha: ")
  (set-frame-parameter nil 'alpha (cons alpha-num '(90))))

;; フォント
(set-fontset-font t 'japanese-jisx0208 (font-spec :family "Source Han Code JP"))

;; neotree(サイドバー)
(require 'neotree)
(global-set-key "\C-o" 'neotree-toggle)
(setq neo-smart-open t)
(setq neo-create-file-auto-open t)
;; neotree文字サイズ変更
(defun neotree-text-scale ()
  "Text scale for neotree."
  (interactive)
  (text-scale-adjust 0)
  (text-scale-decrease 1)
  (message nil))
(add-hook 'neo-after-create-hook
      (lambda (_)
        (call-interactively 'neotree-text-scale)))

;; elscreen（上部タブ）
(require 'elscreen)
(elscreen-start)
(global-set-key (kbd "s-t") 'elscreen-create)
;;(global-set-key "\C-l" 'elscreen-next)
(global-set-key "\C-r" 'elscreen-previous)
(global-set-key (kbd "s-d") 'elscreen-kill)
(set-face-attribute 'elscreen-tab-background-face nil
                    :background "grey10"
                    :foreground "grey90")
(set-face-attribute 'elscreen-tab-control-face nil
                    :background "grey20"
                    :foreground "grey90")
(set-face-attribute 'elscreen-tab-current-screen-face nil
                    :background "grey20"
                    :foreground "grey90")
(set-face-attribute 'elscreen-tab-other-screen-face nil
                    :background "grey30"
                    :foreground "grey60")

;;; [X]を表示しない
(setq elscreen-tab-display-kill-screen nil)
;;; [<->]を表示しない
(setq elscreen-tab-display-control nil)
;;; タブに表示させる内容を決定
(setq elscreen-buffer-to-nickname-alist
      '(("^dired-mode$" .
         (lambda ()
           (format "Dired(%s)" dired-directory)))
        ("^Info-mode$" .
         (lambda ()
           (format "Info(%s)" (file-name-nondirectory Info-current-file))))
        ("^mew-draft-mode$" .
         (lambda ()
           (format "Mew(%s)" (buffer-name (current-buffer)))))
        ("^mew-" . "Mew")
        ("^irchat-" . "IRChat")
        ("^liece-" . "Liece")
        ("^lookup-" . "Lookup")))
(setq elscreen-mode-to-nickname-alist
      '(("[Ss]hell" . "shell")
        ("compilation" . "compile")
        ("-telnet" . "telnet")
        ("dict" . "OnlineDict")
        ("*WL:Message*" . "Wanderlust")))

;; テーマ
(load-theme 'dakrone t)
(set-face-foreground 'mode-line "gray10")
(set-face-background 'mode-line "gray64")
(set-face-foreground 'mode-line-inactive "gray64")
(set-face-background 'mode-line-inactive "gray20")
(set-face-foreground 'font-lock-comment-face "gray64")

;; 非アクティブウィンドウの背景色を設定
(require 'hiwin)
(hiwin-activate)
(set-face-background 'default "gray10")
(set-face-background 'hiwin-face "gray16")

;; 現在の行番号ハイライト
(require 'hlinum)
(hlinum-activate)
(set-face-foreground 'linum-highlight-face "#3FC")
(set-face-background 'linum-highlight-face "black")

;; line numberの表示
(require 'linum)
(global-linum-mode 1)

;; 操作強調
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; 対応する括弧をハイライト
(show-paren-mode 1)
(set-face-background 'show-paren-match nil)
(set-face-attribute 'show-paren-match nil
                    :inherit 'highlight)

;; rainbow-delimiters 対応する括弧を色づける
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;; rainbow-delimitersの括弧の色を強調
(require 'cl-lib)
(require 'color)
(defun rainbow-delimiters-using-stronger-colors ()
  (cl-loop
   for index from 1 to rainbow-delimiters-max-face-count
   do
   (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
    (cl-callf color-saturate-name (face-foreground face) 30))))
(add-hook 'emacs-startup-hook 'rainbow-delimiters-using-stronger-colors)

;; git-gutter-fringe
(require 'git-gutter-fringe)
(global-git-gutter-mode t)

(require 'git-gutter)
;; magit
(global-set-key (kbd "C-c C-g") 'magit-diff-working-tree)

;; ファイル編集時に，bufferを再読込
(global-auto-revert-mode 1)

;; eshell + shell-pop
(setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
(global-set-key (kbd "C-c o") 'shell-pop)

;; haskellの設定
(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-cabal "haskell-cabal" nil t)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal$" . haskell-cabal-mode))
;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)
(require 'yasnippet nil t)
(require 'lsp)
(require 'lsp-mode)
(add-hook 'haskell-mode-hook #'lsp)
(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'haskell-mode-hook 'flycheck-mode)
(require 'lsp-haskell)
(setq lsp-haskell-process-args-hie (list "-d" "-l" (make-temp-file "hie." nil ".log")))
(setq lsp-haskell-process-path-hie "hie-wrapper")

;; 行番号を表示
(global-linum-mode t)
(set-face-foreground 'linum "gray64")
(setq linum-format "%4d ")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (git-gutter-fringe all-the-icons lsp-haskell lsp-ui lsp-mode flycheck haskell-mode sml-mode web-server websocket uuidgen markdown-preview-mode markdown-mode indent-guide cl-lib rainbow-delimiters volatile-highlights neotree hlinum hiwin elscreen dakrone-theme auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(provide 'init.el)
;;; init.el ends here
