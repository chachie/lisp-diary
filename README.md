# lisp-diary: a note taking diary with Lisp in major mode

lisp-diary.el provides a simple format for a flat file to write diary entries along LISP forms.

```elisp
;;; notes.el --- notes w/ elisp -*- mode:emacs-lisp; -*-
;;; Commentary:

;; Note taking, broken by days, with elisp as a major mode.

;;; Code:
;; Sun May 21 2023
""
;; Sat May 20 2023
""
;; Fri May 19 2023
""
;; Thu May 18 2023
"TODO:
* ..."

;;; notes.el ends here
```

The file can be located anywhere, and with version control.

Diary notes go in the `"..."` forms. Topics to refer to later on these notes can be indicated with the syntax `[topicA ...]`.

# Basic workflow: #

  * Initially, place the `lisp-diary.el` in your load path.
  * M-x todays-notes and choose the desired location for the notes.
  * M-x add-days will insert at cursor a number of new days to the diary.
  * M-x topic-search and enter some keywords to search existing topics.
    * with a prefix, search directly in the buffer, rather than using Occur.
