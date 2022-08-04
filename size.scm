#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (i "i|file")
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
            (print "size.scm -i")
            (print "size.scm -f countlines.scm")
            (print "size.scm -t scm"))
        (let ((count 
            (if f
                (file-size f)
                (size-current-directory :type t :ignore-hidden i))))
            (print #"~count bytes")))))

(define size-current-directory
    (lambda (:key (type #f) (ignore-hidden #f))
        (size-directory (current-directory) :type type :ignore-hidden ignore-hidden)))

(define size-directory
    (lambda (path :key (type #f) (ignore-hidden #f)) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (file-size file)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir :type type :ignore-hidden ignore-hidden)
                    seed)))))
