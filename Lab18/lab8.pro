domains
int = integer
list = int*

predicates
get_greater(list, int, list)
ggh(int, list, int, list)
even(int)
odd(int)
goh(int, list, int, list)
get_odds_r(list, int, list)
get_odds(list, list)
dh(int, list, int, list)
delete(list, int, list)
member(int, list)
ltsh(int, list, list)
list_to_set(list, list)

clauses
ggh(H, T, N, L):-H>N, L=[H|T], !.
ggh(_, T, _, L):-L=T.
get_greater([X], N, L):-ggh(X, [], N, L), !.
get_greater([H|T], N, L):-get_greater(T, N, NL), ggh(H, NL, N, L).

even(N):-N mod 2 = 0.
odd(N):-N mod 2 = 1.
goh(H, T, N, L):-odd(N), L=[H|T], !.
goh(_, T, _, L):-L=T.
get_odds_r([], _, []):-!.
get_odds_r([H|T], N, L):-NN=N+1, get_odds_r(T, NN, NL), goh(H, NL, N, L).
get_odds(L, R):-get_odds_r(L, 0, R).

dh(H, T, N, L):-not(H=N), L=[H|T], !.
dh(_, T, _, L):-L=T.
delete([], _, []):-!.
delete([H|T], N, R):-write(T), nl, delete(T, N, NR), dh(H, NR, N, R).

member(N, [N|_]):-!.
member(N, [_|T]):-member(N,T).
ltsh(H, T, L):-member(H,T), L=T, !.
ltsh(H, T, L):-L=[H|T], !.
list_to_set([], []):-!.
list_to_set([H|T], R):-list_to_set(T, NR), ltsh(H, NR, R).

goal
%get_greater([1, 2, 3], 0, RES).
%get_greater([1, 2, 3], 1, RES).
%get_odds([1, 2, 3, 4], RES).
%get_odds([1], RES).
%delete([], 2, RES).
%delete([1, 1, 2, 2, 3, 3], 2, RES).
list_to_set([1, 1, 2, 2, 3, 3, 4], RES).