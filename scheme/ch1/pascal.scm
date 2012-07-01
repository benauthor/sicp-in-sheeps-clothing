(define (pascal line index)
  (if (> line 0)
      (+ (pascal (- line 1) index)
         (pascal (- line 1) (- index 1)))
      (if (= index 0)
          1
          0)))