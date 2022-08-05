#!/usr/local/bin/gosh

(use gauche.parseopt)
(use rfc.http)
(use rfc.uri)

(include "lib/dir.scm")
(include "lib/rx.scm")

; https://urlregex.com/
; doesn't handle parentheses
(define urlre #/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/ )

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
       (c "c|check")
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
        (let ((matches
                (if f
                    (rx-file f urlre :print-line p)
                    (rx-current-directory urlre :type t :print-line p))))
            (print #"Found ~(length matches) total links")
            (let ((unique (delete-duplicates matches)))
                (print #"Found ~(length unique) unique links")
                (if c 
                    (print #"Validated ~(count check unique) unique links")))))))

(define check
    (lambda (link)
        (print #"Validating ~link")
        (guard (e (else (print #"Could not validate ~link")
                            (print (condition-message e))
                            #f))
         (let-values (((result headers body)
                (http-get (uri-ref link 'host) (uri-ref link 'path))))
            (equal? result "200")))))