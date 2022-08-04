#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (t "t|type=s")
       . restargs
      )
    (if h
        (begin 
            (print "size.scm -h -f file -t type")
            (print "Total size of a file or files.")
            (print "If no file specified, recursively process files in current directory.")
            (print "Specify a file type (suffix) to filter.")
            (print "Examples:")
            (print "size.scm -h")
            (print "size.scm -f countlines.scm")
            (print "size.scm -t scm"))
        (let ((count 
            (if f
                (file-size f)
                (count-current-directory t))))
            (print #"~count bytes")))))

(define count-current-directory
    (lambda (type)
        (count-directory (current-directory) type)))

(define count-directory
    (lambda (path type) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (file-size file)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir type)
                    seed)))))
