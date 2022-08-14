#!/usr/local/bin/gosh

(use gauche.parseopt)
(use file.filter)
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
    (json-file f)
    (let ((count (json-dir (current-directory) :type t :dot-files d :verbose v)))
     (print #"Rewrote ~count JSON files"))))))

(define (help file)
 (print "Validate JSON in file or current directory (and below).")
 (dir-help))

; todo - should return json results
(define (json-dir path :rest args)
  (apply dir-info path args)
  (directory-fold path
   (lambda (file result)
    (guard (e (else (print #"JSON error in ~file")
               (print (condition-message e))
               result))
     (json-file file)
     (+ 1 result))
    0
    :lister
    (lambda (dir seed)
     (values (apply filter-dir dir args)
      seed)))))

 (define (json-file file)
  (file-filter json-filter
   :input file :output file
   :temporary-file #t
   :leave-unchanged #t))

 (define (json-filter in out)
   (let f ((objs (parse-json* in)))
    (if (not (null? objs))
        (construct-json (car objs) out))))

