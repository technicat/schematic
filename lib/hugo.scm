; functions to write hugo files (specifically, the header)

(define (hugo-header-line out)
 (write-string "---" out))

(define (hugo-title title out)
 (write-string #"title: \"~title\"" out)
 (newline out))

(define (hugo-date-none out)
 (write-string #"showDate: false" out)
 (newline out))

(define (hugo-tags tags out)
 (write-string #"tags: [~tags]" out)
 (newline out))

(define (hugo-cats cats out)
 (write-string #"categories: [~cats]" out)
 (newline out))
