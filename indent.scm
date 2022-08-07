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
        (if f
            (indent-file f)
            (let ((files (indent-dir (current-directory) 
                    :type t :dot-files d :verbose v)))
                (print #"Indented ~count ~files"))))))

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
                (if (indent-file file)
                    (+ 1 result)
                    result))
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
                    (print (condition-message e))
                    #f))
            (file-filter indent-input :input file)
    )))

(define indent-input
    (lambda (p out)
        (let f ((columns '()))
                (let ((line (read-line p)))
                    (if (eof-object? line)
                        #t
                        (let ((new (string-trim-both line)))
                            (if (> (string-length new) 0)
                                (let ((column (if (null? columns)
                                                0
                                             (car columns))))
                                    (write-string 
                                        (string-pad new (+ column                   (string-length new))))))
                            (newline)
                            (f (new-columns new columns))))))))

(define new-columns
    (lambda (s columns)
        (let ((column
                (if (null? columns)
                     0
                    (car columns))))
            (string-for-each 
                (lambda (c)
                    (set! column (+ 1 column))
                    (cond ((eq? c #\()
                        (push! columns column))
                        ((eq? c #\))
                        (pop! columns))))
                s)
             columns)))