(define (half x) (/ x 2))

(define (twice x) (+ x x))

(define (fmult a b)
  (cond ((= b 0) 0)
        ((even? b) (fmult (twice a) (half b)))
        (else (+ a (fmult a (- b 1))))))