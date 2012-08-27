;;exercise 3.3 protect the make-account procedure
(define (make-account balance secret) ;; expect another arg
  (define (withdraw amount)
    (if (>= balance amount)
        (begin (set! balance (- balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch pw m)
    (if (eq? secret pw) ;; check pw before running
        (cond ((eq? m 'withdraw) withdraw)
              ((eq? m 'deposit) deposit)
              (else (error "Unknown request -- MAKE-ACCOUNT"
                           m)))
        (error "Incorrect password")))
  dispatch)

;; now 3.4, add a password alarm
(define (make-account balance secret)
  (let ((wrong 0));; stash the count in a let
    (define (withdraw amount)
      (if (>= balance amount)
          (begin (set! balance (- balance amount))
                 balance)
          "Insufficient funds"))
    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)
    (define (dispatch pw m)
      (if (eq? secret pw)
          (cond ((eq? m 'withdraw) withdraw)
                ((eq? m 'deposit) deposit)
                (else (error "Unknown request -- MAKE-ACCOUNT"
                             m)))
          (begin ;; log wrong pw attempts
            (set! wrong (+ wrong 1))
            (if (> wrong 3) 
                (call-the-cops)
                (error "wrong password")))))
    dispatch))

(define call-the-cops `weeooeeooeeeoooeeoeooooeeeooooeeooooooooo)