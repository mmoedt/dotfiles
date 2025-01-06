;; Red Hat Linux default .emacs initialization file  ; -*- mode: emacs-lisp -*-
(setq site-lisp-path "/usr/share/emacs/site-lisp/")

;;(custom-set-variables '(inhibit-startup-screen t))

;; note: lots of good stuff in Benjamin Rutt's .emacs
;;       at http://www.dotemacs.de/dotfiles/BenjaminRutt.emacs.html

(global-set-key "\C-xg" 'goto-line)
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [\C-home] 'beginning-of-buffer)
(global-set-key [\C-end] 'end-of-buffer)

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; turn on font-lock mode
(global-font-lock-mode t)
;; enable visual feedback on selections
(setq-default transient-mark-mode t)

;; always end a file with a newline
(setq require-final-newline t)

;; stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; use extended compound-text coding for X clipboard
  (set-selection-coding-system 'compound-text-with-extensions)
)

;; will highlight matching parentheses next to cursor
;;(require 'paren) (show-paren-mode t)


;; highlight region between point and mark
(transient-mark-mode t)

(defun get-my-tab-length () 4)
;; Set indentation to 4 spaces instead of the default 2
(setq default-tab-width (get-my-tab-length))
;;   Show tabs as 4 spaces
(setq c-basic-offset (get-my-tab-length))
;;   introduce spaces instead of tabs by default
(setq-default indent-tabs-mode nil)
;;   have enter indent the next line
(global-set-key "\C-m" 'newline-and-indent)
;;(setq c-auto-newline t)

(setq standard-indent (get-my-tab-length))
(setq tab-width (get-my-tab-length))

;;   indent next line upon enter  ;; - doesn't work!
;;(define-key indented-text-mode-map "\C-m" 'newline-and-indent)
;;(define-key emacs-lisp-mode-map "\C-m" 'newline-and-indent)
;;(define-key c-mode-map "\C-m" 'newline-and-indent)


;;(add-hook 'c-mode-common-hook
;;          '(lambda () (c-toggle-auto-hungry-state 1)))

;; use Ellemtel style for all C, C++, and Objective-C code
;;(add-hook 'c-mode-common-hook '(lambda () (c-set-style "Ellemtel")))
;; note: ellemtel overrides some of my settings (e.g. tab width)

;; force line-number and add column-numbers to the mode line
(line-number-mode 1)
(column-number-mode 1)

;; NOTE: Below commented-out whitespace stuff is not compatible with recent emacs versions..
;; highlight the evil tabs!!!
;;(load-library "~/emacs/show-wspace")
;;(add-hook 'font-lock-mode-hook 'show-ws-highlight-tabs)
;;(add-hook 'font-lock-mode-hook 'show-ws-trailing-whitespace)
;;(require 'highlight-chars) ; Load lib  ;; this doesn't seem to work..
(load-library "~/emacs/highlight-chars.el")
(add-hook 'font-lock-mode-hook 'hc-highlight-tabs)
(add-hook 'font-lock-mode-hook 'hc-highlight-trailing-whitespace)

;;if (0)          becomes        if (0)
;;    {                          {
;;       ;                           ;
;;    }                          }
(c-set-offset 'substatement-open 0)

;; settings for compilation:
(setq compile-command "make -k")
(setq compilation-window-height 20)
(setq makefile-electric-keys t)
(defadvice compile-internal (after my-scroll act comp)
  "Forces compile buffer to scroll "
  (let* ((ob (current-buffer))
          (obw  (get-buffer-window ob t))
           win
            )
    (save-excursion
      (if (or (null (setq win (get-buffer-window ad-return-value t)))
                    (null obw))
            nil
        (select-window win)
        (goto-char (point-max))
        (select-window obw)
        )))
)

;; Set up javascript mode..
;;
(require 'generic-x)

(when (locate-library "~/emacs/javascript")
    (autoload 'javascript-mode "~/emacs/javascript" nil t)
      (add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode)))

(autoload 'css-mode "css-mode" "CSS Mode" t)
(setq auto-mode-alist
      (append '(("\\.css$" . css-mode))
              auto-mode-alist))

;; set up nxml-mode (needed for django mode)
;path to where nxml is
(set 'nxml-path (concat site-lisp-path "nxml-mode/"))

;; Needed .el files are in ~/emacs.  (e.g. highlight-chars)
;;(add-to-list 'load-path "~/emacs")  ;; disabled -doesn't seem to work

;; emacs24 way: (load-theme 'solarized-dark t)
;;
;;(require 'color-theme) ;; no longer works in latest fresh ubuntu install, downloaded and loading this way:
;;(load-library "~/emacs/color-theme.el")
;;(add-to-list 'load-path "~/emacs/color-theme-solarized/")
;;(load-library "~/emacs/color-theme-solarized")
;;(require 'color-theme-solarized)
;;(eval-after-load "color-theme"
;;  '(progn
;;     (color-theme-initialize)
;;     (color-theme-solarized-dark)))
(setq solarized-termcolor 256)

;; (load (concat nxml-path "rng-auto.el"))

;;  (add-to-list 'auto-mode-alist
;;                             (cons (concat "\\." (regexp-opt '("xml" "xsd" "sch" "rng" "xslt" "svg" "rss") t) "\\'")
;;                                                       'nxml-mode))

;;   (unify-8859-on-decoding-mode)

;;     (setq magic-mode-alist
;;             (cons '("<..?xml " . nxml-mode)
;;                     magic-mode-alist))
;;    (fset 'xml-mode 'nxml-mode)

;; ;; Set up django template mode
;; (require 'django-html-mode)
;; (require 'django-mode)
;; ;(yas/load-directory "path-to/django-mode/snippets")
;; (add-to-list 'auto-mode-alist '("\.djhtml$" . django-html-mode))


(put 'upcase-region 'disabled nil)

(put 'downcase-region 'disabled nil)

;;;; Below is pre-checktyle-tweaking, found on the vecima wiki:
;; (c-add-style "vecima-c"
;;              '((c-basic-offset . 4)
;;                (c-comment-only-line-offset . 0)
;;                (c-offsets-alist . ((statement-block-intro . +)
;;                                    (knr-argdecl-intro . +)
;;                                    (substatement-open . 0)
;;                                    (label . 0)
;;                                    (statement-cont . +)))
;;                (c-hanging-braces-alist . (substatement-open before after))
;;                (c-offsets-alist . ((inline-open . 0)))
;;                (tab-width . 8)
;;                (indent-tabs-mode . nil)))

(c-add-style "vecima-c"
             '((c-basic-offset . 4)
               (c-comment-only-line-offset . 0)
               (c-offsets-alist . ((statement-block-intro . +)
                                   (knr-argdecl-intro . +)
                                   (substatement-open . 0)
                                   (label . 0)
                                   (statement-cont . +)))
               (c-hanging-braces-alist . (substatement-open before after))
               (c-offsets-alist . ((inline-open . 0)))
               (tab-width . 8)
               (indent-tabs-mode . nil)))

(setq c-default-style "vecima-c")



(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 2
                                  tab-width 8
                                  indent-tabs-mode nil)))
;; Commented out the below.  It looks like vecima uses width of '2' (yeah, I know)
;;(add-hook 'java-mode-hook (lambda ()
;;                            (setq c-basic-offset 4
;;                                  tab-width 8
;;                                  indent-tabs-mode nil)))

;; Alternate code block, from http://wiki/moin/VecimaCEmacsMode:
;;
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(inhibit-startup-screen t))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
;; (require 'cc-mode)
;; (global-font-lock-mode 1)
;; (defun my-build-tab-stop-list (width)
;;   (let ((num-tab-stops (/ 80 width))
;;         (counter 1)
;;         (ls nil))
;;     (while (<= counter num-tab-stops)
;;       (setq ls (cons (* width counter) ls))
;;       (setq counter (1+ counter)))
;;     (set (make-local-variable 'tab-stop-list) (nreverse ls))))
;; (defun my-c-mode-common-hook ()
;;   (setq tab-width 4) ;; change this to taste, this is what K&R uses :)
;;   (my-build-tab-stop-list tab-width)
;;   (setq c-basic-offset tab-width)
;;   (c-set-offset 'substatement-open 0)
;;   (c-set-offset 'case-label '+)
;;   (setq indent-tabs-mode nil)) ;; force only spaces for indentation
;; (add-hook 'c-mode-common-hook 'my-c-mode-common-hook) 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(solarized-zenburn))
 '(custom-safe-themes
   '("51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "3e200d49451ec4b8baa068c989e7fba2a97646091fd555eca0ee5a1386d56077" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "d89e15a34261019eec9072575d8a924185c27d3da64899905f8548cbd9491a36" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "efcecf09905ff85a7c80025551c657299a4d18c5fcfedd3b2f2b6287e4edd659" "57a29645c35ae5ce1660d5987d3da5869b048477a7801ce7ab57bfb25ce12d3e" "833ddce3314a4e28411edf3c6efde468f6f2616fc31e17a62587d6a9255f4633" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" default)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'after-init-hook (lambda () (load-theme 'solarized-dark)))
