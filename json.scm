#!/usr/local/bin/gosh

(use gauche.parseopt)
(use rfc.json)

(include "lib/dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help" => (cut help (car args)))
        (f "f|file=s")
        (p "p|print")
       . restargs
      )
    (if (not h)
        (if f
            (json-file f p)
            (let ((count (json-current-directory :print-json p)))
                (print #"Checked ~count JSON files"))))))

(define help
    (lambda (file)
        (print "Validate JSON files in current directory (and below).")
        (dir-help)
))

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

