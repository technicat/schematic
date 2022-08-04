#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")
(include "lib/rx.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (t "t|type=s")
        (r "r|regexp=s")
        (p "p|printline")
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
                (rx-file f r :print-line p)
                (rx-current-directory r :type t :print-line p))))
            (print #"Found ~count matches")))))

