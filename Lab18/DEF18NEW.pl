:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_error)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_open)).
:- use_module(library(http/json)).
:- use_module(library(http/http_client)).

:- initialization server.

%cell templates
/*
cell(X, Y, empty):-update_pos(X, Y).
cell(X, Y, block1):-fail.
cell(X, Y, block2):-turn(N), T = (N mod 2), T = 0, fail, !.
cell(X, Y, block2):-update_pos(X, Y).
cell(X, Y, block4):-turn(N), T = (N mod 4), T = 0, fail, !.
cell(X, Y, block4):-update_pos(X, Y).
cell(X, Y, portal1):-cell(I, J, portal1), not(I=X), not(J=Y), update_pos(I, J)).
cell(X, Y, finish):-update_pos(X, Y), assert2(finish()).
*/

assert2(X):-asserta(X).
assert2(X):-retract(X), fail.

create_turn():-retractall(turn(_)), asserta(turn(0)).
create_pos(X, Y):-retractall(pos(_, _)), asserta(pos(X, Y)).

update_turn():-turn(N), NN is N+1, assert2(turn(NN):-!).
update_pos(X, Y):-assert2(pos(X, Y):-!), update_turn().
update_min(M):-	retractall(min(_)),
				asserta(min(M):-!).

reset(X0, Y0):-	retractall(min(_)),
				retractall(finish()),
				create_turn(),
				create_pos(X0, Y0).
reset_finish():-retractall(finish()).

create_cell(X, Y, "player"):-	assertz(cell(X, Y, empty):-update_pos(X, Y)), reset(X, Y).
create_cell(X, Y, "empty"):-	assertz(cell(X, Y, empty):-update_pos(X, Y)).
%create_cell(X, Y, "portal"):-	assertz(cell(X, Y, portal):-).
create_cell(X, Y, "block1"):-	assertz(cell(X, Y, block1):-fail).
create_cell(X, Y, "block2"):-	assertz((cell(X, Y, block2):-turn(N), T = (N mod 2), T = 0, fail, !)),
								assertz(cell(X, Y, block2):-update_pos(X, Y)).
create_cell(X, Y, "block4"):-	assertz((cell(X, Y, block4):-turn(N), T = (N mod 4), T = 0, fail, !)),
								assertz(cell(X, Y, block4):-update_pos(X, Y)).
create_cell(X, Y, "finish"):-	assertz((cell(X, Y, finish):-update_pos(X, Y), assert2(finish()))).	

create_all_cells([]):-!.
create_all_cells([H|T]):-create_cell(H.x, H.y, H.cell), create_all_cells(T).

create_pole(Dict):-	retractall(cell(_, _, _)),
					Pole = Dict.pole,
					create_all_cells(Pole),
					W = Dict.width, H = Dict.height,
					update_min(W*H).

/*cell(0, 0, empty):-update_pos(0, 0).
cell(1, 0, empty):-update_pos(1, 0).
cell(2, 0, empty):-update_pos(2, 0).
cell(3, 0, empty):-update_pos(3, 0).
cell(4, 0, empty):-update_pos(4, 0).

cell(0, 1, empty):-update_pos(0, 1).
cell(1, 1, empty):-update_pos(1, 1).
cell(2, 1, portal11):-update_pos(1, 3). %cell(I, J, portal12), not(I=2), not(J=1), update_pos(I, J).
cell(3, 1, empty):-update_pos(3, 1).
cell(4, 1, empty):-update_pos(4, 1).

cell(0, 2, empty):-update_pos(0, 2).
cell(1, 2, block2):-turn(N), T is (N mod 2), T = 0, !, fail.
cell(1, 2, block2):-update_pos(1, 2).
cell(2, 2, empty):-update_pos(2, 2).
cell(3, 2, block1):-fail.
cell(4, 2, empty):-update_pos(4, 2).

cell(0, 3, empty):-update_pos(0, 3).
cell(1, 3, portal12):-update_pos(2, 1). %cell(I, J, portal11), not(I=1), not(J=3), update_pos(I, J).
cell(2, 3, empty):-update_pos(2, 3).
cell(3, 3, block4):-turn(N), T is (N mod 4), T = 0, !, fail.
cell(3, 3, block4):-update_pos(3, 3).
cell(4, 3, empty):-update_pos(4, 3).

cell(0, 4, empty):-update_pos(0, 4).
cell(1, 4, empty):-update_pos(1, 4).
cell(2, 4, empty):-update_pos(2, 4).
cell(3, 4, empty):-update_pos(3, 4).
cell(4, 4, finish):-update_pos(4, 4), assert2(finish()).*/

