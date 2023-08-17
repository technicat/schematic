; functions to write hugo files (specifically, the header)

(define (hugo-header-line out)
 (write-string "---" out))

(define (hugo-title title out)
 (write-string #"title: \"~title\"" out)
 (newline out))