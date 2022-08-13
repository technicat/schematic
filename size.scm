#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (d "d|dot-files")
   (f "f|file=s")
   (t "t|type=s")
   (v "v|verbose")
   . restargs
   )
  (if (not h)
   (let ((count
          (if f
           (file-size f)
           (size-directory (current-directory)
            :type t :dot-files d :verbose v))))
    (print #"~count bytes")))))

(define (help file)
 (print "Size of file or files in current directory (and below).")
 (print "-f : specify file")
 (dir-help)
 )

(define (size-directory path :rest args)
 (apply dir-info path args)
 (directory-fold path
  (lambda (file result)
   (+ result
    (file-size file)))
  0
  :lister
  (lambda (dir seed)
   (values (apply filter-dir dir args)
    seed))))
