;;2.2.5
;;Exercise 2.53
;;(a b c)
;;((george))
;;(y1 y2) oops ((y1 y2))
;;y1 oops (y1 y2)
;;#f
;;#f
;;#t
;;Exercise 2.54
;; equal should recursively compare lists 
(define (equal? a b)
  (if (and (and (list? a) (list? b))
           (and (not (null? a)) (not (null? b))))
      (and (equal? (car a) (car b))
           (equal? (cdr a) (cdr b)))
      (eq? a b)))
;;skipping that symbolic differentiation junk. too hard. on to sets
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((equal? x (car set)) true)
        (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
        ((element-of-set? (car set1) set2)        
         (cons (car set1)
               (intersection-set (cdr set1) set2)))
        (else (intersection-set (cdr set1) set2))))
;;2.59 implement union-set
;;a lot like the 
(define (union-set set1 set2)
  (if (null? set1)
      set2
      (union-set (cdr set1)
                 (adjoin-set (car set1) set2))))
;; you can optimize this a bit. check for nulls, swap the longer for shorter 
(define (union-set set1 set2)
  (cond [(> (length set1) (length set2)) (union-set set2 set1)] 
        [(null? set1) set2]
        [else (union-set (cdr set1)
                 (adjoin-set (car set1) set2))]))
;;2.60 implement same allowing duplicates in sets

;; element-of-set? doesn't change
;; adjoin gets simpler, it doesn't need to check
(define (adjoin-set x set) (cons x set))
;;intersection-set doesn't change either?
(define (union-set set1 set2) (append set1 set2))

;;trades speed for increased storage 

;;2.61 ordered representation of sets
(define (element-of-set? x set)
  (cond ((null? set) false)
        ((= x (car set)) true)
        ((< x (car set)) false)
        (else (element-of-set? x (cdr set)))))

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (intersection-set (cdr set1) set2))
              ((< x2 x1)
               (intersection-set set1 (cdr set2)))))))

(define (adjoin-set x set)
  (cond ((null? set) (cons x `()));if set is null, return a set containing just x
        ((= x (car set)) set);set already contains it, return set
        ((< x (car set)) (cons x set));if x is smaller than smallest in set, add it
        (else (cons (car set) (adjoin-set x (cdr set))))))

;; 2.62 do an O(n) version of union-set for ordered sets
(define (union-set set1 set2)
  (cond [(> (length set1) (length set2)) (union-set set2 set1)] 
        [(null? set1) set2]
        [(< (car set1) (car set2)) (union-set (cdr set1) (cons (car set1) set2))]
        [(= (car set1) (car set2)) (union-set (cdr set1) set2)]
        [(> (car set1) (car set2)) (cons (car set2) (union-set set1 (cdr set2)))]))
