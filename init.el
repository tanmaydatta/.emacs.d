;; Package maintainers: do not have Debian packages edit this file.
;; See the policy manual for the proper way to handle Emacs package
;; initialization code.

(define-key global-map (kbd "RET") 'newline-and-indent)

;;; Indentation for python

;; Ignoring electric indentation
(defun electric-indent-ignore-python (char)
  "Ignore electric indentation for python-mode"
  (if (equal major-mode 'python-mode)
      `no-indent'
    nil))
(add-hook 'electric-indent-functions 'electric-indent-ignore-python)

;; Enter key executes newline-and-indent
(defun set-newline-and-indent ()
  "Map the return key with `newline-and-indent'"
  (local-set-key (kbd "RET") 'newline-and-indent))
(add-hook 'python-mode-hook 'set-newline-and-indent)

(dolist (command '(yank yank-pop))
  (eval `(defadvice ,command (after indent-region activate)
	   (and (not current-prefix-arg)
		(member major-mode '(emacs-lisp-mode lisp-mode
						     clojure-mode    scheme-mode
						     haskell-mode    ruby-mode
						     rspec-mode      python-mode
						     c-mode          c++-mode
						     objc-mode       latex-mode
						     plain-tex-mode))
		(let ((mark-even-if-inactive transient-mark-mode))
		  (indent-region (region-beginning) (region-end) nil))))))

(global-linum-mode t)

(add-to-list 'load-path "~/.emacs.d")

;; Addition of autocomplete
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

;; To add zenburn color scheme:
;; (load-file "~/.emacs.d/themes/zenburn-theme.el")

(add-to-list 'load-path "~/.emacs.d/themes/color-theme-tangotango-master")

(require 'color-theme)
(setq color-theme-load-all-themes nil)

(require 'color-theme-tangotango)

;; select theme - first list element is for windowing system, second is for console/terminal
;; Source : http://www.emacswiki.org/emacs/ColorTheme#toc9
(setq color-theme-choices 
      '(color-theme-tangotango color-theme-tangotango))

;; default-start
(funcall (lambda (cols)
    	   (let ((color-theme-is-global nil))
    	     (eval 
    	      (append '(if (window-system))
    		      (mapcar (lambda (x) (cons x nil)) 
    			      cols)))))
    	 color-theme-choices)

;; test for each additional frame or console
(require 'cl)
(fset 'test-win-sys 
      (funcall (lambda (cols)
    		 (lexical-let ((cols cols))
    		   (lambda (frame)
    		     (let ((color-theme-is-global nil))
		       ;; must be current for local ctheme
		       (select-frame frame)
		       ;; test winsystem
		       (eval 
			(append '(if (window-system frame)) 
				(mapcar (lambda (x) (cons x nil)) 
					cols)))))))
    	       color-theme-choices ))
;; hook on after-make-frame-functions
(add-hook 'after-make-frame-functions 'test-win-sys)

(color-theme-tangotango)

;; line duplication
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank)
  (move-beginning-of-line 1)
  )
(global-set-key (kbd "C-q") 'duplicate-line)

;; matching paranthesis
(global-set-key "%" 'match-paren)

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
	(t (self-insert-command (or arg 1)))))

;; Go to line (default: \M-g-g)
(global-set-key "\M-g" 'goto-line)

;; Hide splash-screen and startup-message
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(defun toggle-full-screen ()
  "Toggles full-screen mode for Emacs window on Win32."
  (interactive))

(defun toggle-bars ()
  "Toggles bars visibility."
  (interactive)
  (menu-bar-mode)
  (tool-bar-mode)
  (scroll-bar-mode))

(defun toggle-full-screen-and-bars ()
  "Toggles full-screen mode and bars."
  (interactive)
  (toggle-bars)
  (toggle-full-screen))

;; Use F11 to switch between windowed and full-screen modes
(global-set-key [f11] 'toggle-full-screen-and-bars)

;; Switch to full-screen mode during startup
(toggle-full-screen-and-bars)

;; The most important!! Expand region..
(add-to-list 'load-path "~/.emacs.d/expand-region")
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)