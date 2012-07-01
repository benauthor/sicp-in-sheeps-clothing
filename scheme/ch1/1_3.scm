;; Exercises for 1.3

;; Exercise 1.29
;; Integrals by Simpson's rule
;; I way cheated off Bill the lizard, but then moved some stuff around to use
;; let and a lambda for the procedure in sum.

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

;; Exercise 1.30
;; rewrite iteratively:
(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

;; becomes
(define (sum term a next b)
  (define (iter a result)
    (if <??>
        <??>
        (iter <??> <??>)))
  (iter <??> <??>))

;; becomes
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ (term a) result))))
  (iter a 0))

;; Exercise 1.31
(define (identity x) x)
(define (increment x) (+ x 1))

(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))

;; and the iterative way

(define (product-iter term a next b)
  (define (iter a acc)
    (if (> a b)
        acc
        (iter (next a) (* (term a) acc))))
  (iter a 1))

;; try it out
(product-iter identity 1 inc 40)

;; 1.32 generalize further
(define (accumulate combiner null_value term a next b)
  (define (iter a acc)
    (if (> a b)
        acc
        (iter (next a) (combiner (term a) acc))))
  (iter a null-value))

;; 1.33 ...and further
(define (filtered-accumulate filter combiner null-value term a next b)
  (define (iter a acc)
    (if (> a b)
        acc
        (iter (next a) (if (filter a)
                           (combiner (term a) acc)
                           acc))))
  (iter a null-value))

;; for example, add even numbers between 1 and 10)
(filtered-accumulate
   (lambda (a) (even? a))
   +
   0
   identity
   1
   increment
   10)


;; Exercise 1.34
;; f is a function that takes a function g that takes one value, then applies
;; g to 2.

;; if you do (f f) it takes f and applies it to two, which throws an error
;; because f expects a parameter that is a procedure, not a value.

;; Exercise 1.35
;; 1.35 calculate golden ratio with fixed point tranformation x -> 1 + 1/x
(fixed-point
 (lambda (x) (+ 1 (/ 1 x)))
 1.0)
;; Exercise 1.36
> (fixed-point-p
   (lambda (x) (/ (log 1000) (log x)))
   1.5)
1.5
17.036620761802716
2.436284152826871
7.7573914048784065
3.3718636013068974
5.683217478018266
3.97564638093712
5.004940305230897
4.2893976408423535
4.743860707684508
4.437003894526853
4.6361416205906485
4.503444951269147
4.590350549476868
4.532777517802648
4.570631779772813
4.545618222336422
4.562092653795064
4.551218723744055
4.558385805707352
4.553657479516671
4.55677495241968
4.554718702465183
4.556074615314888
4.555180352768613
4.555770074687025
4.555381152108018
4.555637634081652
4.555468486740348
4.555580035270157
4.555506470667713
4.555554984963888
4.5555229906097905
4.555544090254035
4.555530175417048
4.555539351985717
> 
;; with average damping... way faster!
> (fixed-point-p
   (average-damp (lambda (x) (/ (log 1000) (log x))))
   1.5)
1.5
9.268310380901358
6.185343522487719
4.988133688461795
4.643254620420954
4.571101497091747
4.5582061760763715
4.555990975858476
4.555613236666653
4.555548906156018
4.555537952796512
4.555536087870658
> 

;; Exercise 1.37 continued fraction thing to get 1/golden ratio
(define (n i) 1.0) ; ??
(define (d i) 1.0) ; ??

(define (cont-frac n d k)
  (define (iter n d k i)
    (if (> i k)
        (/ (n i) (d i)) ; is this the right way to terminate?
        (/ (n i)
           (+ (d i)
              (iter n d k (+ i 1))))))
  (iter n d k 0))

;; 1.38 d for euler expansion

(define (d i)
  (if (divisible? i 3)
      (* 2 (/ i 3))
      1))

;; ER, this comes to e - 1 rather than e - 2. WTF.
;; RESOLVED like so:

(define (n i) 1.0)

(define (d i)
  (if (divisible? (+ i 1) 3) ; this changed
      (* 2 (/ (+ i 1) 3))
      1))

(define (cont-frac n d k)
  (define (iter n d k i)
    (if (> i k)
        (/ (n i) (d i))
        (/ (n i)
           (+ (d i)
              (iter n d k (+ i 1))))))
  (iter n d k 1)) ; and this

;; exercise 1.41
(define (double proc)
  (lambda (x)
    (proc (proc x))))

;> (((double (double double)) inc) 5)
;21
;> 

 (((double (double (lambda (x) (proc (proc x)))) inc) 5)
