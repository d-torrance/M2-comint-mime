;;; M2-comint-mime.el --- Support comint-mime in M2 -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Doug Torrance

;; Author: Doug Torrance <dtorrance@piedmont.edu>
;; Created: 2023-12-22
;; Version: 0.1
;; Keywords: processes, multimedia
;; URL: https://github.com/d-torrance/M2-comint-mime
;; Package-Requires: ((comint-mime "0.1") (emacs "28.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package adds comint-mime support for Macaulay2 interaction buffers.

;;; Code:

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

;;; M2-comint-mime.el ends here
