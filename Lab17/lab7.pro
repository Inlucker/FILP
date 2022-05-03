domains
int = integer
list = int*

predicates
length(list, int)
sum_list(list, int)
even(int)
odd(int)
sum_list_odd_r(list, int, int)
sum_list_odd(list, int)
sloh(int, int, int, int)

clauses
length([], L):-L=0, !.
length([_|T], L):-length(T, PL), L = PL + 1.

sum_list([], S):-S=0, !.
sum_list([H|T], Sum):- sum_list(T, NextSum), Sum=H + NextSum.

even(N):-N mod 2 = 0.
odd(N):-N mod 2 = 1.
sloh(H, NS, N, S):-odd(N), S=H+NS, !.
sloh(_, NS, _, S):-S=NS.
sum_list_odd_r([], 0, _):-!.
%sum_list_odd_r([H|T], S, N):-odd(N), NN=N+1, sum_list_odd_r(T, NS, NN), S=H+NS.
%sum_list_odd_r([_|T], S, N):-even(N), NN=N+1, sum_list_odd_r(T, NS, NN), S=NS.
sum_list_odd_r([H|T], S, N):-NN=N+1, sum_list_odd_r(T, NS, NN), sloh(H, NS, N, S).
sum_list_odd(L, S):-sum_list_odd_r(L, S, 0).


goal
%length([], L).
%length([1, 2 , 3], L).
%sum_list([], S).
%sum_list([1, 2 , 3], S).
%sum_list_odd([], SO).
sum_list_odd([1, 2, 3, 4], SO).