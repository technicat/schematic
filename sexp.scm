#!/usr/local/bin/gosh

; don't really have a use for this, just here for completeness

(use gauche.parseopt)

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
    (json-file f p)
    (let ((count (sexp-dir (current-directory) :type t :dot-files d :verbose v)))
     (print #"Checked ~count files"))))))

(define (help file)
 (print "Validate s expressions in file or current directory (and below).")
 (dir-help))

; todo - should return json results
(define (sexp-dir path :rest args)
 (apply dir-info path args)
 (directory-fold path
  (lambda (file result)
   (sexp-file file)
   (+ 1 result))
  0
  :lister
  (lambda (dir seed)
   (values (apply filter-dir dir args)
    seed))))

(define (sexp-file file)
 (guard (e (else (print #"error in ~file")
            (print (condition-message e))
            #\f))
  (let ((exp (call-with-input-file file sexp-input)))
   exp)))


(define (sexp-input p)
 (let ((x (read p)))
  (if (eof-object? x)
   '()
   x)))

