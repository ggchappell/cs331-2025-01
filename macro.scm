#lang scheme
; macro.scm  UNFINISHED
; Glenn G. Chappell
; 2025-03-28
;
; For CS 331 Spring 2025
; Code from Mar 28 - Scheme: Macros


(display "This file contains sample code from March 28, 2025,\n")
(display "for the topic \"Scheme: Macros\".\n")
(display "It will execute, but it is not intended to do anything\n")
(display "useful. See the source.\n")


; ***** Single-Pattern Macros *****


; Create pattern-based macro with a single pattern using
; define-syntax-rule. USAGE:
;   (define-syntax-rule (PATTERN) TRANSFORMED_CODE)

; myquote
; Macro. Just like quote.
(define-syntax-rule
  (myquote x)  ; pattern
  'x           ; transformed code
  )

; Try:
;   (myquote (+ 1 2))

; quotetwo
; Macro that takes two arguments and returns a list containing them
; unevaluated.
; Example:
;   (quotetwo (+ 1 2) (+ 2 3))
; gives
;   ((+ 1 2) (+ 2 3))
(define-syntax-rule
  (quotetwo x y)  ; pattern
  '(x y)          ; transformed code
  )

; Try:
;   (quotetwo (+ 1 2) (+ 2 3))

; qlist
; Macro that takes any number of arguments and returns a list containing
; them unevaluated.
; Example:
;   (qlist (+ 1 2) 7 (+ 2 3))
; gives
;   ((+ 1 2) 7 (+ 2 3))
(define-syntax-rule
  (qlist . args)  ; pattern
  'args           ; transformed code
  )

; Try:
;   (qlist (+ 1 2) 7 (+ 2 3))
;   (list (+ 1 2) 7 (+ 2 3))

; swap
; Macro that takes a 2-item list and returns the list with the items
; reversed, then evaluates it.
; Example:
;   (swap ("Hello\n" display))
; will output "Hello\n".
(define-syntax-rule
  (swap (a b))  ; pattern
  (b a)         ; transformed code
  )

; Try:
;   (swap ("Hello\n" display))

; toprod
; Macro that converts anything to a product. Given a nonempty list,
; replaces the first item with *, and evaluates the result.
; Example:
;   (toprod (+ 4 5))
; gives
;   20
(define-syntax-rule
  (toprod (_ . args))  ; pattern
  (* . args)           ; transformed code
  )

; Try:
;   (toprod (+ 1 2 3 4))
;   (toprod (list 7 8 9))
;   (define a 100)
;   (define b 5)
;   (toprod (/ (+ a 2) (- b)))
; Note that the last 3 lines above do the computation from reflect.scm.

; deftwo
; Macro that defines two symbols, setting values equal to given
; expressions.
; Example:
;   (deftwo a 1 b (+ 2 3))
; defines a to be 1 and b to be 5.
(define-syntax-rule
  (deftwo s1 e1 s2 e2)  ; pattern
  (begin                ; transformed code
    (define s1 e1)
    (define s2 e2)
    )
  )

; Try:
;   (deftwo a (+ 1 2) b (+ 2 3))
;   a
;   b

; for-loop1
; Macro. For-loop. Given start, end values. Loop body is 1-parameter
; procedure, which is called with each value from start to end,
; incrementing by 1.
(define-syntax-rule (for-loop1 (start end) proc)
  (let loop (
             [loop-counter start]
             )
    (cond
      [(<= loop-counter end)
       (begin
         (proc loop-counter)
         (loop (+ loop-counter 1))
         )
       ])
    )
  )

; Try:
;   (for-loop1 (3 7) (lambda (i) (begin (display i) (newline))))

; for-loop2
; Macro. For-loop. Given loop-counter variable, start value, end value.
; Loop body is a non-empty sequence of expressions. These are evaluated,
; in order, with loop-counter set to each value from start to end,
; incrementing by 1.
(define-syntax-rule (for-loop2 (var start end) . body)
  (let loop (
             [loop-counter start]
             )
    (cond
      [(<= loop-counter end)
       (begin
         (let ([var loop-counter]) (begin . body))
         (loop (+ loop-counter 1))
         )
       ])
    )
  )

; Try:
;   (for-loop2 (i 3 (+ 2 5)) (display i) (newline))


; MORE TO COME ...

