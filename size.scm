#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help" => (cut help (car args)))
        (f "f|file=s")
        (d "d|dot-files")
        (t "t|type=s")
       . restargs
      )
    (if (not h)
        (let ((count 
            (if f
                (file-size f)
                (size-directory (current-directory) :type t :dot-files d))))
            (print #"~count bytes")))))

(define help
    (lambda (file)
        (print "Size of of file or files in current directory (and below).")
        (print "-f : specify file")
        (dir-help)
))

(define size-directory
    (lambda (path :rest args)
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (file-size file)))
            0
            :lister
            (lambda (dir seed)
                (values (apply filter-dir dir args)
                    seed)))))
