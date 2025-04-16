% flow.pl
% Glenn G. Chappell
% 2025-04-16
%
% For CS 331 Spring 2025
% Code from Apr 16 - Prolog: Flow of Control


% ***** Preliminaries *****


% Output term (for atom, think: string): write(TERM)
% Output newline: nl
% Both always succeed.

% hello_world/0
% Print hello-world message.
hello_world :- write('Hello, world!'), nl.

% Try:
%   ?- hello_world.

% true/0 - always succeeds
% fail/0 - never succeeds

% Try:
%   ?- true.
%   ?- fail.


% ***** Basic Repetition *****


% print_squares/2
% print_squares(a, b) prints a message indicating the squares of
% integers a, a+1, ... up to b, each on a separate line.
print_squares(A, B) :-
    A =< B,
    S is A*A,
    write(A), write(' squared is '), write(S), nl,
    A1 is A+1, print_squares(A1, B).

% Try:
%   ?- print_squares(2, 8).

% We can also encapsulate the recursion in a predicate.

% myFor/3
% If X is bound, succeed if a <= x <= b.
% If X is free, succeed with X = n for each n with a <= n <= b.
myFor(A, B, X) :- A =< B, X = A.
myFor(A, B, X) :- A =< B, A1 is A+1, myFor(A1, B, X).

% So "myFor" starts a loop. How do we end it?
% One answer: fail.
% "fail" never succeeds; so it always backtracks.

% Try:
%   ?- myFor(1, 5, 3).
%   ?- myFor(1, 5, 7).
%   ?- myFor(1, 5, X).
%   ?- myFor(1, 5, X), write(X), nl.
%   ?- myFor(1, 5, X), write(X), nl, fail.

% print_squares2/2
print_squares2(A, B) :-
    myFor(A, B, I),
        S is I*I,
        write(I), write(' squared is '), write(S), nl,
    fail.  % Here, "fail" means backtrack.

% Try:
%   ?- print_squares2(2, 8).

% SWI-Prolog includes the functionality of myFor, in the form of
% between/3.


% ***** Cut *****


% "!" (read as "cut")
% - Always succeeds.
% - Once a cut has been done:
%   - Backtracking past the cut is not allowed, for the current goal.
%   - Included in this: use of another definition for the current goal
%     is not allowed.

% Cut can be used as something like a "break".

% print_near_sqrt/1
% For X > 0. print_near_sqrt(X) prints largest integer whose square is
% at most X.
print_near_sqrt(X) :-
    X1 is X+1,
    between(1, X1, I),
        I2 is I*I,
    I2 > X, !,
    I1 is I-1, write(I1), nl.

% Try:
%   print_near_sqrt(105).

% Cut can do if ... else.

% Consider the following C++ code.
%
%   void test_big(int n)
%   {
%       if (n > 20)
%           cout << n << " IS A BIG NUMBER!" << endl;
%       else
%           cout << n << " is not a big number." << endl;
%   }
%
% Here it is in Prolog:

% test_big/1
% test_big(+n) prints a message indicating whether n > 20.
test_big(N) :- N > 20, !, write(N), write(' IS A BIG NUMBER!'), nl.
test_big(N) :- write(N), write(' is not a big number.'), nl.

% Try:
%   ?- test_big(100).
%   ?- test_big(2).

% More generally, cut can be used to ensure that only one definition of
% a predicate is used.

% Here is our "gcd" predicate from simple.pl:
gcd(0, B, B).
gcd(A, B, C) :- A > 0, BMODA is B mod A, gcd(BMODA, A, C).

% And here is a rewritten version, using cut:

% gcd2(+a, +b, ?c)
% gcd2(A, B, C) means the GCD of A and B is C. A, B should be
% nonnegative integers. C should be a nonnegative integer or a free
% variable.
gcd2(0, B, B) :- !.
gcd2(A, B, C) :- A > 0, BMODA is B mod A, gcd2(BMODA, A, C).

% Try:
%   ?- gcd(30, 105, X).
%   ?- gcd2(30, 105, X).
%   ?- gcd2(30, 105, 15).
%   ?- gcd2(30, 105, 14).
% Note that gcd2 lacks the annoying "false" that gcd prints at the end
% of a successful run.

% With cut, we can write "not".

% not/1
% Given a zero-argument predicate or compound term. Succeeds if the
% given term fails.
not(T) :- call(T), !, fail.
not(_).

% Try:
%   ?- not(3 = 3).
%   ?- not(3 = 4).

% SWI-Prolog includes the functionality of "not", in the form of "\+".


% ***** Other Repetition *****


% true/0 always succeeds, but only once.

% myRepeat/0 succeeds an unlimited number of times.
myRepeat.
myRepeat :- myRepeat.

% Try:
%   true.
%   myRepeat.

% SWI-Prolog includes the functionality of "myRepeat", in the form of
% "repeat".

% Since repeat does not alter any variables, it is pretty much useless,
% unless there is functionality available that is nondeterministic: it
% can give different output for the same input.

% One form of nondeterminism involves pseudorandom number generation.
% Function random takes a single integer n and returns an integer in the
% range 0 .. n-1.

% writeUntilZero/0
% Outputs random numbers from 0 to 9, each on a separate line, until the
% number is zero.
writeUntilZero :-
    repeat,
        X is random(10),
        write(X), nl,
    X =:= 0, !.

% Try:
%   writeUntilZero.

% Another form of nondeterminism involves user input. We look at this
% soon.

