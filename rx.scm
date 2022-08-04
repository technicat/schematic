
(define rx-current-directory
    (lambda (re :key (type #f) (print-line #f))
        (rx-dir (current-directory) re :type type :print-line print-line)))

(define rx-dir
    (lambda (path re :key (type #f) (print-line #f)) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (rx-file file re :print-line print-line)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir type)
                    seed)))))

(define rx-file
    (lambda (file re :key (print-line #f))
        (print file)
        (call-with-input-file file
            (lambda (p)
                (rx-input p re :print-line print-line)))))


(define rx-input
    (lambda (p re :key (print-line #f))
        (let f ((total 0) (linenum 1))
            (guard (e (else total)) ; bail out of binary
                (let ((line (read-line p)))
                (if (eof-object? line)
                    total
                    (let ((match (rxmatch->string re line)))
                        (if match
                            (begin 
                                (if print-line
                                    (print #"line ~linenum : ~line")
                                    (print #"line ~linenum : ~match")
                                    )
                                (f (+ 1 total) (+ 1 linenum)))
                            (f total (+ 1 linenum))))))))))
