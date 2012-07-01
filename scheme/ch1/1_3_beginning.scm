;; following along with beginning of 1.3

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b)
     dx))

(define (cube x) (* x x x))

(define (inc x) (+ x 1))

(define (pi-sum a b)
  (define (pi-term x)
    (/ 1 (* x (+ x 2))))
  (define (pi-next x)
    (+ x 4))
  (sum pi-term a pi-next b))

(define (simp f a b n)
  (define h 
    (/ (- b a) n))
  (define (y k)
    (f (+ a (* k h))))
  (define (simp-term k)
    (* (cond ((or (= k 0) (= k n)) 1)
             ((odd? k) 4)
             ((even? k) 2))
       (y k)))
  (/ (* h (sum simp-term 0 inc n)) 3))

(define (limp f a b n)
  (let 
      ((h (/ (- b a) n)))
    (/ (* h 
          (sum (lambda (k)
                 (* (cond ((or (= k 0) (= k n)) 1)
                          ((odd? k) 4)
                          ((even? k) 2))
                    (f (+ a (* k h)))))
               0
               inc
               n))
       3)))

;; Exercise 1.31
;; make a 'product' procedure similar to sum
(define (identity x) x)
(define (increment x) (+ x 1))

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

(define (product-iter term a next b)
  (define (iter a acc)
    (if (> a b)
        acc
        (iter (next a) (* (term a) acc))))
  (iter a 1))

;; gah
(define (pi-thing x)
  (product foo-term (/ 2 3) inc x))


;; 1.32 generalize it further
(define (accumulate combiner null-value term a next b)
  (define (iter a acc)
    (if (> a b)
        acc
        (iter (next a) (combiner (term a) acc))))
  (iter a null-value))


;; 1.33 and further
(define (filtered-accumulate filter combiner null-value term a next b)
  (define (iter a acc)
    (if (> a b)
        acc
        (iter (next a) (if (filter a)
                           (combiner (term a) acc)
                           acc))))
  (iter a null-value))

;; Fixed point procedure
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

;; 1.35 calculate golden ratio with fixed point tranformation x -> 1 + 1/x
;;(fixed-point
;; (lambda (x) (+ 1 (/ 1 x)))
;; 1.0)

;; 1.36 make a fixed point that prints each step and use it to look at how average-damp
;; improves a log calculation
(define (fixed-point-p f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (display guess)
    (newline)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

(define (average a b)
  (/ (+ a b) 2))

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define onethreesix (lambda (x) (/ (log 1000) (log x))))

;; Exercise 1.37 continued fraction thing to get 1/golden ratio
(define (n i) 1.0) ; ??
(define (d i) 1.0) ; ??

(define (cont-frac n d k)
  (define (iter n d k i)
    (if (> i k)
        (/ (n i) (d i))
        (/ (n i)
           (+ (d i)
              (iter n d k (+ i 1))))))
  (iter n d k 1))

;; Exercise 1.38
;(define (d-euler i)
 ;     (if (divisible? i 3)
  ;        (* 2 (/ i 3))
   ;       1))
(define (d-euler i)
  (if (divisible? (+ i 1) 3)
      (* 2 (/ (+ i 1) 3))
      1))

(define (divisible? a b)
  (= 0 (remainder a b)))

;; exercise 1.41
(define (double proc)
  (lambda (x)
    (proc (proc x))))




;; stuff used during 6/20 study group

; 1.40
(define dx 0.000001)

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))
(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define (square x) (* x x))

(define (cubic a b c)
  (lambda (x)
    (+ (* x x x)
       (* a (square x))
       (* b x)
       c)))

; test out 1.41
(define (double proc)
  (lambda (x)
    (proc (proc x))))

;> (((double (double double)) inc) 5)
;21
;> 

; exercise 1.42
(define (compose f g)
  (lambda (x)
    (f (g x))))
