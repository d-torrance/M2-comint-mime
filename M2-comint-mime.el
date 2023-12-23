;; usual header stuff

(require 'comint-mime)
(require 'M2)

(defun M2-comint-mime-setup ()
  "Setup code for `comint-mime-setup' in `M2-comint-mode' buffers."
  (with-current-buffer (car (M2--get-send-to-buffer))
    (end-of-buffer)
    (insert (concat
	     "needsPackage(\"ComintMime\", FileName => \""
	     (file-name-directory (symbol-file 'M2-comint-mime))
	     "ComintMime.m2\")"))
    (comint-send-input)))

(push '(M2-comint-mode . M2-comint-mime-setup) comint-mime-setup-function-alist)

(provide 'M2-comint-mime)
