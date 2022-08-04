#!/usr/local/bin/gosh

(include "utils.scm")

(define urlre #/((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/ )

(define (main args)
  (let-args (cdr args)
      ((h "h|help")
        (f "f|file=s")
        (t "t|type=s")
       . restargs
      )
    (if h
        (begin 
            (print "links.scm -h -f file -t type")
            (print "Count links in a file or files.")
            (print "If no file specified, recursively process files in current directory.")
            (print "Specify a file type (suffix) to filter.")
            (print "Examples:")
            (print "links.scm -h")
            (print "links.scm -f countlines.scm")
            (print "links.scm -t scm"))
        (let ((count 
            (if f
                (count-file f urlre)
                (count-current-directory urlre t))))
            (print #"Found ~count links")))))

(define count-current-directory
    (lambda (re type)
        (count-directory (current-directory) re type)))

(define count-directory
    (lambda (path re type) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (count-file file re)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir type)
                    seed)))))

(define count-file
    (lambda (file re)
        (print file)
        (call-with-input-file file
            (lambda (p)
                (count-input p re)))))


(define count-input
    (lambda (p re)
        (let f ((total 0) (linenum 1))
            (guard (e (else total)) ; bail out of binary
                (let ((line (read-line p)))
                (if (eof-object? line)
                    total
                    ; https://urlregex.com/
                    (let ((match (rxmatch->string re line)))
                        (if match
                            (begin 
                                (print #"line ~linenum : ~match")
                                (f (+ 1 total) (+ 1 linenum)))
                            (f total (+ 1 linenum))))))))))
