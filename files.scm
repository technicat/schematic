#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help" => (cut help (car args)))
        (t "t|type=s")
       . restargs
      )
    (let ((count 
            (count-directory (current-directory) :type t)))
        (print #"Found ~count files"))))

(define help
    (lambda (file)
        (print "Count number of files in current directory (and below).")
        (dir-help)
))

(define count-directory
    (lambda (path :rest args) 
        (directory-fold path
            (lambda (file result)
                (+ result 1))
            0
            :lister
             (lambda (dir seed)
                (values (apply filter-dir dir args)
                    seed)))))


