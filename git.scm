#!/usr/local/bin/gosh

(use gauche.parseopt)

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   . restargs)
  (if (not h)
   (update-submodules))))

(define (help file)
 (print "git operations"))

(define (update-submodules)
 (sys-system #"git submodule update --remote --merge")
 )


