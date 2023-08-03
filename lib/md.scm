; functions for markdown output

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

; images

(define (embed label image out)
 (newline out)
 (embed-inline label image out)
 (news out))

(define (embed-inline label image out)
 (newline out)
 (write-string #"![~label](~image)" out))

(define (embed-images label images out)
 (if images
  (for-each
   (lambda (images)
    (embed-inline "project image" images out))
   images))
 (news out))