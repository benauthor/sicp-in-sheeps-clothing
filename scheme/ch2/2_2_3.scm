;; Section 2.2.3 Sequences as Conventional Interfaces
;; this is awesome.

;; we need map
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

;; and filter
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
        ((predicate (car sequence))
         (cons (car sequence)
               (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

;; and accumulate
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

;; then a couple ways to enumerate
(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low (enumerate-interval (+ low 1) high))))

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

;; try this out. sum odd squares
(define (square x) (* x x))

(define (sum-odd-squares tree)
  (accumulate +
              0
              (map square
                   (filter odd?
                           (enumerate-tree tree)))))

(define (fib n)
  (define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))
  (fib-iter 1 0 n))



(define (even-fibs n)
  (accumulate cons
              nil
              (filter even?
                      (map fib
                           (enumerate-interval 0 n)))))

;; exercise 2.33
(define (map p sequence)
  (accumulate
   (lambda (x y)
     (cons (p x) y)) ;; op
   nil ;; initial
   sequence)) ;; sequence

(define (append seq1 seq2)
  (accumulate 
   cons    ;; op
   seq2    ;; initial
   seq1))  ;; sequence

(define (sum x y) (+ x y))
(define (count x y) (+ 1 y))

(define (length sequence)
  (accumulate count 0 sequence))

;; exercise 2.34
(define (horner x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) <??>)
              0
              coefficient-sequence))