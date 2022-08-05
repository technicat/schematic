#!/usr/local/bin/gosh

(use gauche.parseopt)
(use rfc.json)

(include "lib/dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (p "p|print")
       . restargs
      )
    (if h
        (begin
            (print "json.scm -h -p -f file")
            (print "A JSON validator.")
            (print "Specify a file, or no file to recursively check the current directory.")
            (print "Examples:")
            (print "json.scm -h")
            (print "json.scm -f asset.json")
            (print "json.scm"))
        (if f
            (json-file f p)
            (let ((count (json-current-directory :print-json p)))
                (print #"Checked ~count JSON files"))))))

(define json-current-directory
    (lambda (:key (print-json #f))
        (json-directory (current-directory) :print-json print-json)))

(define json-directory
    (lambda (path :key (print-json #f)) 
        (directory-fold path
            (lambda (file result)
                    (json-file file :print-json print-json)
                    (+ 1 result))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir :type "json")
                    seed)))))

(define json-file
    (lambda (file :key (print-json #f))
        (guard (e (else (print #"JSON error in ~file")
                        (print (condition-message e))
                        #\f))
            (let ((exp (call-with-input-file file parse-json)))
                (if print-json (print exp))
                exp))))

