#! /usr/bin/env racket
#lang racket/base

(define (average x y)
  (/ (+ x y) 2))
(define (square x) (* x x))

(define (sqrta x)
    (define (good-enough? guess last-guess)
            (< (abs (/ (- guess last-guess) guess)) 0.001))
    (define (improve guess)
            (average guess (/ x guess)))
    (define (sqrt-iter guess last-guess)
            (if (good-enough? guess last-guess)
                guess
                (sqrt-iter (improve guess) guess)))
    (sqrt-iter 1.0 0))

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

(define p 4)
(sqrt p)
(sqrta p)

(define (test p)
  (- (sqrt p) (sqrta p)))

(test 4)
(test 0.0001)
