
(define rx-current-directory
    (lambda (re type pm)
        (rx-dir (current-directory) re type pm)))

(define rx-dir
    (lambda (path re type pm) 
        (directory-fold path
            (lambda (file result)
                (+ result 
                    (rx-file file re pm)))
            0
            :lister
            (lambda (dir seed)
                (values (filter-dir dir type)
                    seed)))))

(define rx-file
    (lambda (file re pm)
        (print file)
        (call-with-input-file file
            (lambda (p)
                (rx-input p re pm)))))


(define rx-input
    (lambda (p re pm)
        (let f ((total 0) (linenum 1))
            (guard (e (else total)) ; bail out of binary
                (let ((line (read-line p)))
                (if (eof-object? line)
                    total
                    (let ((match (rxmatch->string re line)))
                        (if match
                            (begin 
                                (if pm
                                    (print #"line ~linenum : ~match")
                                    (print #"line ~linenum : ~line"))
                                (f (+ 1 total) (+ 1 linenum)))
                            (f total (+ 1 linenum))))))))))
