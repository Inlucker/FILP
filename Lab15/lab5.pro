domains
n = integer

predicates
max1a(n,n,n)
max2a(n,n,n,n)
max1b(n,n,n)
max2b(n,n,n,n)

clauses
max1a(X, Y, R):-X>Y, R = X; X<Y, R = Y.

max2a(X, Y, Z, R):-X>Y, X>Z, R = X; Y>X, Y>Z, R = Y; Z>X, Z>Y, R = Z.

max1b(X, Y, X):-X>Y,!.
max1b(_, Y, Y).

max2b(X, Y, Z, X):-X>Y, X>Z, !.
max2b(_, Y, Z, Y):-Y>Z, !.
max2b(_, _, Z, Z).

goal
max1b(6, 2, M1B);
max1a(6, 2, M1A);
max2a(6, 2, 3, M2A);
max2b(6, 2, 3, M2B).