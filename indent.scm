#!/usr/local/bin/gosh

(use gauche.parseopt)

(include "lib/dir.scm")

(define (main args)
  (let-args (cdr args)
      ((h "h|help" => (cut help (car args)))
        (d "d|dot-files")
        (f "f|file=s")
        (t "t|type=s" "scm")
        (v "v|verbose")
       . restargs
      )
    (if (not h)
        (let ((count 
            (if f
                (indent-file f)
                (indent-dir (current-directory) 
                    :type t :dot-files d :verbose v))))
            (print #"Indented ~count lines")))))

(define help
    (lambda (file)
        (print "Indent lines in file or current directory (and below).")
        (dir-help)
))

(define indent-dir
    (lambda (path :rest args)
        (apply dir-info path args)
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (indent-file file)))
            0
            :lister
            (lambda (dir seed)
                (values (apply filter-dir dir args)
                    seed)))))

(define indent-file
    (lambda (file)
        (call-with-input-file file indent-input)
    ))

(define indent-input
    (lambda (p)
        (let f ((columns '()) (total 0))
            (guard (e (else total)) ; bail out of binary
             (if (eof-object? (read-line p))
                total
                ; starts with ( - indent more, push column
                ; starts with ) - pop column
                ; indent line
                (f column (+ 1 total)))))))
