;; Exercise 2.17
(define (last-pair l)
  (if (null? (cdr l))
      l
      (last-pair (cdr l))))

;; Exercis 2.18
(define (append list1 list2)
   (if (null? list1)
       list2
       (cons (car list1) (append (cdr list1) list2))))

(define (reverse alist)
  (if (null? (cdr alist)); if cdr is nil, that's the last one
      alist ; just return it
      (append ; else append
       (reverse (cdr alist)) ; recursively reverse the cdr until we run out 
       (list (car alist))))) ; to the car of the whole list

;; Exercise 2.20
;; make a same-parity function that takes an arbitrary number of arguments
(define (same-parity first . args)
  
  (define (matches-parity? z)
    (or (and (even? first) (even? z))
        (and (odd? first) (odd? z))))
  
  (define (iter args acc)
    (if (null? args)
        acc
        (iter (cdr args)
              (if (matches-parity? (car args))
                  (append acc (list (car args)))
                  acc))))
  
  (iter args (list first)))
               
;; Exercise 2.21
(define (square x) (* x x))

; the naive way
(define (square-list-a items)  
  (if (null? items)
      nil
      (cons (square (car items)) (square-list-a (cdr items)))))

; map is much nicer
(define (square-list-b items)
  (map (lambda (x) (* x x))
       items))

;; Exercies 2.23
;; implement for-each
(define (my-each func items)
      (cond ((null? (cdr items)) nil) ; use cond because 'if' doesn't let you group a sequence of statements
            (else (func (car items))
                  (my-each func (cdr items)))))

;; Exercise 2.27
;; deep reverse
(define d (list (list 1 2) (list 3 4)))

(define (deep-reverse z)
  (if (null? (cdr z)) ; end of list
      (if (pair? (car z)) ; is it a nested list?
          (deep-reverse (car z)) ; then reverse that too
          z) ; or not
      (append (deep-reverse (cdr z)) ;recurse
              (deep-reverse (list (car z)))))) ; don't forget to reverse the car too.


;; Exercise 2.28
;; 'fringe' i.e. flatten a tree
(define (flatten t)
  (if (null? (cdr t))
      (if (pair? (car t))
          (flatten (car t))
          t)
      (append (flatten (list (car t)))
              (flatten (cdr t)))))

;; Exercise 2.30
;; map over a tree
(define (square-tree tree)
  (map (lambda (subtree)
         (if (pair? subtree)
             (square-tree subtree)
             (square subtree)))
       tree))

;; Exercise 2.31
(define (tree-map proc tree)
  (map (lambda (subtree)
         (if (pair? subtree)
             (tree-map proc subtree)
             (proc subtree)))
       tree))

(define (sq-tree-2 tree) (tree-map square tree))