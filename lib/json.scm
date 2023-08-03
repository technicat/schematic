; json utils

(use file.util)
(use rfc.json)

(define (read-json file)
 (guard (e (else (print #"JSON error in ~file")
            (print (condition-message e))
            #\f))
  ; assume one json obj, otherwise use parse-json*
  (let ((exp (call-with-input-file file parse-json)))
   exp)))

(define (write-json r file)
 (call-with-output-file file
  (lambda (out) (construct-json r out))))

(define (res-value key r)
 (let ((b (find (lambda (item)
                 (string=? (car item) key))
           r)))
  (and b (cdr b))))
