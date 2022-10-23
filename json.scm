#!/usr/local/bin/gosh

(use gauche.parseopt)
(use rfc.json)

(include "lib/dir.scm")

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (d "d|dot-files")
   (f "f|file=s")
   (t "t|type=s" "json")
   (v "v|verbose")
   . restargs)
  (if (not h)
   (if f
    (let ((objs (call-with-input-file f parse-json*)))
     (print #"Found ~(length objs) JSON objects"))
    (let ((count (json-dir (current-directory)
                  :type t :dot-files d :verbose v)))
     (print #"Checked ~count JSON files"))))))

(define (help file)
 (print "Validate JSON in file or current directory (and below).")
 (dir-help))

(define (json-dir path :rest args)
 (apply dir-info path args)
 (directory-fold path
  (lambda (file result)
   (guard (e (else (print #"JSON error in ~file")
              (print (condition-message e))
              result))
    (call-with-input-file file parse-json*)
    (+ 1 result)))
  0
  :lister
  (lambda (dir seed)
   (values (apply filter-dir dir args)
    seed))))

