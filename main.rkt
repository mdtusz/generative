#lang racket

(require racket/draw)

(define WIDTH 600)
(define HEIGHT 400)
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
(define smoke (rgba 255 255 255 0.01))
(define red (rgba 255 0 0 0.004))
(define white (rgba 255 255 255 1))

; Initialize drawing context.
(send dc set-smoothing 'aligned)
(send dc set-brush no-brush)

(define (sand-circle i)
    (send dc draw-ellipse
        i (random 0 300)
        100 (random 1 100)))

(define (sand-line i)
    (send dc draw-line
        i (random 1 100)
        100 (- 200 (random 1 100))))


(send dc set-pen red 1 'solid)
(for ([i (in-range 4000)])
    (sand-circle i)
    (sand-line i))

(send dc set-pen smoke 1 'solid)
(for ([i (in-range 300)])
    (sand-circle i)
    (sand-line i))

(send dc set-pen white 1 'solid)
(define test-path (new dc-path%))
(send test-path move-to 50 50)
(send test-path curve-to 50 50 104 20 400 102)
(send dc draw-path test-path)


(send target save-file "images/test.png" 'png)
