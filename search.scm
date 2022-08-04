#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "dir.scm")
(include "rx.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (t "t|type=s")
        (r "r|regexp=s")
        (m "m|match")
       . restargs
      )
    (if h
        (begin 
            (print "search.scm -h -f file -t type -m printmatch")
            (print "Search regexp in a file or files.")
            (print "If no file specified, recursively process files in current directory.")
            (print "Specify a file type (suffix) to filter.")
            (print "Examples:")
            (print "search.scm -h")
            (print "search.scm -f countlines.scm")
            (print "search.scm -t scm"))
        (let ((count 
            (if f
                (rx-file f r m)
                (rx-current-directory r t m))))
            (print #"Found ~count matches")))))
