#lang scheme
; basic.scm
; Glenn G. Chappell
; 2025-03-21
;
; For CS 331 Spring 2025
; Code from Mar 21 - Scheme: Basics


(display "This file contains sample code from March 21, 2025,\n")
(display "for the topic \"Scheme: Basics\".\n")
(display "It will execute, but it is not intended to do anything\n")
(display "useful. See the source.\n")


; ***** Quick Review / General *****


; Single-line comment begins with semicolon

#| Multiline
   comment |#

#;(comment out a (single
                  expression))

; Scheme code consist of expressions. Form a nontrivial expression using
; a list. The first item evaluates to a procedure. The rest of the items
; are its arguments. Each item is evaluated; then the procedure is
; called with the arguments.

; Symbol + evaluates to a procedure that returns the sum of its
; arguments.

; Try:
;   (+ 5 3 4 8 1 2 6)

; Scheme has no infix operators.

; Try:
;   (/ 4 2)
;   (/ 4 6)      ; Result is an exact rational
;   (/ 2/3 4)
;   (+ 1/5 0.7)  ; Result is an (inexact) real = floating-point
; Implicit type conversions integer -> rational -> real -> complex

; "Mod" (% in C++) is "modulo".

; Try:
;   (modulo 19 7)

; Numeric equality: =
; There is no standard numeric inequality operator!
; Ordered comparison operators are as usual.
; Logical operations: and or not
; Try:
;   (= 1 2)
;   (not (= 1 2))
;   (and (> 4 1) (<= 5 2))

; Bind a symbol to a value: define

(define abc (+ 5 3))

; Try:
;   abc
;   (* abc (- abc 5))

(define xyz +)

; Try:
;   (xyz 3 4 5)

; To define a procedure, also use "define". The first argument is a
; picture of a call to the procedure. The second argument is an
; expression given the code for the procedure.

(define (cube x)
  (* x x x)
  )

; Try:
;   (cube 4)

(define (!= a b)
  (not (= a b))
  )

; Try:
;   (!= 1 3)
;   (!= (+ 1 2) 3)

; if-then-else: (if COND THEN-EXPR ELSE-EXPR)

; Try:
;   (if (= 3 3) "yes" "NO")


; ***** Lists *****


; Get first item of a pair: car
; Get second item of a pair: cdr
; For nonempty lists, "car" returns first item, "cdr" returns list of
; remaining items.
; Leading single quote suppresses evaluation.
; Try:
;   (car '(5 4 2 7))
;   (cdr '(5 4 2 7))

; Construct a pair (like Haskell ":"): cons
; (cons 5 '(4 2 7))

; Combinations of car, cdr are predefined.
; Try:
;   (car (cdr '(5 4 2 7)))
;   (cadr '(5 4 2 7))
;   (car (cdr (cdr '(5 4 2 7))))
;   (caddr '(5 4 2 7))


; ***** Predicates *****


; A predicate is a function that returns a boolean. In Scheme, it is
; conventional to end the name of a predicate with "?".

; Type-checking predicates for null, pair, number: null? pair? number?
; Try:
;   (null? '())
;   (null? '(1 2 3))
;   (null? 2)
;   (pair? '())
;   (pair? '(1 2 3))
;   (pair? 2)
;   (number '())
;   (number? '(1 2 3))
;   (number? 2)

; Check whether an object is a list: list? (linear time! use with care)
; Try:
;   (list? 3)
;   (list? '())
;   (list? '(+ 1 2))
;   (list? (+ 1 2))
;   (list? '(1 . 2))

; There is no standard procedure to check for an atom, but we can write
; one.

; atom?
; Returns true if its argument is an atom.
(define (atom? x)
  (cond
    [(null? x)  #f]
    [(pair? x)  #f]
    [else       #t]
    )
  )

; Try:
;   (atom? 3)
;   (atom? "abc")
;   (atom? '())
;   (atom? '(1 2 3 4))
;   (atom? '(+ 1 2))
;   (atom? (+ 1 2))


; ***** Processing Lists *****


; Make a recursive call by using the word being defined inside its body.

; To crash with an error message, pass a string to "error".

; cond is the Scheme equivalent of Haskell's guards. It takes the place
; of an if ... else if ... else if ... else construction. Note the
; "else" as the last condition in the cond construction below.

; is-list?
; Takes one argument of any type. Returns true if it is a list.
; Same as list?.
(define (is-list? xs)
  (cond
    [(null? xs)  #t]
    [(pair? xs)  (is-list? (cdr xs))]
    [else        #f]
    )
  )

; Try:
;   (is-list? 3)
;   (is-list? '(1 2 3))

; len
; Return the length of a list.
(define (len xs)
  (cond
    [(null? xs)  0]
    [(pair? xs)  (+ 1 (len (cdr xs)))]
    [else        (error "len: arg is not a list")]
    )
  )

; Try:
;   (len '())
;   (len '(1 2 3 4 5))
;   (len 3)
;   (len '(+ 1 2))
;   (len (+ 1 2))
; This operation is available as the standard procedure length.
; Try:
;   (length '(1 2 3 4 5))

; "null": variable whose value is an empty list. Can be used like '().

; mymap
; Given a 1-parameter procedure and a list. Does a "map".
(define (mymap f xs)
  (cond
    [(null? xs)  null]
    [(pair? xs)  (cons
                  (f (car xs))
                  (mymap f (cdr xs))
                  )]
    [else        (error "mymap: arg #2 is not a list")]
    )
  )

; Try:
;   (sqr 5)
;   (mymap sqr '(2 33 -5 50 1 100))
; This operation is available as the standard procedure map.
; Try:
;   (map sqr '(2 33 -5 50 1 100))

; lambda creates an unnamed procedure. The first argument of lambda is
; like the first argument of define, without the name. The second
; argument is just like the second argument of define.

; Try:
;   ((lambda (x y) (* 10 x y)) 3 4)
;   (mymap (lambda (x) (* x x x)) '(2 33 -5 50 1 100))

; lookup
; Given integer and list, return the list item with that index. Uses
; zero-based indexing.
(define (lookup ix xs)
  (cond
    [(not (integer? ix))  (error "lookup: arg #1 is not an integer")]
    [(null? xs)           (error "lookup: index out of range")]
    [(not (pair? xs))     (error "lookup: arg #2 is not a list")]
    [(< ix 0)             (error "lookup: index out of range")]
    [(= ix 0)             (car xs)]
    [else                 (lookup (- ix 1) (cdr xs))]
    )
  )

; Try:
;   (lookup 3 '(10 20 30 40 50))
;   (lookup 7 '(10 20 30 40 50))
;   (lookup 1 "abc")
; Note: a Scheme string is not a list!

