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
   (if f
    (indent-file f)
    (let ((files (indent-dir (current-directory)
                  :type t :dot-files d :verbose v)))
     (print #"Indented ~files files"))))))

(define help
 (lambda (file)
  (print "Replace text in file or current directory (and below).")
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
   (file-filter-fold indent-fold 0 :input file :output file :temporary-file #t))))

(define indent-fold
 (lambda (line count out)
  (letrec ((term ".com.tw\"")
           (prefix (string-scan line term 'before)))
   (if (not prefix)
    (begin 
    (write-string line out)
     (newline out)
     count)
    (begin
     (write-string
      (string-append prefix term (string-scan line term 'after))
      out)
        (newline out)
     (+1 count))))))



