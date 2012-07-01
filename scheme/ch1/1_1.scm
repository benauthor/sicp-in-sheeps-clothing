;; SICP exercises
;; Exercise 1.2
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
   (* 3 (- 6 2) (- 7 2)))

;; Exercise 1.3
;; lot of ways to go with this one. discuss.
(define (square x) (* x x))

(define (sum-of-squares x y)
  (+ (square x) (square y)))

(define sumsq-two-largest a b c
    (if (>= a b)
        (if (>= b c)
            (sum-of-squares a b)
            (sum-of-squares a c))
        (if (>= a c)
            (sum-of-squares a b) ; this seems duplicative
            (sum-of-squares b c))))

;; Exercise 1.4
;; define a function called a-plus-abs-b
;; it takes two arguments.
(define (a-plus-abs-b a b)
;;  if b is greater than zero
  ((if (> b 0)
;;     add...
       +
;; else if b is less than zero subtract...
       -)
;; these numbers a and b
        a b))

;; in other words
(define (apabsb a b)
  (if (> b 0)
      (+ a b)
      (- a b)))

;; Exercise 1.5
;; applicative vs. normal order evaluation
;;
;; In applicative order, p will be evaluated.
;; Since p is infinitely recursive, Scheme will hang.
;;
;; In normative order, p won't be evaluated until needed.
;; Since the if is true, 0 is returned, p is never eval'd.
;;
;; Exercise 1.6
;;
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

(sqrt-iter 150 144)

(new-if (good-enough? 150 144)
        150
        (sqrt-iter (improve 150 144)
                   144))

(cond ((good-enough? 150 144) 150)
      (else (sqrt-iter (improve 150 144) 144)))
;; http://www.billthelizard.com/2009/10/sicp-exercises-16-18.html
;; here someone claims that the problemn is that unlike `if`, `cond`
;; evaluates all its predicates no matter what, so the recursive
;; call will cause this to hang.
;; 
;; however, examining docs
;; http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/Conditionals.html#Conditionals
;; seems to indicate that cond acts like if, lazily evaluating.
;; experiment seems to confirm, because this doesn't hang:
(define (p) (p))

(cond ((eq? 0 0) 0)
      (else (p)))
;;i see now. it's not cond that's evaluated applicatively, but
;;new-if itself. since it's a regular function sqr-iter is evaluated
;;and, being recursive, causes probs.
;;
;; Exercise 1.7
;;
;; good-enough uses a constant margin of error 0.0001. For very small
;; numbers, .0001 may be a very large margin of error, making the
;; function useless.
(good-enough? .02 .0001)
;;=>true
;; but how useful is that?
;;
;; not sure but on the big end floating point rounding errors might cause
;; problems?
;;
;; Design a new version that uses the delta in guess rather than a static
;; reference for comparison.
;; Old version:
(define (sqrt x)
    (define (good-enough? guess)
            (< (abs (- (square guess) x)) 0.001))
    (define (improve guess)
            (average guess (/ x guess)))
    (define (sqrt-iter guess)
            (if (good-enough? guess)
                guess
                (sqrt-iter (improve guess))))
    (sqrt-iter 1.0))
;; New version c
(define (sqrt x)
    (define (good-enough? guess last-guess)
            (< (abs (- guess last-guess)) 0.001))
    (define (improve guess)
            (average guess (/ x guess)))
    (define (sqrt-iter guess last-guess)
            (if (good-enough? guess last-guess)
                guess
                (sqrt-iter (improve guess) last-guess)))
    (sqrt-iter 1.0 0))
