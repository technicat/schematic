#!/usr/local/bin/gosh

(use gauche.parseopt)
(use rfc.http)
(use rfc.uri)

(include "lib/dir.scm")
(include "lib/rx.scm")

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (c "c|check")
   (d "d|dot-files")
   (f "f|file=s")
   (t "t|type=s")
   (v "v|verbose")
   . restargs)
  (if (not h)
   (let ((matches
          (if f
           (rx-file f urlre :verbose v)
           (rx-dir (current-directory) urlre
            :type t :dot-files d :verbose v))))
    (if v (print #"Found ~(length matches) total links"))
    (let ((unique (delete-duplicates matches)))
     (print #"Found ~(length unique) unique links")
     (report-bad-urls unique)
     (if c
      (check-connections (filter check-url unique))))))))


(define (help file)
 (print "Search/check URLs in file or in current directory (and below).")
 (dir-help))

(define (report-bad-urls unique)
 (let ((noturl (remove check-url unique)))
  (print #"Found ~(length noturl) obviously bad links")
  (print (string-join noturl "\n"))))

(define (check-url link)
 (let ((host (uri-ref link 'host))
       (path (uri-ref link 'path)))
  (if (not host)
   (print #"Missing host in ~link"))
  (if (not path)
   ; this should be more of a warning, it's OK in the RFC
   (print #"Missing path in ~link - try adding an ending / to the host"))
  (and host path)))

(define (check-connections unique)
 (let ((invalid (remove check-connection unique)))
  (print #"Failed ~(length invalid) links")
  (print (string-join invalid "\n"))))

(define (check-connection link)
 (let ((host (uri-ref link 'host))
       (path (uri-ref link 'path)))
  (print #"Connecting to host: ~host path: ~path")
  (guard (e (else (print #"Could not validate ~link")
             (print (condition-message e))
             #f))
   (let-values (((result headers body)
                 (http-get host (or path "/")))) ; http-get doesn't like #f path
    ; should return http codes so we can display them
    (or
     (string=? result "200") ; OK
     (string=? result "308") ; redirect - todo, report this
     )))))

; place this here at the end to avoid confusing my indenter

; https://urlregex.com/
; doesn't handle parentheses
; only care about http(s)
; should have a lax version that captures improper ones e.g. with non-ASCII
; so we can report and fix
(define urlre
 #/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/
 )