get_blocks(N, Blocks):-	T4 is (N mod 4), T4 = 0, T2 is (N mod 2), T2 = 0,
						B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:0}, B4=json{x:3, y:3, n:0},
						Blocks = [B1, B2, B4], !.
get_blocks(N, Blocks):-	T2 is (N mod 2), T2 = 0, T4 is 4-(N mod 4),
						B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:0}, B4=json{x:3, y:3, n:T4},
						Blocks = [B1, B2, B4], !.
get_blocks(N, Blocks):-	T4 is 4-(N mod 4), T2 is 2-(N mod 2),
						B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:T2}, B4=json{x:3, y:3, n:T4},
						Blocks = [B1, B2, B4].
get_portals(Portals):-	P1 = json{x:2, y:1}, P2 = json{x:1, y:3}, Portals = [P1, P2].
get_finish(Finish):-	Finish = json{x:4, y:4}.
get_pole(Pole):-%Pole =json{empty:0}.
				pos(X, Y), turn(NN), N is NN-1,
				get_blocks(N, Blocks),
				get_portals(Portals),
				get_finish(Finish),
				Pole = json{player:json{x:X, y:Y}, walls:Blocks, portals:Portals, finish:Finish}.

move(Move):-reset_finish(), pos(X, Y), NX is X+1, cell(NX, Y, _),
			%pos(X2, Y2), format('Moved right, pos=[~w;~w]\n', [X2, Y2]),
			get_pole(Move).
move(Move):-reset_finish(), pos(X, Y), NY is Y+1, cell(X, NY, _),
			%pos(X2, Y2), format('Moved down, pos=[~w;~w]\n', [X2, Y2]),
			get_pole(Move).
move(Move):-reset_finish(), pos(X, Y), NX is X-1, cell(NX, Y, _),
			%pos(X2, Y2), format('Moved left, pos=[~w;~w]\n', [X2, Y2]),
			get_pole(Move).
move(Move):-reset_finish(), pos(X, Y), NY is Y-1, cell(X, NY, _),
			%pos(X2, Y2), format('Moved up, pos=[~w;~w]\n', [X2, Y2]),
			get_pole(Move).

winner(_, _):-	min(Min), turn(N), NN is N-1, NN > Min, !, fail. %Не ищем решения длинее найденых
winner(Path, Path):-finish(),
					turn(N),
					Res is N-1,
					%format('Reached finish by ~w turns!!!\n\n', [Res]),
					update_min(Res).
winner(Path, FullPath):-%turn(N), format('Turn ~w: ', [N]),
						move(Move),
						append(Path, [Move], NewPath),
						winner(NewPath, FullPath).
				
get_path(Path):-get_pole(Pole0),
				winner([Pole0], Path).
    
:- http_handler(root(.), my_func, []).
	
my_func(Request):-
	http_read_json_dict(Request, Dict),
	create_pole(Dict),
	get_path(Path),
	reply_json(json{pole:Path}).
	
server():-http_server(http_dispatch, [port(3000)]).

%Client part (NO NEED :D)
/*
read_from_server_dict(Dict):-	http_open('http://localhost:3000/', In, []),
								json_read_dict(In, Dict),
								write(Dict),
								close(In).
								
read_from_server_json(Json):-	http_open('http://localhost:3000/', In, []),
								json_read(In, Json),
								write(Json),
								close(In).
*/

%old funcs
/*example(X0, Y0, Path, Res):-reset(X0, Y0), update_min(25),
							update_turn(),
							get_pole(Pole0),
							winner([Pole0], Path),
							turn(N), Res is N-1.
						
get_min(X0, Y0, Min):-	reset(X0, Y0),
						update_min(25),
						findall(_, winner([], _), _), min(Min).*/

%get_min(0, 1, Min).
%example(0, 1, Path, Res).

/*my_func(Request):-
	http_read_json(Request, Json),
	reply_json(Json).*/
	
/*my_func(Request):-
	http_read_json_dict(Request, Dict),
	create_pole(Dict),
	get_min(0, 1, _),
	%example(0, 1, Path, _),
	reply_json(json{pole:Path}).*/

%MORE NO NEED CLAUSES
/*
create_list([], List, List):-!.
create_list([H|T], List, OldList):-	NewElem = json{x:H.x, y:H.y, cell:H.cell},
									append(OldList, [NewElem], NewList),
									create_list(T, List, NewList).

json_from_dict(Dict, Json):-Pole = Dict.pole, create_list(Pole, List, []), Json = json{pole:List}.
*/
