:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/http_json)).

:- initialization server.

cell(0, 0,  X, Y, _):-X = 0, Y = 0.
cell(1, 0,  X, Y, _):-X = 1, Y = 0.
cell(2, 0,  X, Y, _):-X = 2, Y = 0.
cell(3, 0,  X, Y, _):-X = 3, Y = 0.
cell(4, 0,  X, Y, _):-X = 4, Y = 0.

cell(0, 1,  X, Y, _):-X = 0, Y = 1.
cell(1, 1,  X, Y, _):-X = 1, Y = 1.
cell(2, 1,  X, Y, _):-X = 1, Y = 3. 					%portal1
cell(3, 1,  X, Y, _):-X = 3, Y = 1.
cell(4, 1,  X, Y, _):-X = 4, Y = 1.

cell(0, 2,  X, Y, _):-X = 0, Y = 2.
cell(1, 2,  _, _, N):-T is (N mod 2), T = 0, !, fail. 	%1/2 block
cell(1, 2,  X, Y, _):-X = 1, Y = 2.						%1/2 block
cell(2, 2,  X, Y, _):-X = 2, Y = 2.
%cell(3, 2,  _, _, _):-fail. 							%block
cell(4, 2,  X, Y, _):-X = 4, Y = 2.

cell(0, 3,  X, Y, _):-X = 0, Y = 3.
cell(1, 3,  X, Y, _):-X = 2, Y = 1.						%portal1
cell(2, 3,  X, Y, _):-X = 2, Y = 3.
cell(3, 3,  _, _, N):-T is (N mod 4), T = 0, !, fail. 	%1/4 block
cell(3, 3,  X, Y, _):-X = 3, Y = 3.						%1/4 block
cell(4, 3,  X, Y, _):-X = 4, Y = 3.

cell(0, 4,  X, Y, _):-X = 0, Y = 4.
cell(1, 4,  X, Y, _):-X = 1, Y = 4.
cell(2, 4,  X, Y, _):-X = 2, Y = 4.
cell(3, 4,  X, Y, _):-X = 3, Y = 4.
cell(4, 4,  X, Y, _):-X = 4, Y = 4, asserta(finish()).	%finish

get_blocks(N, Blocks):-T4 is (N mod 4), T4 = 0, T2 is (N mod 2), T2 = 0,
    B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:0}, B4=json{x:3, y:3, n:0},
    Blocks = [B1, B2, B4], !.
get_blocks(N, Blocks):-T2 is (N mod 2), T2 = 0, T4 is 4-(N mod 4),
    B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:0}, B4=json{x:3, y:3, n:T4},
    Blocks = [B1, B2, B4], !.
get_blocks(N, Blocks):-T4 is 4-(N mod 4), T2 is 2-(N mod 2),
    B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:T2}, B4=json{x:3, y:3, n:T4},
    Blocks = [B1, B2, B4].
get_portals(Portals):-P1 = json{x:2, y:1}, P2 = json{x:1, y:3}, Portals = [P1, P2].
get_finish(Finish):-Finish = json{x:4, y:4}.
get_pole(X, Y, N, Pole):-get_blocks(N, Blocks), get_portals(Portals), get_finish(Finish), Pole = json{player:json{x:X, y:Y}, walls:Blocks, portals:Portals, finish:Finish}.

move(X1, Y1, X2, Y2, N, Move):-reset_finish(), NX1 is X1+1, cell(NX1, Y1, X2, Y2, N),
    %format('Moved right, pos=[~w;~w]\n', [X2, Y2]),
    get_pole(X2, Y2, N, Move).
    %Move = json{x:X2, y:Y2}.
    %swritef(Move, '%w %w', [X2, Y2]).
    %Move = "R".
move(X1, Y1, X2, Y2, N, Move):-reset_finish(), NY1 is Y1+1, cell(X1, NY1, X2, Y2, N),
    %format('Moved down, pos=[~w;~w]\n', [X2, Y2]),
    get_pole(X2, Y2, N, Move).
    %Move = json{x:X2, y:Y2}.
    %swritef(Move, '%w %w', [X2, Y2]).
    %Move = "D".
move(X1, Y1, X2, Y2, N, Move):-reset_finish(), NX1 is X1-1, cell(NX1, Y1, X2, Y2, N),
    %format('Moved left, pos=[~w;~w]\n', [X2, Y2]),
    get_pole(X2, Y2, N, Move).
    %Move = json{x:X2, y:Y2}.
    %swritef(Move, '%w %w', [X2, Y2]).
    %Move = "L".
move(X1, Y1, X2, Y2, N, Move):-reset_finish(), NY1 is Y1-1, cell(X1, NY1, X2, Y2, N),
    %format('Moved up, pos=[~w;~w]\n', [X2, Y2]),
    get_pole(X2, Y2, N, Move).
    %Move = json{x:X2, y:Y2}.
    %swritef(Move, '%w %w', [X2, Y2]).
    %Move = "U".

update_min(M):-retractall(min(_)), asserta(min(M):-!).
reset_finish():-retractall(finish()).
winner(_, _, N, _, _, _):-min(Min), N > Min, !, fail. %???? ???????? ?????????????? ???????????? ????????????????
winner(_, _, N, Res, Path, Path):-%format('Reached finish by ~w turns!!!\n\n', [N]),
	finish(), !, Res is N-1, update_min(Res).
winner(X1, Y1, N, Res, Path, FullPath):-%format('Turn ~w: ', [N]),
    move(X1, Y1, X2, Y2, N, Move), NN is N+1,
    append(Path, [Move], NewPath),
    winner(X2, Y2, NN, Res, NewPath, FullPath).

reset():-retractall(min(_)), retractall(finish()).
example(X0, Y0, N, Res, Path):-reset(), asserta(min(30):-!), get_pole(X0, Y0, 0, Pole), winner(X0, Y0, N, Res, [Pole], Path).
get_min(X0, Y0, Min):-reset(), asserta(min(30):-!), findall(Res, winner(X0, Y0, 1, Res, [], _), _), min(Min). %, min_list(L, Min).

%example(0, 1, 1, Res, Path).
%get_min(0, 1, Min).
%min(X), example(0, 1, 0, X).
    
:- http_handler(root(.), my_func, []).

my_func(_Request):-
	get_min(0, 1, Min), example(0, 1, 1, Min, Path),
	reply_json(json{pole:Path}).
	
server():-http_server(http_dispatch, [port(3000)]).
    
