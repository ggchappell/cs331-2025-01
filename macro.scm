#lang scheme
; macro.scm
; Glenn G. Chappell
; Started: 2025-03-28
; Updated: 2025-03-31
;
; For CS 331 Spring 2025
; Code from Mar 28 & 31 - Scheme: Macros


(display "This file contains sample code from March 28 & 31,\n")
(display "2025, for the topic \"Scheme: Macros\".\n")
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


; ***** Multiple-Pattern Macros *****


; define-syntax-rule is a wrapper around define-syntax + syntax-rules.
; The latter can take multiple patterns beginning with the same
; identifier. The first pattern that matches is used.

; Here is qlist, expanded version (renamed qlistx).

; qlistx
; Macro. Just like qlist.
(define-syntax qlistx
  (syntax-rules ()
    [(qlistx . args)
     'args
     ]
    )
  )

; Try:
;   (qlistx (+ 1 2) 7 (+ 2 3))

; An example using multiple patterns.

; def12
; Macro. Define one or two identifiers.
(define-syntax def12
  (syntax-rules ()
    [(def12 s1 e1)
     (define s1 e1)
     ]
    [(def12 s1 e1 s2 e2)
     (begin (define s1 e1) (define s2 e2))
     ]
    )
  )

; Try:
;   (def12 x (+ 5 8))
;   x

; Try:
;   (def12 a (+ 1 2) b (+ 2 3))
;   a
;   b

; defbunch
; Macro. Define an arbitrary number of identifiers.
(define-syntax defbunch
  (syntax-rules ()
    [(defbunch)
     (void)
     ]
    [(defbunch s1 e1 . rest)
     (begin
       (define s1 e1)
       (defbunch . rest)
       )
     ]
    )
  )

; Try:
;   (defbunch a 1 b 2 c (+ 3 3))
;   c


; ***** Keywords in Macros *****


; The list after syntax-rules (which is always empty above) is the list
; of *keywords*. These are words that only match themselves in a
; pattern. The identifier being defined is always a keyword; the list
; allows others to be specified.

; for-each1
; Macro. For-each loop. Iterates over given list. List to iterate over
; is not evaluated.
; Example usage:
;   (for-each1 n in (2 4 10) (display n) (newline))
(define-syntax for-each1
  (syntax-rules (in)
    [(for-each1 var in () . body)
     (void)
     ]
    [(for-each1 var in (head . tail) . body)
     (begin
       (let ([var head])
         (begin . body)
         )
       (for-each1 var in tail . body)
       )
     ]
    )
  )

; Try:
;   (for-each1 i in (2 4 10) (display i) (newline))

