; utils for command-line tools

(use file.util)
(use gauche.parseopt) ; command line args

; todo - make type a list of types, and make ignore hidden files an option
(define ignore-file?
    (lambda (file type)
      (let-values (((dir name ext) (decompose-path file)))
        (or (eq? (string-ref name 0) #\.) ; ignore dot files/directories
            (and type ; check extension
                (file-is-regular? file) 
                (not (equal? ext type)))))))

(define filter-dir
    (lambda (dir type)
        (remove
            (lambda (file)
                (ignore-file? file type))
            (directory-list dir :add-path? #t :children? #t))))

