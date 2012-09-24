(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

(define g (make-tree 7
                     (make-tree 3 
                                (make-tree 1 `() `())
                                (make-tree 5 `() `()))
                     (make-tree 9 
                                `() 
                                (make-tree 11 `() `()))))
;(define h (make-tree 3 1 (make-tree 7 5 (make-tree 9 `() 11))))
;(define k (make-tree 5 (make-tree 3 1 `()) (make-tree 9 7 11)))

(define (t->L1 tree)
  (if (null? tree)
      `()
      (append (t->L1 (left-branch tree))
              (cons (entry tree)
                    (t->L1 (right-branch tree))))))

(define (t->L2 tree)
  (define (copy-to-list tree resultlist)
    (if (null? tree)
        resultlist
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          resultlist)))))
  (copy-to-list tree `()))

;; 2.63 a: procedure 2 uses an accumulator to avoid the append operation; the accumulator 
;; kinda looks like we're optimizing for tail recursion but it isn't quite, I think,
;; because the recursion forks.
;; 2.63 b: i had to go to the blogs for this. 2 is O(n), it just does a cons (constant time) for each item.
;; 1 grows quadratically in the worst case, but for a balanced tree O(n * log(n)); this
;; is because the append is O(n) itself.