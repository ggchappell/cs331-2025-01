#lang scheme
; data.scm
; Glenn G. Chappell
; 2025-03-26
;
; For CS 331 Spring 2025
; Code from Mar 26 - Scheme: Data


(display "This file contains sample code from March 26, 2025,\n")
(display "for the topic \"Scheme: Data\".\n")
(display "It will execute, but it is not intended to do anything\n")
(display "useful. See the source.\n")


; ***** Data Format *****


; Dot notation is used in a pair literal.
; Try:
;   '(1 . 2)

; List notation is shorthand.
; Try:
;   '(1 . (2 . (3 . (4 . ()))))

; car & cdr are really about pairs, not lists.
; Try:
;   (car '(1 . 2))
;   (cdr '(1 . 2))

; Dot may be used before the last item in a list-like construction.
; Try:
;   '(1 2 3 4 5 . 6)
;   '(1 . (2 . (3 . (4 . (5 . 6)))))


; ***** Comparisons *****

; Scheme has no standard numeric inequality procedure, but we can write
; one.
(define (!= a b) (not (= a b)))

; Try:
;   (!= 3 3.0)
;   (!= 3 4)

; Type-specific comparisons
; Try:
;   (string=? "abc" "abc")
;   (string=? "abc" "def")
;   (string=? 42 42)
;   (string<? "abc" "def")
;   (char=? #\A #\B)

; General comparisons: eq? (same location in memory; avoid using!)
; Try:
;   (eq? '() '())
;   (define a '(1 2))
;   (eq? a '(1 2))
;   (define b a)
;   (eq? a b)

; General comparisons: eqv? (same primitive value)
; Try:
;   (eqv? 2 2)
;   (eqv? 2 2.0)
;   (define a '(1 2))
;   (eqv? a '(1 2))

; General comparisons: equal?
; Try:
;   (equal? "abc" "abc")
;   (equal? "abc" "def")
;   (equal? #\A #\A)
;   (equal? #\A "A")
;   (define a '(1 2))
;   (equal? a '(1 2))

; equal? is a good general-purpose equality predicate, but watch out for
; numbers.
; Try:
;   (= 2 2.0)
;   (equal? 2 2.0)


; ***** More General Procedures *****


; We can define a procedure that takes an arbritrary number of
; arguments. The "picture" of a procedure call given when using "define"
; is (PROC . ARGS), where ARGS becomes a list of the arguments.

; add
; Just like +.
; This serves as an example of how to define a procedure that takes an
; arbitrary number of arguments. The definition uses "+" , but only
; calls it with exactly two arguments.
(define (add . args)
  (cond
    [(null? args)  0]
    [(pair? args)  (+ (car args) (apply add (cdr args)))]
    [else          (error "add: args do not form a list")]
    )
  )

; Try:
;   (add 3 6)
;   (add 1 2 3 4 5 6)
;   (add 42)
;   (add)


; ***** Manipulating Trees *****


; tt
; A tree to mess with
; The atoms in tt are the integers 1-7.
(define tt '((((1 . 2)) 3 . 4) (() . 5) 6 . 7))

; atomsum
; Return the sum of all the numbers in a tree. Atoms that are not
; numbers are skipped.
(define (atomsum t)
  (cond
    [(null? t)    0]
    [(pair? t)    (+ (atomsum (car t)) (atomsum (cdr t)))]
    [(number? t)  t]
    [else         0]
    )
  )

; Try:
;   (atomsum tt)
;   (atomsum '(20 "abc" 30))

; atommap
; Given a one-parameter procedure and a tree, return the tree with each
; atom replaced by (f atom).
(define (atommap f t)
  (cond
    [(null? t)  null]
    [(pair? t)  (cons (atommap f (car t)) (atommap f (cdr t)))]
    [else       (f t)]  ; t is an atom; error if f cannot be called on t
    )
  )

; Try:
;   (atommap sqr tt)
;   (atommap even? tt)

; myconcat
; Return the concatenation of two given lists.
(define (myconcat xs ys)
  (cond
    [(null? xs)  ys]
    [(pair? xs)  (cons (car xs) (myconcat (cdr xs) ys))]
    [else        (error "myconcat: arg #1 is not a list")]
    )
  )

; Try:
;   (myconcat '(1 2 3) '(4 5 6))
; This operation is available as the standard procedure append -- which
; can also concatentate more than two lists.
; Try:
;   (append '(1 2 3) '(4 5 6))
;   (append '(1 2) '(3) '(4 5) '(6))

(define (myflatten t)
  (cond
    [(null? t)  null]
    [(pair? t)  (myconcat (myflatten (car t)) (myflatten (cdr t)))]
    [else       (list t)]  ; t is an atom; (list t) is a one-item list
    )
  )

; Try:
;   (myflatten tt)
; This operation is available as the standard procedure flatten.
; Try:
;   (flatten tt)

