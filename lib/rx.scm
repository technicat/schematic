
(define rx-dir
    (lambda (path re :key (type #f) (dot-files #f) (verbose #f))
        (dir-info path :type type :dot-files dot-files :verbose verbose)
        (directory-fold path
            (lambda (file result)
                (append
                    (rx-file file re :verbose verbose)
                    result))
            '()
            :lister
            (lambda (dir seed)
                (values (filter-dir dir 
                    :type type :dot-files dot-files :verbose verbose)
                    seed)))))

(define rx-file
    (lambda (file re :key (verbose #f))
        (if verbose (print #"Searching ~file"))
        (guard (e (else
                    (print #"Error processing ~file")
                    (print (condition-message e))
                    '()))
            (call-with-input-file file
             (lambda (p)
                (rx-input p re :verbose verbose))))))


(define rx-input
    (lambda (p re :key (verbose #f))
        (let f ((matches '()) (linenum 1))
            (let ((line (read-line p)))
                (if (eof-object? line)
                    matches
                    (let ((match (rxmatch->string re line)))
                        (if match
                            (begin 
                                (if verbose
                                    (print #"line ~linenum : ~line")
                                   ; (print #"line ~linenum : ~match")
                                    )
                                (f (cons match matches) (+ 1 linenum)))
                            (f matches (+ 1 linenum)))))))))
