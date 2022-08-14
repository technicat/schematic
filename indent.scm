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
   . restargs)
  (if (not h)
   (if f
    (indent-file f)
    (let ((files (indent-dir (current-directory)
                  :type t :dot-files d :verbose v)))
     (print #"Indented ~files files"))))))

(define (help file)
 (print "Indent lines in file or current directory (and below).")
 (dir-help))

(define (indent-dir path :rest args)
 (apply dir-info path args)
 (directory-fold path
  (lambda (file result)
   ; this should be a macro, for use with every file filter
   (let ((perm (slot-ref (sys-stat file) 'perm)))
    (if (indent-file file)
     (begin
      (sys-chmod file perm)
      (+ 1 result))
     result)))
  0
  :lister
  (lambda (dir seed)
   (values (apply filter-dir dir args)
    seed))))

(define (indent-file file)
 (guard (e (else
            (print #"Error processing ~file")
            (print (condition-message e))
            #f))
  (file-filter-fold indent-fold '()
   :input file
   :output file
   :temporary-file #t
   :leave-unchanged #t)))

(define (indent-fold line columns out)
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
   (new-columns new columns))))

(define (new-columns s columns)
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
    ((#\#)
     (let-values (((chars col) (hash (cdr chars) (+ 1 col))))
      (f chars col cols)))
    ((#\")
     (let-values (((chars col) (quotation (cdr chars) (+ 1 col))))
      (f chars col cols)))
    ((#\;)
     cols)
    (else
     (f (cdr chars) (+ 1 col) cols))))))

(define (hash chars col)
 (if (null? chars)
  (values chars col)
  (case (car chars)
   ((#\\) ; char
    (escape (cdr chars) (+ 1 col)))
   ((#\/) ; regexp
    (regexp (cdr chars) (+ 1 col)))
   (else
    (values chars col)))))

; skip to end of escape
; todo - character names
(define (escape chars col)
 (if (null? chars)
  (values chars col)
  (values (cdr chars) (+ 1 col))))

; skip to end of quote
(define (quotation chars col)
 (if (null? chars)
  (values chars col)
  (case (car chars)
   ((#\\) ; char
    (let-values (((chars col)
                  (escape (cdr chars) (+ 1 col))))
     (quotation chars col)))
   ((#\")
    (values (cdr chars) (+ 1 col)))
   (else
    (quotation (cdr chars) (+ 1 col))))))

; skip to end of regexp
(define (regexp chars col)
 (if (null? chars)
  (values chars col)
  ; todo - check for escaped slash
  (if (eqv? #\/ (car chars))
   (values (cdr chars) (+ 1 col))
   (quotation (cdr chars) (+ 1 col)))))
