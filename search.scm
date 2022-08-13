#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")
(include "lib/rx.scm")

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (d "d|dot-files")
   (f "f|file=s")
   (t "t|type=s")
   (r "r|regexp=s")
   (v "v|verbose")
   . restargs
   )
  (if (not h)
   (let ((matches
          (if f
           (rx-file f r :verbose v)
           (rx-dir (current-directory) r :type t :verbose v))))
    (print #"Found ~(length matches) matches")))))

(define (help file)
 (print "Search for regexp in file or in current directory (and below).")
 (dir-help)
 )

