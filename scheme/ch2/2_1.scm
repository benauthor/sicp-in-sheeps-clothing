(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))
(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))
(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))
(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))

(define (numer x) (car x))

(define (denom x) (cdr x))

;; Exercise 2.1
;; make a make-rat procedure that normalizes sign

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cond ((and (> n 0) (> d 0))
           (cons (/ n g)
                 (/ d g)))
          ((and (< n 0) (< d 0))
           (cons (/ (- n) g)
                 (/ (- d) g)))
          (else (cons (/ (- (abs n)) g)
                      (/ (abs d) g))))))

;; we always want a positive d.
;; why not put the conditional in the n part?
(define (make-rat-b n d)
  (let ((g (gcd n d)))
    (cons (if (or (and (> n 0) (> d 0))
                  (and (< n 0) (< d 0)))
              (/ (abs n) g)
              (/ (- (abs n)) g))
          (/ (abs d) g))))

;; reads better if you pull out the sign comparison
(define (make-rat-c n d)
  (define (have-same-sign? a b)
    (or (and (> a 0) (> b 0))
        (and (< a 0) (< b 0))))
  
  (let ((g (gcd n d)))
    (cons (if (have-same-sign? n d)
              (/ (abs n) g)
              (/ (- (abs n)) g))
          (/ (abs d) g))))
 
;; enough of that

;; Exercise 2.2
;; Make a system for representing points and line segments

;; points are just simple pairs
(define (make-point x y) (cons x y))
(define (get-x-of point) (car point))
(define (get-y-of point) (cdr point))
(define (display-point p)
  (display "(")
  (display (get-x-of p))
  (display ",")
  (display (get-y-of p))
  (display ")"))
(define (print-point p)
  (newline)
  (display-point p))

;; line segments are pairs of pairs
(define (make-segment start end) (cons start end))
(define (segment-start segment) (car segment))
(define (segment-end segment) (cdr segment))
(define (print-segment s)
  (newline)
  (display-point (segment-start s))
  (display " -> ")
  (display-point (segment-end s)))

(define (midpoint-segment seg)
  (make-point
   (avg (get-x-of (segment-start seg))
        (get-x-of (segment-end seg)))
   (avg (get-y-of (segment-start seg))
        (get-y-of (segment-end seg)))))

(define (avg a b) (/ (+ a b) 2))

;; Exercise 2.3
(define (make-rect point width height)
  (let ((dimensions (cons width height)))
    (cons point dimensions)))

(define (get-point rect) (car rect))
(define (get-dimensions rect) (cdr rect))
(define (get-width rect) (car (get-dimensions rect)))
(define (get-height rect) (cdr (get-dimensions rect)))

(define (perimeter rect)
  (+ (* (get-width rect) 2) (* (get-height rect) 2)))

(define (area rect)
  (* (get-width rect) (get-height rect)))

(define p (make-point 2 4))
(define r (make-rect p 6 4))

;; you could also represent rectangles as two points defining the corners
;(define (make-rect-b p1 p2) (cons p1 p2))
;(define (get-width-b rect) (abs (- (get-x-of p1) (get-x-of p2))))
;(define (get-height-b rect) (abs (- (get-y-of p2) (get-y-of p2))))

;; or maybe you have rectangles that can be at arbitrary angles
;(define (make-rect-c point width height rotation)
;  (define dimensions (cons width height))
;  (define parameters (cons dimensions rotation))
;    (cons point parameters))

; i am reaching for per-type-of-object 'methods' so that i can literally use
; the same perimeter and area procedures. i.e. my get-width doesn't work on
; type-b rectangles, and since perimeter calls get-width, i can't actually use
; the exact same procedure on both at the same time without changing my code
; how to do this? same question as how can you use the same procedure to add
; integers and rational numbers and say, strings?

;; Exercise 2.4
;; data as procedures. say we implement pairs like this:

(define (cons x y)
  (lambda (m) (m x y)))

(define (car z)
  (z (lambda (p q) p)))

;;verify that (car (cons x y)) yields x for any objects x and y

;(car (cons x y))

;; cons returns a function that takes a function as a parameter and applies it to
;; its stored x and y

;(car (lambda (m) (m x y)))

;; car takes function z, which will be the cons return function, and applies it to
;; a lambda that returns the first of two paramters. 

;((lambda (m) (m x y)) (lambda (p q) p))

;; in combination, this works as we expect from a pair. the pair function is applied
;; to the car function, taking it(car) as its (the pair's) paramter, giving you

;((lambda (p q) p) (x y))

;; finally returning

;x

;; cdr would be just like car, only returning q rather than p
(define (cdr z)
  (z (lambda (p q) q)))

;; Exercise 2.5
;; Show that we can represent pairs of nonnegative integers using only
;; numbers and arithmetic operations if we represent the pair a and b as 
;; the integer that is the product 2a 3b. Give the corresponding definitions
;; of the procedures cons, car, and cdr
(define (cons x y)
  (* (expt 2 x) (expt 3 y)))

(define (car p)
  (count-number-of-times-divides-by 2 p))

(define (cdr p)
  (count-number-of-times-divides-by 3 p))

(define (count-number-of-times-divides-by factor number)
  (define (iter number acc)
    (if (= 0 (modulo number factor))
        (iter (/ number factor) (+ 1 acc))
        acc))
  (iter number 0))

;; Exercise 2.6
;; Church numerals... fuck off.

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

;; continued in new file 2_7.scm