;; Picture lang stuff from text

;; 'einstein' is too long to type
(define ei einstein)

(define (flipped-pairs painter)
  (let ((painter2 (beside painter (flip-vert painter))))
    (below painter2 (flip-horiz painter2))))

(define (right-split p n)
  (if (= n 0)
      p
      (let ((smaller (right-split p (- n 1))))
        (beside p (below smaller smaller)))))

;; Ex. 2.44 define up-split
(define (up-split p n)
  (if (= n 0)
      p
      (let ((smaller (up-split p (- n 1))))
        (below p (beside smaller smaller)))))

(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left (beside up up))
              (bottom-right (below right right))
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

(define (square-limit painter n)
  (let ((quarter (corner-split painter n)))
    (let ((half (beside (flip-horiz quarter) quarter)))
      (below (flip-vert half) half))))

;; higher order version of 4-squares
(define (square-of-four tl tr bl br)
  (lambda (painter)
    (let ((top (beside (tl painter) (tr painter)))
          (bottom (beside (bl painter) (br painter))))
      (below bottom top))))

(define (flipped-pairs painter)
  (let ((combine4 (square-of-four identity flip-vert
                                  identity flip-vert)))
    (combine4 painter)))

(define (square-limit painter n)
  (let ((combine4 (square-of-four flip-horiz identity
                                  rotate180 flip-vert)))
    (combine4 (corner-split painter n))))

;; 2.45 higher order version of split
(define (split direction1 direction2)
  (lambda (painter n)
    (if (= n 0)
        painter
        (let ((smaller ((split direction1 direction2) painter (- n 1))))
          (direction1 painter (direction2 smaller smaller))))))
  
(define right-split (split beside below))
(define up-split (split below beside))

;; 2.46 make vector primitives for frames
;; note while a vector has two points/4 coordinates, we assume its origin is 0,0
;; so that can be implicit, and the datatype can simply consist of a single pair

(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))
(define (add-vect v1 v2)
  (make-vect
   (+ (xcor-vect v1) (xcor-vect v2))
   (+ (ycor-vect v1) (ycor-vect v2))))
(define (sub-vect v1 v2)
  (make-vect
   (- (xcor-vect v1) (xcor-vect v2))
   (- (ycor-vect v1) (ycor-vect v2))))
(define (scale-vect s v)
  (make-vect (* s (xcor-vect v) (* s (ycor-vect v)))))

;; 2.47 now implement frame constructors and selectors
; frame as list
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))
(define (origin f)
  (car f))
(define (edge1 f)
  (cadr f))
(define (edge2 f)
  (caddr f))
; frame as pair
(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define (origin f)
  (car f))
(define (edge1 f)
  (cadr f))
(define (edge2 f)
  (cddr f)); this is the only difference.

;; ex. 2.48 construct segments with vectors
(define (make-segment start end)
  (cons start end))
(define (start-segment s)
  (car s))
(define (end-segment s)
  (cdr s))

;; 2.49 construct some painters using segments->painter
;; here's segments->painter
(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
        ((frame-coord-map frame) (start-segment segment))
        ((frame-coord-map frame) (end-segment segment))))
     segment-list)))
;;a. outline of a frame
(define outline
  (segments->painter
   (list
    (make-segment (make-vect 0 0) (make-vect 0 1))
    (make-segment (make-vect 0 0) (make-vect 1 0))
    (make-segment (make-vect 0 1) (make-vect 1 1))
    (make-segment (make-vect 1 0) (make-vect 1 1)))))
;;b. connect opposite corners
(define ex
  (segments->painter
   (list
    (make-segment (make-vect 0 0) (make-vect 1 1))
    (make-segment (make-vect 0 1) (make-vect 1 0)))))
;;c. connect midpoints of sides
(define diamond
  (segments->painter
   (list
    (make-segment (make-vect 0 .5) (make-vect .5 0))
    (make-segment (make-vect .5 0) (make-vect 1 .5))
    (make-segment (make-vect 1 .5) (make-vect .5 1))
    (make-segment (make-vect .5 1) (make-vect 0 .5)))))
;; d. make 'wave'. too many segments, that's boring to type.

;;2.50
(define (flip-horiz painter)
  (transform-painter painter
                     (make-vect 1.0 0.0)   ; new origin
                     (make-vect 1.0 1.0)   ; new end of edge1
                     (make-vect 0.0 0.0))) ; new end of edge2
;2.51-2.52, skipping these.