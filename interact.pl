% interact.pl
% Glenn G. Chappell
% 2025-04-18
%
% For CS 331 Spring 2025
% Code from Apr 18 - Prolog: Interaction


% ***** Preliminaries *****


% read/1 reads a Prolog term, which must be followed by a period (.),
% from the standard input and unifies it with the argument. Output from
% write/1 that is done before read/1 may not appear unless the standard
% output is flushed. This can be done with flush/0.

% Try:
%   ?- write('Type a number followed by dot: '), flush, read(X).


% ***** Example *****


% We can use repeat to do something like a while-true-break loop.

% squares_interact/0
% Repeatedly input a number and print the number and its square. Ends
% when the number is zero.
squares_interact :-
    repeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl,
    X = 0, !,
    write('Bye!'), nl.

% Try:
%   ?- squares_interact.

% Here is squares_interact rewritten to do its "break" in the middle of
% the loop. Helper predicate rest_of_loop helps us do this.

% rest_of_loop/1
% Helper for squares_interact2. Do not call directly.
rest_of_loop(X) :- X = 0, !.
rest_of_loop(X) :-
    write('You typed: '), write(X), nl,
    X2 is X*X,
    write('Its square: '), write(X2), nl,
    nl, fail.

% squares_interact2/0
% Repeatedly input a number and print the number and its square. Ends
% when the number is zero -- NOT printing zero and its square.
% Uses rest_of_loop/1.
squares_interact2 :-
    repeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        rest_of_loop(X),
    write('Bye!'), nl.

% Try:
%   ?- squares_interact2.

% We can rewrite squares_interact2 as a single predicate if we know just
% a bit more.

% ";" is OR, just as "," is AND. The precedence of ";" is lower than
% that of ",".

% To deal with precedence issues, we can use parentheses, as below.

% Now we rewrite squares_interact2 as a single predicate.

% squares_interact3/0
% Repeatedly input a number and print the number and its square. Ends
% when the number is zero -- NOT printing zero and its square.
% Written as a single predicate with no helper required.
squares_interact3 :-
    repeat,
        write('Type a number (0 to quit) followed by dot: '),
        flush,
        read(X),
        nl,
        (X = 0, !
        ;write('You typed: '), write(X), nl,
        X2 is X*X,
        write('Its square: '), write(X2), nl,
        nl, fail),
    write('Bye!'), nl.

% Try:
%   ?- squares_interact3.

