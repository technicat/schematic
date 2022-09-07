; support functions for file processing

(use file.util)

; todo - add follow-symlinks option
(define (dir-help)
 (print "-h : show this doc")
 (print "-d : process dot (hidden) files")
 (print "-t : file extension to filter for, e.g. scm, json...")
 (print "-v : print progress"))

(define (dir-info path :key (type #f) (dot-files #f) (verbose #f))
 (print #"checking files in ~path")
 (if type
  (print #"with extension ~type"))
 (if dot-files
  (print "including dot (hidden) files")
  (print "ignoring dot (hidden) files"))
 (if verbose
  (print "verbose is on")
  (print "verbose is off")))

; todo - make type a list
(define (ignore-file? file :key (type #f) (dot-files #f) (verbose #f))
 (let-values (((dir name ext) (decompose-path file)))
  (let ((ignore (or
                 (and (not dot-files) (eq? (string-ref name 0) #\.))
                 (and type ext
                  (file-is-regular? file)
                  (not (string=? ext type))))))
   (if (and verbose ignore)
    (print #"Ignoring ~file"))
   ignore)))

(define (filter-dir dir :rest args)
 (remove
  (lambda (file)
   (apply ignore-file? file args))
  (directory-list dir :add-path? #t :children? #t)))


