;; exercise 3.5 monte carlo integration
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))


(define (mc-integral predicate x1 y1 x2 y2 trials) ;; assuming x1 > x2 and y1 > y2
  (let ((hits 0)
        (area (* (- x1 x2) (- y1 y2)))
        (montecarlo (lambda n total)
                    (if (= n 0)
                        (* (/ hits total) area)
                        (begin 
                          (cond 
                            ((predicate
                              (random-in-range x1 x2)
                              (random-in range y1 y2))
                             (set! hits (+ hits 1))))
                          (montecarlo (- n 1) total)))))
    (montecarlo trials trials)))