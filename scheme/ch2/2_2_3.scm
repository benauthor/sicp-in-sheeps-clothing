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
  (accumulate (lambda (this-coeff higher-terms) (+ (* x higher-terms) this-coeff))
              0
              coefficient-sequence))

;; exercise 2.35
;Redefine count-leaves from section 2.2.2 as an accumulation:

(define (count-leaves t)
  (accumulate + ; op
              0 ; initial
              (map ; sequence -- map returns a transformed list
               (lambda (subtree) ;proc
                   (if (pair? subtree)
                       (count-leaves subtree)
                       1))
               t))) ;items

;; exercise 2.36
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (map car seqs))
            (accumulate-n op init (map cdr seqs)))))

;; exercise 2.37... matrix algebra... i'll leave that for later.

;; exercise 2.38
;; fold right, fold left.

;; fold right is accumulate.
(define fold-right accumulate)
;; fold left as given
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

;> (fold-right / 1 (list 1 2 3))
;1 1/2
;> (fold-left / 1 (list 1 2 3))
;1/6
;> (fold-right list nil (list 1 2 3))
;{mcons 1 {mcons {mcons 2 {mcons {mcons 3 {mcons '() '()}} '()}} '()}}
;> (fold-left list nil (list 1 2 3))
;{mcons {mcons {mcons '() {mcons 1 '()}} {mcons 2 '()}} {mcons 3 '()}}

;commutative operations should produce identical results win fold-right and fold-left

;; exercise 2.39 reverse in terms of accumulate (fold-right) and fold-left
(define (reverse-r sequence)
  (fold-right (lambda (x y) (append y (list x))) nil sequence))

(define (reverse-l sequence)
  (fold-left (lambda (x y) (cons y x)) nil sequence))