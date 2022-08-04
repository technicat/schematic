
(define rx-current-directory
    (lambda (re type)
        (rx-dir (current-directory) re type)))

(define rx-dir
    (lambda (path re type) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (rx-file file re)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir type)
                    seed)))))

(define rx-file
    (lambda (file re)
        (print file)
        (call-with-input-file file
            (lambda (p)
                (rx-input p re)))))


(define rx-input
    (lambda (p re)
        (let f ((total 0) (linenum 1))
            (guard (e (else total)) ; bail out of binary
                (let ((line (read-line p)))
                (if (eof-object? line)
                    total
                    (let ((match (rxmatch->string re line)))
                        (if match
                            (begin 
                                (print #"line ~linenum : ~match")
                                (f (+ 1 total) (+ 1 linenum)))
                            (f total (+ 1 linenum))))))))))
