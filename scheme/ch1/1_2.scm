;; Exercise 1.9
;first is linear recursive, it defers a bunch of operations by putting them
; on the stack
(+ 4 5)
;expands to
(if (= 4 0)
  5
  (inc (+ (3) 5)))
; hasn't finished the first addition yet when it needs to evaluate the next one
; so the first stays on the stack. same happens with (+ 3 5), deferred, and so on
(+ 4 5)
(inc (+ 3 5))
(inc (inc (+ 2 5)))
(inc (inc (inc (+ 1 5))))
(inc (inc (inc (inc (+ 0 5)))))
(inc (inc (inc (inc 5))))
(inc (inc (inc 6)))
(inc (inc 7))
(inc 8)
9

;second method is iterative, i.e. tail recursive
(+ 4 5)
; expands to
(if (= 4 0)
  5
  (+ 3 6))
; so a and b are just state variables, updated together on each recursion
(+ 4 5)
(+ 3 6)
(+ 2 7)
(+ 1 8)
(+ 0 9)
9
;; Exercise 1.10
;; Ackermann's function
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))
(A 1 5)
(A 0 (A 1 4))
(A 0 (A 0 (A 1 3)))
(A 0 (A 0 (A 0 (A 1 2))))
(A 0 (A 0 (A 0 (A 0 (A 1 1)))))
(A 0 (A 0 (A 0 (A 0 2))))
(A 0 (A 0 (A 0 (* 2 2))))
(A 0 (A 0 (A 0 4)))
(A 0 (A 0 (* 2 4)))
(A 0 (A 0 8))
(A 0 16)
32
;> (A 1 10)
;1024
(A 2 4)
(A 1 (A 2 3))
(A 1 (A 1 (A 2 2)))
(A 1 (A 1 (A 1 (A 2 1))))
(A 1 (A 1 (A 1 2)))
(A 1 (A 1 (A 0 (A 1 1))))
(A 1 (A 1 (A 0 2)))
(A 1 (A 1 (* 2 2)))
(A 1 (A 1 4))
;> (A 2 4)
;65536
;> (A 3 3)
;65536
;>
(define (f n) (A 0 n))
;; f(n) = 2n
(define (g n) (A 1 n))
;; g(n) = 2^n
(define (h n) (A 2 n))
;; h(n) = 2^(2^n) NOPE IT'S CRAZIER THAN THAT
;; tetration. whoa. i had to google to understand this.
;; h(n) = 2^^n
(define (k n) (* 5 n n))
;; k(n) = 5n^2

;; Exercise 1.11
;; recursive way
(define (f n)
  (if (< n 3)
      n
      (+ (f (- n 1))
         (* 2 (f (- n 2)))
         (* 3 (f (- n 3))))))
;; iterative way
;; using their fibonacci function as a template
;; way faster omg!
(define (f n)
  (f-iter 2 1 0 n))

(define (f-iter a b c count)
    (if (< count 3)
        a
        (f-iter
         (+ a
           (* 2 b)
           (* 3 c))
         a
         b
         (- count 1))))

;; Exercise 1.12
;; 1
;; 1 1
;; 1 2 1
;; 1 3 3 1
;; 1 4 6 4 1
(define (pascal line index)
  (if (> line 0)
      (+ (pascal (- line 1) index)
         (pascal (- line 1) (- index 1)))
      (if (= index 0)
          1
          0)))

;; Exercise 1.13
;; No fucking clue.

;; Exercise 1.14
;; It's an exponential expansion. Each recursion calls itself twice.
;; So T(n) = Θ(n^2)

;; Exercise 1.15
;; This one's liner. T(n) = O(n)

;; Exercise 1.17
(define (half x) (/ x 2))

(define (twice x) (+ x x))

(define (fmult a b)
  (cond ((= b 0) 0)
        ((even? b) (fmult (twice a) (half b)))
        (else (+ a (fmult a (- b 1))))))

;; Exercise 1.18
;; plain version, tail recursion
(define (mult a b) (mit a b 0))

(define (mit a b acc)
  (if (= b 0)
      acc
      (mit a (- b 1) (+ acc a))))

;; fast mult version, tail recursion
(define (fmult a b) 
  (if (> a b) ; bjorn's insight: big difference in (* 1234567 3) and (* 3 1234567)
      (fmit a b 0)
      (fmit b a 0)))


(define (fmit a b acc)
  (cond ((= b 0) acc) ; you could do special cases for (= a 0), (= a 1), (= b 1) but not mandatory
        ((even? b) (fmit (twice a) (half b) acc))
        (else (fmit a (- b 1) (+ acc a)))))
