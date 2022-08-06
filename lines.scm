#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help" => (cut help (car args)))
        (d "d|dot-files")
        (f "f|file=s")
        (t "t|type=s")
        (v "v|verbose")
       . restargs
      )
    (if (not h)
        (let ((count 
            (if f
                (count-file f)
                (count-directory (current-directory) 
                    :type t :dot-files d :verbose v))))
            (print #"Found ~count lines")))))

(define help
    (lambda (file)
        (print "Count number lines in file or current directory (and below).")
        (dir-help)
))

(define count-directory
    (lambda (path :rest args)
        (apply dir-info path args)
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (count-file file)))
            0
            :lister
            (lambda (dir seed)
                (values (apply filter-dir dir args)
                    seed)))))

(define count-file
    (lambda (file)
      (guard (e (else 
                    (print #"Error processing ~file")
                    (print (condition-message e))
                    0)) ; bail out of binary
        (call-with-input-file file count-input)
    )))

(define count-input
    (lambda (p)
        (let f ((total 0))
            (guard (e (else total)) ; bail out of binary
             (if (eof-object? (read-line p))
                total
                (f (+ 1 total)))))))
