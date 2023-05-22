;;; lisp-diary.el --- Note taking w/ elisp -*- lexical-binding:t -*-
;;; Commentary:
;;
;; Note taking, broken by days, with elisp as a major mode.
;;
;;; Code:

(defcustom lisp-diary-path ""
  "Path to the notes files."
  :type 'file :group 'lisp-diary)

(defcustom lisp-diary-date-line-format ";; %s\n"
  "Format of comment line indicating the date."
  :type 'string :group 'lisp-diary)

(defcustom lisp-diary-day-notes-template "\"\"\n"
  "Template for a day's notes."
  :type 'string :group 'lisp-diary)

(defcustom lisp-diary-date-format "%a %b %d %Y"
  "Format of date in comment line."
  :type 'string :group 'lisp-diary)

(defun get-date-at-days-offset (n &optional fmt)
  "Get string formatted day N days from today.
See `format-time-string' for details on FMT.
should return."
  (let* ((date-format (or fmt lisp-diary-date-format))
         (now (time-to-seconds))
         (seconds-per-day (* 24 3600)))
    (format-time-string date-format (+ (* n seconds-per-day) now))
    ))

(defun next-days (n start &optional fmt)
  "Return a list of string formatted days for the next N days.
START must be an integer specifying the initial date as offset days from today.
Dates in list are sorted in descending order.
See `format-time-string' for details on FMT."
  (reverse
   (mapcar
    (lambda (n) (get-date-at-days-offset n fmt))
    (number-sequence start n))))

(defun next-days-formatted (n start &optional fmt day-notes-template)
  "Get string of next N days, formatted with `lisp-diary-date-line-format'.
See `next-days' for details on START and FMT.
DAY-NOTES-TEMPLATE overrides `lisp-diary-day-notes-template'."
  (string-join
   (mapcar (lambda (d) (format "%s%s"
                               (format lisp-diary-date-line-format d)
                               (or day-notes-template
                                   lisp-diary-day-notes-template)))
           (next-days n start fmt))))

(defun add-days (n)
  "Add N days to notes file, starting from today.
N must be a positive integer."
  (interactive "nNumber of days: ")
  (insert (next-days-formatted n 1)))

(defun notes-skeleton (filename)
  "Template for a notes file pointed at FILENAME."
  (format ";;; %s --- notes w/ elisp -*- mode:emacs-lisp; -*-
;;; Commentary:

;; Note taking, broken by days, with elisp as a major mode.

;;; Code:

%s%s

;;; %s ends here
" filename
(next-days-formatted 30 1)
(next-days-formatted 0 0 nil "\"TODO:\n* ...\"\n") filename))

(defun new-notes-path-prompt ()
  "Prompt for new notes path and save it."
  (let ((notes-path (read-file-name
                     "Notes path unset. Choose notes path: "
                     (expand-file-name "~/notes/") nil
                                nil "")))
    (customize-save-variable 'lisp-diary-path notes-path)))

(defun todays-notes (filename)
  "Open notes in FILENAME and set location to today's date.
If new file, add initial content."
  (interactive (list (if (string= "" lisp-diary-path)
                         (new-notes-path-prompt)
                       lisp-diary-path)))
  (when filename
    (find-file (expand-file-name lisp-diary-path))
    (when (not (file-exists-p filename))
      (insert (notes-skeleton
               (file-name-nondirectory lisp-diary-path))))
    (when
        (or (search-forward (get-date-at-days-offset 0) nil t)
            (search-backward (get-date-at-days-offset 0)))
      (forward-line) (forward-char))
    ))

(defun search-words-list-rotations (l)
  "Return all possible rotations for list L."
  (cl-reduce (lambda (r _)
               (cons (append (cdr (car r))
                             (list (car (car r)))) r))
             (number-sequence 1 (- (length l) 1))
             :initial-value (list l)))

(defun search-words-permutations (words)
  "Get all possible permutations of WORDS provided for search."
  (named-let perm
      ((prefix '()) (rem (search-words-list-rotations words))
       (res '()) (len (length words)))
    (if-let ((selection (car rem)))
        (let ((new-prefix (cons (caar rem)
                                (last prefix (- len (length (car rem)))))))
          (perm new-prefix
                (append (when-let ((suffix (cdr (car rem))))
                          (search-words-list-rotations suffix)) (cdr rem))
                (if (= len (length new-prefix)) (cons new-prefix res) res)
                len))
      res)))

(defun topic-search (search keywords)
  "Search forward for KEYWORDS in brackets.
If SEARCH (with prefix), search forward and backward in buffer.
Use `repeat' \\[repeat] to search forward again."
  (interactive "P\nsKeywords: ")
  (let* ((opening-bracket "\\[")
         (closing-bracket "\\]")
         (pipe "\\|")
         (regex (string-join
                (mapcar
                 (lambda (word-list)
                   (string-join `(,opening-bracket
                                  "[^][]*" ,(string-join word-list "[^][]*")
                                  "[^][]*" ,closing-bracket))
                   )
                 (search-words-permutations (split-string keywords " ")))
                pipe)))
    (if search (or (re-search-forward regex nil t)
                   (re-search-backward regex))
      (occur regex)
      )))

(provide 'lisp-diary)

;;; End:
;;; lisp-diary.el ends here