; for-each2
; Macro. For-each loop. Iterates over given list. List to iterate over
; is given as an expression, which is evaluated to obtain the list.
; Example usage:
;   (for-each2 n in '(2 4 10) (display n) (newline))
;   (for-each2 i in (append '(2 4) '(10)) (display i) (newline))
(define-syntax for-each2
  (syntax-rules (in)
    [(for-each2 var in list-expr . body)
     (eval (append '(for-each1 var in) (list list-expr) 'body))
     ]
    )
  )

; Try:
;   (for-each2 i in (append '(2 4) '(10)) (display i) (newline))


; ***** EXTRA: Symbolic Differentiation Macros *****


; Raise a to the b power: (expt a b)

; Try:
;   (expt 2 3)

; qderiv
; Macro. Differentiate, with respect to the given variable, a given
; expression. Returns the code for the derivative, quoted.
; Example:
;   (qderiv x (* x (sin x)))
(define-syntax qderiv
  (syntax-rules (+ - * / sqrt log exp expt sin cos tan asin acos atan)
    [(qderiv var (+ a))
     (list '+ (qderiv var a))
     ]
    [(qderiv var (+ a b))
     (list '+ (qderiv var a) (qderiv var b))
     ]
    [(qderiv var (- a))
     (list '- (qderiv var a))
     ]
    [(qderiv var (- a b))
     (list '- (qderiv var a) (qderiv var b))
     ]
    [(qderiv var (* a b))
     (list '+ (list '* 'a (qderiv var b)) (list '* 'b (qderiv var a)))
     ]
    [(qderiv var (/ a))
     (list '- (list '/ (qderiv var a) (list '* 'a 'a)))
     ]
    [(qderiv var (/ a b))
     (list '/ (list '- (list '* 'b (qderiv var a))
                    (list '* 'a (qderiv var b)))
           (list '* 'b 'b))
     ]
    [(qderiv var (sqrt a))
     (list '/ (qderiv var a) (list '* 2 (list 'sqrt 'a)))
     ]
    [(qderiv var (log a))
     (list '/ (qderiv var a) 'a)
     ]
    [(qderiv var (exp a))
     (list '* (list 'exp 'a) (qderiv var a))
     ]
    [(qderiv var (expt a b))
     (list '+ (list '* '(* (expt a b) (log a)) (qderiv var b))
           (list '* '(* b (expt a (- b 1))) (qderiv var a)))
     ]
    [(qderiv var (sin a))
     (list '* (list 'cos 'a) (qderiv var a))
     ]
    [(qderiv var (cos a))
     (list '- (list '* (list 'sin 'a) (qderiv var a)))
     ]
    [(qderiv var (tan a))
     (list '/ (qderiv var a) (list '* (list 'cos 'a) (list 'cos 'a)))
     ]
    [(qderiv var (asin a))
     (list '/ (qderiv var a) (list 'sqrt (list '- 1 (list '* 'a 'a))))
     ]
    [(qderiv var (acos a))
     (list '- (list '/ (qderiv var a)
                    (list 'sqrt (list '- 1 (list '* 'a 'a)))))
     ]
    [(qderiv var (atan a))
     (list '/ (qderiv var a) (list '+ 1 (list '* 'a 'a)))
     ]
    [(qderiv var var2)
     (cond
       [(and (symbol? 'var2) (eq? 'var 'var2)) 1]
       [(number? 'var2) 0]
       [else (error "qderiv: cannot handle expression")]
       )
     ]
    )
  )

; Try:
;   (qderiv x (* x x))
;   (qderiv x (expt x 3))
;   (qderiv x (expt 2 x))
;   (qderiv x (* (sin x) (cos x)))


; deriv
; Macro. Differentiate, with respect to the given variable, a given
; expression. Returns the code for the derivative, unquoted.
; Example:
;   (define (g x) (deriv x (* x (sin x))))
(define-syntax deriv
  (syntax-rules (+ - * / sqrt log exp expt sin cos tan asin acos atan)
    [(deriv var (+ a))
     (+ (deriv var a))
     ]
    [(deriv var (+ a b))
     (+ (deriv var a) (deriv var b))
     ]
    [(deriv var (- a))
     (- (deriv var a))
     ]
    [(deriv var (- a b))
     (- (deriv var a) (deriv var b))
     ]
    [(deriv var (* a b))
     (+ (* a (deriv var b)) (* b (deriv var a)))
     ]
    [(deriv var (/ a))
     (- (/ (deriv var a) (* a a)))
     ]
    [(deriv var (/ a b))
     (/ (- (* b (deriv var a))
           (* a (deriv var b)))
        (* b b))
     ]
    [(deriv var (sqrt a))
     (/ (deriv var a) (* 2 (sqrt a)))
     ]
    [(deriv var (log a))
     (/ (deriv var a) a)
     ]
    [(deriv var (exp a))
     (* (exp a) (deriv var a))
     ]
    [(deriv var (expt a b))
     (+ (* (* (expt a b) (log a)) (deriv var b))
        (* (* b (expt a (- b 1))) (deriv var a)))
     ]
    [(deriv var (sin a))
     (* (cos a) (deriv var a))
     ]
    [(deriv var (cos a))
     (- (* (sin a) (deriv var a)))
     ]
    [(deriv var (tan a))
     (/ (deriv var a) (* (cos a) (cos a)))
     ]
    [(deriv var (asin a))
     (/ (deriv var a) (sqrt (- 1 (* a a))))
     ]
    [(deriv var (acos a))
     (- (/ (deriv var a) (sqrt (- 1 (* a a)))))
     ]
    [(deriv var (atan a))
     (/ (deriv var a) (+ 1 (* a a)))
     ]
    [(deriv var var2)
     (cond
       [(and (symbol? 'var2) (eq? 'var 'var2)) 1]
       [(number? 'var2) 0]
       [else (error "deriv: cannot handle expression")]
       )
     ]
    )
  )

; Try:
;   (define (g x) (deriv x (* x x)))
;   (g 5)

