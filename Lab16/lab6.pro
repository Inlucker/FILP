domains
int = integer

predicates
fac(int, int)
fib(int, int)

clauses
fac(0, R):-R=1, !.
fac(1, R):-R=1, !.
fac(N, R):-NextN = N-1, fac(NextN, PR), R = PR+N.

fib(1, R):-R=1, !.
fib(2, R):-R=1, !.
fib(N, R):-N1 = N-1, N2 = N-2, fib(N1, PR1), fib(N2, PR2), R = PR1+PR2.

goal
%fac(5, FAC5).
fib(8, FIB).