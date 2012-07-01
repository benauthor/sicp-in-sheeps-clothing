#! /usr/bin/env racket
#lang racket/base

(define (cube x) (* x x x))

(define (curt x)
    (define (good-enough? guess last-guess)
            (< (abs (/ (- guess last-guess) guess)) 0.001))
    (define (newton-cube-step x y)
            (/ (+ (/ x (* y y)) (* 2 y)) 3))
    (define (curt-iter guess last-guess)
            (if (good-enough? guess last-guess)
                guess
                (curt-iter (newton-cube-step x guess) guess)))
    (curt-iter 1.0 0))


(define p 27)
(curt p)
