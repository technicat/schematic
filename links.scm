#!/usr/local/bin/gosh

(include "dir.scm")
(include "rx.scm")

(define urlre #/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/ )

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (t "t|type=s")
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
                (rx-file f urlre)
                (rx-current-directory urlre t))))
            (print #"Found ~count links")))))

