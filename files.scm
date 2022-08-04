#!/usr/local/bin/gosh

(include "dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (t "t|type=s")
       . restargs
      )
    (if h
        (begin
            (print "files.scm -h -t type")
            (print "Count number of files in current directory (and below).")
            (print "Specify a file type (suffix) to filter.")
            (print "Examples:")
            (print "files.scm -h")
            (print "files.scm -t scm")
            (print "files.scm")
        )
        (let ((count 
                (count-current-directory t)))
            (print #"Found ~count files")))))

(define count-current-directory
    (lambda (type)
        (count-directory (current-directory) type)))

(define count-directory
    (lambda (path type) 
        (directory-fold path
            (lambda (file result)
                (+ result 1))
            0
            :lister
             (lambda (dir seed)
                (values (filter-dir dir type)
                    seed)))))


