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
       . restargs
      )
    (if (not h)
        (if f
            (json-file f p)
            (let ((count (json-dir (current-directory) :type t :dot-files d :verbose v)))
                (print #"Checked ~count JSON files"))))))

(define help
    (lambda (file)
        (print "Validate JSON files in current directory (and below).")
        (dir-help)
))

(define json-dir
    (lambda (path :key (type "json") (dot-files #f) (verbose #f)) 
        (if type
            (print #"checking all files in ~path with extension ~type"))
        (directory-fold path
            (lambda (file result)
                    (json-file file :verbose verbose)
                    (+ 1 result))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir
                    :type "json" :verbose verbose :dot-files dot-files)
                    seed)))))

(define json-file
    (lambda (file :key (verbose #f))
        (guard (e (else (print #"JSON error in ~file")
                        (print (condition-message e))
                        #\f))
            (let ((exp (call-with-input-file file parse-json)))
                (if verbose (print exp))
                exp))))

