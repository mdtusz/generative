#lang racket

(require racket/draw)

(define WIDTH 2560)
(define HEIGHT 1440)
(define target (make-bitmap WIDTH HEIGHT #t))
(define dc (new bitmap-dc% [bitmap target]))

; Pen and brush helpers.
(define no-pen (new pen% [style 'transparent]))
(define no-brush (new brush% [style 'transparent]))

; Color helpers.
(define rgba make-color)
(define (hsla h s l a)
    (if (zero? s)
        (rgba l l l a)
        (rgba 100 100 200 a)))

; Colors
(define (smoke o) (rgba 255 255 255 o))
(define (smog o) (rgba 0 0 0 o))
(define red (rgba 255 0 0 0.004))
(define white (rgba 255 255 255 1))

; Initialize drawing context.
(send dc set-smoothing 'aligned)
(send dc set-brush no-brush)

(send dc set-pen (smog 0.2) 1 'solid)
(send dc set-background white)
(send dc clear)

(define (decimated-square x y w h r)
    (define dcp (new dc-path%))
    (define half-width (/ w 2))
    (define half-height (/ h 2))
    (define center-x (- x half-width))
    (define center-y (- y half-height))
    (define (random-width) (random half-width (* w r)))
    (define (random-height) (random half-height h))
    (define start-x
          (- center-x (random-width)))
    (define start-y
          (- center-y (random-height)))

    (send dcp move-to start-x start-y)
    (send dcp line-to
          (+ center-x (random-width))
          (- center-y (random-height)))
    (send dcp line-to
          (+ center-x (random-width))
          (+ center-y (random-height)))
    (send dcp line-to
          (- center-x (random-width))
          (+ center-y (random-height)))
    (send dcp line-to start-x start-y)
    dcp)


(send dc set-pen (smog 0.2) 1 'solid)
(for ([i (in-range 3)])
    (for ([i (in-range 10)])
        (for ([j (in-range 10)])
            (send dc draw-path (decimated-square
                                (* 240 (+ 1 i))
                                (* 138 (+ 1 j))
                                80
                                60
                                (+ 1 i))))))


(send target save-file "images/test.png" 'png)
