#!/usr/local/bin/gosh

(use gauche.parseopt) ; command-line
(use file.filter) ; file-filter-fold
(use srfi-13) ; string trim and pad

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
     (print #"Indented ~files files"))))))

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
  (guard (e (else
             (print #"Error processing ~file")
             (print (condition-message e))
             #f))
   (file-filter-fold indent-fold '() :input file :output file :temporary-file #t))))

(define indent-fold
 (lambda (line columns out)
  (let ((new (string-trim-both line)))
   (if (> (string-length new) 0)
    (let ((column (if (null? columns)
                   0
                   (car columns))))
     (write-string
      (string-pad new (+ column
                       (string-length new)))
      out)))
   (newline out)
   (if (or
        (= (string-length new) 0)
        (eq? (string-ref new 0) #\;))
    columns
    (new-columns new columns)))))

(define new-columns
 (lambda (s columns)
  (let f ((chars (string->list s))
          (col (if (null? columns)
                0
                (car columns)))
          (cols columns))
   (if (null? chars)
    cols
    (case (car chars)
     ((#\()
      (f (cdr chars) (+ 1 col) (cons (+ 1 col) cols)))
     ((#\))
      (f (cdr chars) (+ 1 col) (if (null? cols)
                                cols
                                (cdr cols))))
     ; doesn't handle character names
     ; or regex
     ((#\#)
      (let-values (((chars col) (hash (cdr chars) (+ 1 col))))
       (f (cdr chars) (+ 1 col) cols)))
     ((#\")
      (let-values (((chars col) (quotation (cdr chars) (+ 1 col))))
       (f (cdr chars) (+ 1 col) cols)))
     ((#\;)
      cols)
     (else
      (f (cdr chars) (+ 1 col) cols)))))))

(define hash
 (lambda (chars col)
  (if (null? chars)
    (values chars col)
    (case (car chars)
     ((#\\) ; char
      (character))
      (else 
      (values (cdr chars) (+ 1 col)))))))

; skip to end of char
(define character
 (lambda (chars col)
  (if (null? chars)
    (values chars col)
   (values (cdr chars) (+ 1col)))))

; skip to end of quote
(define quotation
 (lambda (chars col)
  (if (or (null? chars)
       (eqv? #\" (car chars)))
   (values chars col)
   (quotation (cdr chars) (+ 1 col)))))
