;;exercise 3.1 make-accumulator
;;(define A (make-accumulator 5))
(define (make-accumulator initial)
  (let ((sum initial))
    (lambda (increment)
      (set! sum (+ sum increment))
      balance)))