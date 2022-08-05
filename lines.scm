#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help" => (cut help (car args)))
        (f "f|file=s")
        (t "t|type=s")
       . restargs
      )
    (if (not h)
        (let ((count 
            (if f
                (call-with-input-file f count-input)
                (count-directory (current-directory) t))))
            (print #"Found ~count lines")))))

(define help
    (lambda (file)
        (print "Count number lines in file or current directory (and below).")
        (dir-help)
))

(define count-directory
    (lambda (path type) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (call-with-input-file file count-input)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir :type type)
                    seed)))))

(define count-input
    (lambda (p)
        (let f ((total 0))
            (guard (e (else total)) ; bail out of binary
             (if (eof-object? (read-line p))
                total
                (f (+ 1 total)))))))
