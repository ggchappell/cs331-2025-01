#lang scheme
; check_scheme.scm
; Glenn G. Chappell
; 2025-02-11
;
; For CS 331 Spring 2025
; A Scheme Program to Run
; Used in Assignment 3, Exercise A


; Useful Functions

(define (a x y)
  (if (null? x)
      y
      (cons (car x) (a (cdr x) y)))
  )

(define (aa . xs)
  (if (null? xs)
      '()
      (a (car xs) (apply aa (cdr xs)))
      )
  )

(define (m d ns)
  (if (null? ns)
      '()
      (let ([n (+ d (car ns))])
        (cons (integer->char n) (m n (cdr ns))))
      )
  )

(define (mm ns) (list->string (m 0 ns)))


; Mysterious Data

(define cds1 '(84 20 -3 -69 45))
(define cds2 '(20 6 2 -6 -67))
(define cds3 '(55 24 3 -14 15))
(define cds4 '(-83 65 17 -13 -69))
(define cds5 '(51 30 4 -16 -4))
(define cds6 '(12 -4 10 -11 -72))
(define cds7 '(47 36 0 -10 -3))
(define cds8 '(12 -17 6 -2))


; Mysterious Output

(display "Secret message #3:\n\n")
(display (mm (aa cds1 cds2 cds3 cds4 cds5 cds6 cds7 cds8)))
(newline)
(newline)

