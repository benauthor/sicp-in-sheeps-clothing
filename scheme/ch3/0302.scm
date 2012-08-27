;;exercise 3.2 make-monitored
(define (make-monitored func)
  (let ((calls 0))
    (lambda (arg)
      (if (eq? arg `calls?)
          calls
          (begin ;; 'begin' is something they used in the book but I had to look up. tres utile.
            (set! calls (+ calls 1))
            (func arg))))))

;;in use
(define (sq x) (* x x))
(define sqm (make-monitored sq))