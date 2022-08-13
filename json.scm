#!/usr/local/bin/gosh

(use gauche.parseopt)
(use rfc.json)

(include "lib/dir.scm")

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (d "d|dot-files")
   (f "f|file=s")
   (r "r|replace")
   (t "t|type=s" "json")
   (v "v|verbose")
   . restargs
   )
  (if (not h)
   (if f
    (json-file f p)
    (let ((count (json-dir (current-directory) :type t :dot-files d :verbose v)))
     (print #"Checked ~count JSON files"))))))

(define help
 (lambda (file)
  (print "Validate JSON in file or current directory (and below).")
  (dir-help)
  ))

; todo - should return json results
(define json-dir
 (lambda (path :rest args)
  (apply dir-info path args)
  (print #"checking all files in ~path")
  (directory-fold path
   (lambda (file result)
    (json-file file)
    (+ 1 result))
   0
   :lister
   (lambda (dir seed)
    (values (apply filter-dir dir args)
     seed)))))

(define json-file
 (lambda (file)
  (guard (e (else (print #"JSON error in ~file")
             (print (condition-message e))
             #\f))
   (let ((exp (call-with-input-file file parse-json)))
    ;  (if verbose (print exp))
    ; todo - option to write file back out
    exp))))

