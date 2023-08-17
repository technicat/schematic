; functions to write hugo files (specifically, the header)

(define (hugo-header-line out)
 (write-string "---" out))