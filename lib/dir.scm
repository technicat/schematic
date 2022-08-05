(use file.util)

(define dir-help
    (lambda ()
        (print "-h : show this doc")
        (print "-d : process dot (hidden) files")
        (print "-t : file extension to filter for, e.g. scm, json, swift, dart, java")
))

; todo - make type a list
(define ignore-file?
    (lambda (file :key (type #f) (dot-files #f))
      (let-values (((dir name ext) (decompose-path file)))
        (or (and (not dot-files) (eq? (string-ref name 0) #\.))
            (and type
                (file-is-regular? file) 
                (not (equal? ext type)))))))

(define filter-dir
    (lambda (dir :rest args)
        (remove
            (lambda (file)
                (apply ignore-file? file args))
            (directory-list dir :add-path? #t :children? #t))))


