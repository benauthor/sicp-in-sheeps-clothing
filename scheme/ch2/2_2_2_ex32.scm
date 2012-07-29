#lang racket
;; Exercise 2.32
;; this one's all bill the lizard, I just watched it go by in the debugger.
(define (subsets s)
  (if (null? s)
      (list `())
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda (x) (cons (car s) x)) 
                          rest)))))

;; it cdrs down until it gets the null set, then walks back up, using map to combine all the permutations
;; and appending results to 'rest'.