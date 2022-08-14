#!/usr/local/bin/gosh

; messing around with formatting
; not sure where this is going

(use gauche.parseopt) ; command line args

(include "lib/dir.scm")

(define (main args)
 (let-args (cdr args)
  ((f "f|file=s")
   . restargs)
  (format-file f)))

(define (format-file file)
  (call-with-input-file file format-input))

(define (format-input p)
  (let ((x (read p)))
   (if (eof-object? x)
    '()
    (begin
     (format-exp x 0)
     (newline)
     (format-input p)))))

(define (format-exp exp indent)
  (if (list? exp)
   (begin
    (newline)
    (spaces indent)
    (write-char #\()
    (format-list exp (+ 1 indent))
    (write-char #\)))
   (write exp)))

(define (format-list exp indent)
  (if (null? exp)
   ()
   (begin
    (format-exp (car exp) indent)
    (if (not (null? (cdr exp)))
     (spaces 1))
    ;  (separator (cdr exp) indent)
    (format-list (cdr exp) indent))))

(define (separator exp indent)
  (cond ((null? exp)
         (spaces 0))
   ((list? exp)
    (begin
     (newline)
     (spaces indent)))
   (else
    (spaces 1))))


(define (spaces num)
  (let f ((x num))
   (if (> x 0)
    (begin
     (write-char #\ )
     (f (- x 1))))))


