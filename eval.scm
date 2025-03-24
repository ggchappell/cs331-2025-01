#lang scheme
; eval.scm
; Glenn G. Chappell
; 2025-03-24
;
; For CS 331 Spring 2025
; Code from Mar 24 - Scheme: Evaluation


(display "This file contains sample code from March 24, 2025,\n")
(display "for the topic \"Scheme: Evaluation\".\n")
(display "It will execute, but it is not intended to do anything\n")
(display "useful. See the source.\n")


; ***** Expressions *****


; quote
; Macro with 1 argument. Returns its argument unevaluated.
; Try:
;   (+ 5 3)
;   (quote (+ 5 3))

; Leading single quote (') is syntactic sugar for a list beginning with
; quote.
; Try:
;   '(+ 5 3)
;   (quote (quote (a b c)))

; eval
; Procedure with 1 argument. Evaluates the argument.
; Try:
;   (list "hello" '+ 1 2 3)
;   (eval (cdr (list "hello" '+ 1 2 3)))

; Call a procedure with given arguments: apply
; Try:
;   (apply + '(1 2 3))


; ***** Closures *****


; Scheme procedures are closures. In practice, we use this idea when we
; return a function from a function (just as we did in Lua).

; multiply
; Given a number k, returns a function that multiplies by k.
(define (multiply k)
  (cond
    [(number? k)  (lambda (x) (* k x))]
    [else         (error "multiply: arg is not a number")]
    )
  )

; Try:
;   (define f (multiply 2))
;   (define g (multiply 10))
;   (f 7)
;   (g 7)
;   ((multiply 5) 6)


; ***** Local Variables *****


; let
; Macro. Like the function of the same name in Haskell, defines local
; variables. It takes 2 parameters. First is a list of 2-item lists,
; each of which has a symbol and its desired value. Second is an
; expression. The expression is evaluated with the variables set to
; their values, and the result is returned. The variables are local to
; the "let", and are not accessible outside it.

; myfilter - like filter
(define (myfilter p xs)
  (cond
    [(null? xs)  null]
    [(pair? xs)
     (let (
           [first (car xs)]
           [rest  (myfilter p (cdr xs))]
           )
       (cond
         [(p first)  (cons first rest)]
         [else       rest]
         )
       )]
    [else         (error "myfilter: arg #2 is not a list")]
    )
  )

; even?
; Predicate. Given an integer, indicates whether it is even.

; Try:
;   (myfilter even? '(1 4 8 7 11 100))
;   (myfilter string? '(1 "abc" (1 2 3) "def"))
;   (myfilter string? 3)

; let*
; Macro. Like "let", but the local variables are defined in order (not
; all at the same time as "let" does). So in a let*, variable
; definitions can reference previously defined variables.

; sqr-interact
; Inputs a number from the console. Prints its square.
(define (sqr-interact)
  (begin
    (display "Type a number: ")
    (let* (
           [line (read-line)]
           [num  (string->number line)]  ; num may be #f
           )
      (cond
        [num   (begin
                 (display "Your number squared: ")
                 (display (* num num))
                 (newline))]
        [else  (display "You did not type a number, you idiot!\n")]
        )
      )
    )
  )

; Try:
;   (sqr-interact)

; "let" can optionally be followed by a symbol. Inside the let, this
; symbol is defined to be a procedure that calls the let. The
; procedure's arguments are the desired values of the local variables.
;
; The procedure is often named "loop".

(define (five-and-down)
  (begin
    (display "Five and Down\n")
    (let loop
      ([i 5])
      (begin
        (display i)
        (newline)
        (if (> i 0) (loop (- i 1)) (void))
        )
      )
    )
  )

; Try:
;   (five-and-down)


; ***** Laziness *****


; Promises

; A Scheme promise is a wrapper for an unevaluated expression. Check for
; a promise with predicate "promise?".

; delay
; Macro. Given an expression. Returns a promise wrapping it.
; The expression is not evaluated until it is later forced (see below).

; force
; Procedure with 1 argument. If it is a promise, then forces the
; promise, which results in the wrapped expression being evaluated. The
; result is returned. Forcing a promise multiple times does not
; reevaluate the wrapped expression; the same value is returned each
; time.
;
; If the argument is not a promise, then "force" simply returns it
; (evaluating it first, because "force" is a procedure.

; Lazy Lists

; We can create lazy lists as follows: construct a list as usual, from
; pairs and null, but wherever there is a pair, its two elements are
; promises wrapping the first item in the list and a lazy list of the
; rest of the items. Note that, unlike ordinary Scheme lists, a lazy
; list stored in this manner may be infinite.

; countfrom
; Given a number, return an infinite lazy list (see above) with items
; k, k+1, k+2, etc.
(define (countfrom k)
  (cons (delay k) (delay (countfrom (+ 1 k))))
  )

; posints
; Infinite lazy list (see above) with items 1, 2, 3, etc.
(define posints (countfrom 1))

; fibo-ish
; Given two numbers a, b, return an infinite lazy list (see above) whose
; first two items are a, b, and each subsequent item is the sum of the
; previous two: a, b, a+b, a+2b, 2a+3b, etc.
(define (fibo-ish a b)
  (cons (delay a) (delay (fibo-ish b (+ a b))))
  )

; fibos, lucas
; Infinite lazy lists (see above) of all Fibonacci numbers and all Lucas
; numbers, respectively.
(define fibos (fibo-ish 0 1))
(define lucas (fibo-ish 2 1))

; Scheme has "take", which is like Haskell's "take", but the arguments
; are in the reverse order.

; Try:
;   (take '(1 2 3 4 5) 3)

; ltake
; Given a list or lazy list (see above) and a number "count". Returns a
; regular (non-lazy) list of the first "count" items.
(define (ltake lxs count)
  (let
      ([lxsf (force lxs)])
    (cond
      [(not
        (integer? count))  (error "ltake: arg #2 is not an integer")]
      [(<= count 0)        null]
      [(null? lxsf)        null]
      [(pair? lxsf)        (cons
                            (force (car lxsf))
                            (ltake (cdr lxsf) (- count 1))
                            )]
      [else                (error "ltake: arg #1 is not a (lazy) list")]
      )
    )
  )

; Try:
;   (ltake '(1 2 3 4 5 6 7 8 9) 5)
;   (ltake posints 100)
;   (ltake fibos 20)
;   (ltake lucas 20)

