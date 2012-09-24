;; exercise 3.5 monte carlo integration
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (mc-integral predicate x1 y1 x2 y2 trials) ;; assuming x1 > x2 and y1 > y2
   (let ((hits 0)
        (area (* (- x1 x2) (- y1 y2))))
     
     (define (test predicate x1 y1 x2 y2)
       (let ((result (predicate (random-in-range x1 x2) (random-in range y1 y2))))
         (and (and (< (car result) x1) (> (car result x2)))
              (and (< (cdr result) y1) (> (cdr result y2))))))
     
     (define (montecarlo n)
       (if (= trials n)
           (* (/ hits n) area)
           (begin
             (cond ((test predicate x1 y1 x2 y2)
                    (set! hits (+ hits 1))))
             (montecarlo (- n 1)))))
     
     (montecarlo trials)))