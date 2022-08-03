#!/usr/local/bin/gosh

(include "utils.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (t "t|type=s")
       . restargs
      )
    (if h
        (begin 
            (print "lines.scm -h -f file -t type")
            (print "Count lines in a file or files.")
            (print "If no file specified, recursively process files in current directory.")
            (print "Specify a file type (suffix) to filter.")
            (print "Examples:")
            (print "lines.scm -h")
            (print "lines.scm -f countlines.scm")
            (print "lines.scm -t scm"))
        (let ((count 
            (if f
                (call-with-input-file f count-input)
                (count-current-directory t))))
            (print #"Found ~count lines")))))

(define count-current-directory
    (lambda (type)
        (count-directory (current-directory) type)))

(define count-directory
    (lambda (path type) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (call-with-input-file file count-input)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir type)
                    seed)))))

(define count-input
    (lambda (p)
        (let f ((total 0))
            (guard (e (else total)) ; bail out of binary
             (if (eof-object? (read-line p))
                total
                (f (+ 1 total)))))))
