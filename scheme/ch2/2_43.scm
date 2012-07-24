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

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))


;; ok, that's all the stock stuff. now the representations for the problem at hand
;; a queen is just a pair
(define (queen x y)
  (cons x y))

(define (print-queen q)
  (newline)
  (display "queen at ") (display (car q)) (display ",") (display (cdr q)))

;; a board is a list of queens, so an empty board is an empty list
(define empty-board `())

(define (add-queen queen board)
  (append board (list queen)))

(define (adjoin-position row column board)
  (add-queen (queen row column) board))

(define (safe? k board) "hmmm")
  ;; this is where I get hung up
;; why does safe? only take the column and the other existing positions as an arg?
;; it presupposes we are adding a row (at bottom?) so row is a given I guess
;; but it is a strange way of conceptualizing it
  

(define (is-safe? proposed-queen board)
  (and (not (place-already-occupied? proposed-queen board))
       (safe-diagonal? proposed-queen board); diagonal will be the tricky one
       (safe-horizontal? proposed-queen board); not necessary, because we're placing on a new line
       (safe-vertical? proposed-queen board)))

;; looking at how people do it I need less of a representation than I want to write
;; http://community.schemewiki.org/?sicp-ex-2.42

;; given their main function:
(define (queens board-size)
  (define (queen-cols k)  
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))