#!/usr/local/bin/gosh

(include "utils.scm")

(use rfc.json)

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
            (let ((count (json-current-directory p)))
                (print #"Checked ~count JSON files"))))))

(define json-current-directory
    (lambda (p)
        (json-directory (current-directory) p)))

(define json-directory
    (lambda (path p) 
        (directory-fold path
            (lambda (file result)
                    (json-file file p)
                    (+ 1 result))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir "json")
                    seed)))))

(define json-file
    (lambda (file p)
        (guard (e (else (print (string-append "JSON error in " file))
                        (print (condition-message e))
                        #\f))
            (let ((exp (call-with-input-file file parse-json)))
                (if p (print exp))
                exp))))

