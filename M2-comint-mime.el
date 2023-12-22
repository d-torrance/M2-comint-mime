;; usual header stuff

(require 'comint-mime)
(require 'M2)

(defun M2-comint-mime-setup ()
  (comint-send-string (car (M2--get-send-to-buffer))
		      "printerr \"Setting up M2-comint-mime!\"
oldshow = lookup(show, URL);
show URL := url -> (
    if (m := regex(\"^file://(.*)\", first url)) =!= null
    then (
	file := substring(m#1, first url);
	type := first lines get(\"!file -b --mime \" | file);
	print(\"\\033]5151;{\\\"type\\\": \\\"\" | type | \"\\\"}\\n\" |
	    first url | \"\\033\\\\\\n\"))
    else oldshow url);
"))

(push '(M2-comint-mode . M2-comint-mime-setup) comint-mime-setup-function-alist)

(provide 'M2-comint-mime)
