(define (half x) (/ x 2))

(define (twice x) (+ x x))

(define (mult a b) (mit a b 0))

(define (mit a b acc)
  (if (= b 0)
      acc
      (mit a (- b 1) (+ acc a))))

(define (fmult a b) 
  (if (> a b)
      (fmit a b 0)
      (fmit b a 0)))

(define (fmit a b acc)
  (cond ((= b 0) acc)
        ((even? b) (fmit (twice a) (half b) acc))
        (else (fmit a (- b 1) (+ acc a)))))