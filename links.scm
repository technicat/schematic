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
      ((h "h|help" => (cut help (car args)))
       (c "c|check")
        (d "d|dot-files")
        (f "f|file=s")
        (t "t|type=s")
        (v "v|verbose")
       . restargs
      )
    (if (not h)
        (let ((matches
                (if f
                    (rx-file f urlre :verbose v)
                    (rx-dir (current-directory) urlre 
                        :type t :dot-files d :verbose v))))
            (if v (print #"Found ~(length matches) total links"))
            (let ((unique (delete-duplicates matches)))
                (print #"Found ~(length unique) unique links")
                (if c 
                    (let ((invalid (remove check unique)))
                        (print #"Failed ~(length invalid) links")
                        (print (string-join invalid "\n")))))))))
(define help
    (lambda (file)
        (print "Search/check URLs in file or in current directory (and below).")
        (dir-help)
))

(define check
    (lambda (link)
        (let ((host (uri-ref link 'host))
                    (path (uri-ref link 'path)))
            (if (not path)
                (begin
                    (print #"Missing path in ~link - try adding an ending / to the host")
                    #f)
                (begin 
                    ; todo - verbose
                    (print #"Connecting to host: ~host path: ~path")
                    (guard (e (else (print #"Could not validate ~link")
                                    (print (condition-message e))
                                     #f))
                        (let-values (((result headers body)
                                        (http-get host path)))
                            (or (equal? result "200") ; OK
                                (equal? result "308") ; redirect - todo, report this
))))))))