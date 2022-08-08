#!/usr/local/bin/gosh

; fix common url issues
; currently just repairs missing trailing slash
; todo - urlencode

(use gauche.parseopt) ; command-line
(use file.filter) ; file-filter-fold
(use srfi-13) ; string-scan

(include "lib/dir.scm")

(define (main args)
 (let-args (cdr args)
  ((h "h|help" => (cut help (car args)))
   (d "d|dot-files")
   (f "f|file=s")
   (t "t|type=s")
   (v "v|verbose")
   . restargs
   )
  (if (not h)
   (let ((urls (if f
                (fix-file f)
                (fix-dir (current-directory)
                 :type t :dot-files d :verbose v))))
    (print #"Fixed ~urls urls")))))

(define help
 (lambda (file)
  (print "Replace text in file or current directory (and below).")
  (dir-help)
  ))

(define fix-dir
 (lambda (path :rest args)
  (apply dir-info path args)
  (directory-fold path
   (lambda (file result)
    (+ result (fix-file file)))
   0
   :lister
   (lambda (dir seed)
    (values (apply filter-dir dir args)
     seed)))))

(define fix-file
 (lambda (file)
  (guard (e (else
             (print #"Error processing ~file")
             (print (condition-message e))
             0))
   (file-filter-fold fix-fold 0 :input file :output file :temporary-file #t))))

(define fix-fold
 (lambda (line count out)
  (let ((match (rxmatch
                #/\.(((ar)|(at)|(au)|(be)|(ca)|(cl)|(com)|(de)|(dk)|(es)|(fr)|(hk)|(id)|(ie)|(it)|(jp)|(kh)|(kr)|(mo)|(mu)|(mx)|(my)|(nl)|(no)|(nz)|(ph)|(pl)|(pt)|(se)|(sg)|(th)|(tt)|(tw)|(ua)|(uk)|(vn)))"/
                line)))
   (if (not match)
    (begin
     (write-string line out)
     (newline out)
     count)
    (let ((new (string-append (match 'before 1) (match 1) "/" (match 'after 1))))
     (print new)
     (write-string new out)
     (newline out)
     (+ 1 count))))))



