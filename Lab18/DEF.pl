cell(0, 0,  X, Y, _):-X = 0, Y = 0.
cell(1, 0,  X, Y, _):-X = 1, Y = 0.
cell(2, 0,  X, Y, _):-X = 2, Y = 0.
cell(3, 0,  X, Y, _):-X = 3, Y = 0.
cell(4, 0,  X, Y, _):-X = 4, Y = 0.

cell(0, 1,  X, Y, _):-X = 0, Y = 1.
cell(1, 1,  X, Y, _):-X = 1, Y = 1.
cell(2, 1,  X, Y, _):-X = 1, Y = 3. 		%portal1
cell(3, 1,  X, Y, _):-X = 3, Y = 1.
cell(4, 1,  X, Y, _):-X = 4, Y = 1.

cell(0, 2,  X, Y, _):-X = 0, Y = 2.
cell(1, 2,  _, _, N):-T is (N mod 2), T = 0, !, fail. %1/2 block
cell(1, 2,  X, Y, _):-X = 1, Y = 2.			%1/2 block
cell(2, 2,  X, Y, _):-X = 2, Y = 2.
%cell(3, 2,  _, _, _):-fail. 				%block
cell(4, 2,  X, Y, _):-X = 4, Y = 2.

cell(0, 3,  X, Y, _):-X = 0, Y = 3.
cell(1, 3,  X, Y, _):-X = 2, Y = 1.			%portal1
cell(2, 3,  X, Y, _):-X = 2, Y = 3.
cell(3, 3,  _, _, N):-T is (N mod 4), T = 0, !, fail. 	%1/4 block
cell(3, 3,  X, Y, _):-X = 3, Y = 3.			%1/4 block
cell(4, 3,  X, Y, _):-X = 4, Y = 3.

cell(0, 4,  X, Y, _):-X = 0, Y = 4.
cell(1, 4,  X, Y, _):-X = 1, Y = 4.
cell(2, 4,  X, Y, _):-X = 2, Y = 4.
cell(3, 4,  X, Y, _):-X = 3, Y = 4.
cell(4, 4,  X, Y, _):-X = 4, Y = 4.			%finish

%move(X1, Y1, X2, Y2, N):-cell(X1, Y1, X2, Y2, N).

move(X1, Y1, X2, Y2, N):-NX1 is X1+1, cell(NX1, Y1, X2, Y2, N),
    format('Moved right, pos=[~w;~w]\n', [X2, Y2]).
move(X1, Y1, X2, Y2, N):-NY1 is Y1+1, cell(X1, NY1, X2, Y2, N),
    format('Moved down, pos=[~w;~w]\n', [X2, Y2]).
move(X1, Y1, X2, Y2, N):-NX1 is X1-1, cell(NX1, Y1, X2, Y2, N),
    format('Moved left, pos=[~w;~w]\n', [X2, Y2]).
move(X1, Y1, X2, Y2, N):-NY1 is Y1-1, cell(X1, NY1, X2, Y2, N),
    format('Moved up, pos=[~w;~w]\n', [X2, Y2]).

winner(_, _, N, _):-N > 10, !,fail. %заглушка
winner(X1, Y1, N, Res):-X1=4, Y1=4, !, Res = N,
    format('Reached finish by ~w turns!!!\n\n', [N]).
winner(X1, Y1, N, Res):-format('Turn ~w: ', [N]),
    move(X1, Y1, X2, Y2, N), NN is N+1, winner(X2, Y2, NN, Res).

example(X0, Y0, N, Res):-winner(X0, Y0, N, Res).

%example(0, 1, 0, Res).
%example(0, 1, 1, Res).
    
