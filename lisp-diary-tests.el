;;; lisp-diary-tests.el --- Supporting tests
;;; Commentary:
;;
;; Diary tests
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

(ert-deftest test-add-days ()
  (with-temp-buffer
    (add-days 7)

    (mapcar
     (lambda (n)
       (or (re-search-forward
            (get-date-at-days-offset n) nil t))
       (re-search-backward
        (get-date-at-days-offset n))) (number-sequence 1 7))))

(ert-deftest test-words-list-rotations ()
  (let ((r (search-words-list-rotations '(1 2))))
    (should (or (and
                 (cl-every '= '(2 1) (cadr r))
                 (cl-every '= '(1 2) (car r)))
                (and
                 (cl-every '= '(2 1) (car r))
                 (cl-every '= '(1 2) (cadr r))))))

  (let ((r (search-words-list-rotations '(1))))
    (should (and (= 1 (caar r))
                 (= 1 (length r))))))

(ert-deftest test-words-permutations ()
  (let ((r (search-words-permutations '())))
    (should (= 0 (length r))))
  (let ((r (search-words-permutations '(1))))
    (should (= 1 (length r))))
  (let ((r (search-words-permutations '(1 2 3))))
    (should (= 6 (length r))))
  (let ((r (search-words-permutations '(1 2 3 4))))
    (should (= 24 (length r))))
  )

(ert-deftest test-topic-search ()
  (should
   (eq 5
       (with-temp-buffer
         (mapc (lambda (n) (insert (format "[topic%sa topic%sb] abc %s %s\n"
                                           n (1+ n) n (1+ n))))
               (number-sequence 1 100))
         (topic-search t "topic6b topic5a")
         (line-number-at-pos)
         ))))

(provide 'lisp-diary-tests)
;;; lisp-diary-tests.el ends here
