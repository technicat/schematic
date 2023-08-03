(define (news out)
 (newline out)
 (newline out))

(define (h1 title out)
 (newline out)
 (write-string #"# ~title" out)
 (newline out))

(define (h2 title out)
 (newline out)
 (write-string #"## ~title" out)
 (newline out))

(define (h3 title out)
 (newline out)
 (write-string #"### ~title" out)
 (newline out))

(define (blockquote item out)
 (newline out)
 (write-string #"> ~item" out)
 (newline out))

(define (bullet item out)
 (newline out)
 (write-string #"- ~item" out)
 (newline out))