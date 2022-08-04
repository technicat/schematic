(use file.util)

; todo - make type a list
(define ignore-file?
    (lambda (file :key (type #f) (ignore-hidden #t))
      (let-values (((dir name ext) (decompose-path file)))
        (or (and ignore-hidden (eq? (string-ref name 0) #\.))
            (and type
                (file-is-regular? file) 
                (not (equal? ext type)))))))

(define filter-dir
    (lambda (dir :key (type #f) (ignore-hidden #t))
        (remove
            (lambda (file)
                (ignore-file? file :type type :ignore-hidden ignore-hidden))
            (directory-list dir :add-path? #t :children? #t))))


