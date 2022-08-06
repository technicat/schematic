#!/usr/local/bin/gosh

(use gauche.parseopt)
(use file.filter)
(use srfi-13)


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
        ;(call-with-input-file file indent-input)
        (guard (e (else 
                    (print #"Error processing ~file")
                    (print (condition-message e)) ; should move this to caller
                    0)); bail out of binary, return false?
            (file-filter indent-input :input file)
    )))

(define indent-input
    (lambda (p out)
        (let f ((columns '()) (total 0))
                (let ((line (read-line p)))
                    (if (eof-object? line)
                        total
                        (let ((new (string-trim-both line))
                                (column 0))
                                (write-string (string-pad new (string-length new)))
                                (newline)
                            ; starts with ( - indent more, push column
                             ; starts with ) - pop column
                            (f columns (+ 1 total))))))))
