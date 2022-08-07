#!/usr/local/bin/gosh

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
  (letrec ((iso ".fr") ; add tw, etc
           (term (string-append "\\" iso "\"")) ; look for missing end slash
           (replace (string-append iso "/\""))
           (match (rxmatch->string term line)))
   (if (not match)
    (begin
     (write-string line out)
     (newline out)
     count)
    (let ((prefix (string-scan line match 'before)))
       (write-string
        (string-append (or prefix "") replace
          (or (string-scan line match 'after) ""))
        out)
       (newline out)
       (+ 1 count))))))



