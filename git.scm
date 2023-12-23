#!/usr/local/bin/gosh

(use gauche.parseopt)

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help))
   . restargs)
  (if (not h)
   (update-submodules))))

(define (help)
 (print "git operations"))

(define (update-submodules)
 (sys-system #"git submodule update --remote --merge")
 )