#!/usr/local/bin/gosh

(use gauche.parseopt)

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help))
   (l "l|lint" => (cut lint))
   (l "f|format" => (cut format))
   . restargs)
  ))

(define (help)
 (print "swift-format shortcuts"))

(define (lint)
 (sys-system #"swift-format lint -r .")
 )

(define (format)
 (sys-system #"swift-format format -i -r .")
 )
