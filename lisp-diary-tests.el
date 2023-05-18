;;; lisp-diary-tests.el --- Supporting tests
;;; Commentary:
;;
;; Note taking, broken by days, with elisp as a major mode.
;;
;;; Code:
(require 'ert)
(require 'lisp-diary)

(ert-deftest test-get-date-at-days-offset ()
  (should (string-equal (format-time-string lisp-diary-date-format)
                        (get-date-at-days-offset 0)))
  (should (not
           (string-equal (get-date-at-days-offset 40 "%m")
                         (get-date-at-days-offset 0 "%m"))))
  (should (not
           (string-equal (get-date-at-days-offset -40 "%m")
                         (get-date-at-days-offset 0 "%m"))))
  (should (> (cl-parse-integer (get-date-at-days-offset 400 "%Y"))
             (cl-parse-integer (get-date-at-days-offset 0 "%Y"))))
  (should (< (cl-parse-integer (get-date-at-days-offset -400 "%Y"))
             (cl-parse-integer (get-date-at-days-offset 0 "%Y")))))



(provide 'lisp-diary-tests)
;;; lisp-diary-tests.el ends here
