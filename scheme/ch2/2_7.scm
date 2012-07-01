;; Exercise 2.7
;; interval arithmetic

(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (div-interval x y)
  (mul-interval x 
                (make-interval (/ 1.0 (upper-bound y))
                               (/ 1.0 (lower-bound y)))))

;; Exercise 2.7.
(define (make-interval a b) (cons a b))

;Define selectors upper-bound and lower-bound to complete the implementation.
(define (lower-bound i) (car i))
(define (upper-bound i) (cdr i))

;Exercise 2.8.  Using reasoning analogous to Alyssa's, describe how the difference
;of two intervals may be computed.

(define (subtract-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y))))

;; Exercise 2.9
;; Define width of interval
(define (width-interval i) (- (upper-bound i) (lower-bound i)))

;; Exercise 2.10
;; let's make a little unit test procedure
(define (display-message-with-args message . args)
  (display message)
  (for-each (lambda (arg)
              (display " ")
              (write arg))
            args)
  (newline))

(define (assert op . args)
  (if (apply op args)
      (display-message-with-args "Assertion Passed" op args)
      (display-message-with-args "Assertion Failed" op args)))

(define (raise error . args)
  (display-message-with-args error args)
  (scheme-report-environment -1))
  
(define (!= . args)
  (not (apply = args)))

;; now the tests
(let ((a (make-interval 3 7))
      (b (make-interval 2 3)))
  (assert =
          (+ (width-interval a) (width-interval b))
          (width-interval (add-interval a b)))
  (assert =
          (+ (width-interval a) (width-interval b))
          (width-interval (subtract-interval a b)))
  (assert !=
          (+ (width-interval a) (width-interval b))
          (width-interval (mul-interval a b)))
    (assert !=
          (+ (width-interval a) (width-interval b))
          (width-interval (div-interval a b)))
  )

;; 2.10 Careful with those zero-spanning intervals in division
;; I think they mean:
;; ambigous whether new low bound is the one closer to zero or the other one.
(define (same-sign? x y)
  (or (and (> x 0) (> y 0))
      (and (< x 0) (< y 0))))

(define (div-interval x y)
  (if (not (and (same-sign? (lower-bound x) (upper-bound x))
                (same-sign? (lower-bound y) (upper-bound y))))
      (raise "IntervalSpansZeroError" x y)
      (mul-interval x 
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))
;; let's try that out
(let ((a (make-interval -1 7))
      (b (make-interval 2 3)))
  (div-interval a b))