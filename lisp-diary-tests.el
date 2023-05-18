;;; lisp-diary-tests.el --- Supporting tests
;;; Commentary:
;;
;; Note taking, broken by days, with elisp as a major mode.
;;
;;; Code:
(require 'ert)
(require 'lisp-diary)

(ert-deftest test-get-date-at-days-offset ()
  (let ((n 0))
    (should (equal 0
             (days-between (current-time-string) (get-date-at-days-offset 0))))))


(provide 'lisp-diary-tests)
;;; lisp-diary-tests.el ends here
