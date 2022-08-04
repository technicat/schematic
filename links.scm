#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "dir.scm")
(include "rx.scm")

; https://urlregex.com/
; doesn't handle parentheses
(define urlre #/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/ )

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (t "t|type=s")
        (p "p|printline")
       . restargs
      )
    (if h
        (begin 
            (print "links.scm -h -f file -t type")
            (print "Count links in a file or files.")
            (print "If no file specified, recursively process files in current directory.")
            (print "Specify a file type (suffix) to filter.")
            (print "Examples:")
            (print "links.scm -h")
            (print "links.scm -f countlines.scm")
            (print "links.scm -t scm"))
        (let ((count 
            (if f
                (rx-file f urlre p)
                (rx-current-directory urlre t p))))
            (print #"Found ~count links")))))

