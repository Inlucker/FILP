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

moved_to_cell(cell(X, Y, empty)):-update_pos(X, Y).
moved_to_cell(cell(_, _, block1)):-fail.
moved_to_cell(cell(_, _, block2)):-turn(N), T is ((N+1) mod 2), T = 0, !, fail.
moved_to_cell(cell(X, Y, block2)):-update_pos(X, Y).
moved_to_cell(cell(_, _, block4)):-turn(N), T is ((N+1) mod 4), T = 0, !, fail.
moved_to_cell(cell(X, Y, block4)):-update_pos(X, Y).
%moved_to_cell(cell(_, _, block(B))):-turn(N), T is ((N+1) mod B), T = 0, !, fail.
%moved_to_cell(cell(X, Y, block(_))):-update_pos(X, Y).
moved_to_cell(cell(X, Y, portal)):-cell(I, J, portal), not(I=X), not(J=Y), update_pos(I, J).
moved_to_cell(cell(X, Y, finish)):-update_pos(X, Y), assert2(finish()).

assert2(X):-asserta(X).
assert2(X):-retract(X), fail.

assertz2(X):-assertz(X).
assertz2(X):-retract(X), fail.

create_turn():-	retractall(turn(_)),
				retractall(starting_turn(_)),
				asserta(starting_turn(0)).
create_pos(X, Y):-	retractall(pos(_, _)),
					retractall(starting_pos(_, _)),
					asserta(starting_pos(X, Y)).

update_turn():-turn(N), NN is N+1, assert2(turn(NN):-!).
update_pos(X, Y):-assert2(pos(X, Y):-!), update_turn().
update_min(M):-	retractall(min(_)),
				asserta(min(M):-!).

reset(X0, Y0):-	retractall(pole(_)),
				retractall(min(_)),
				retractall(finish()),
				create_turn(),
				create_pos(X0, Y0).
reset_finish():-retractall(finish()).
reset_all():-	retractall(cell(_, _, _)),
				retractall(pole(_)),
				retractall(min(_)),
				retractall(finish()),
				retractall(turn(_)),
				retractall(pos(_)).

setup():-	reset_finish(),
			retractall(pole(_)),
			retractall(turn(_)),
			starting_pos(X0, Y0),
			assert2(pos(X0, Y0):-!),
			starting_turn(N),
			assert2(turn(N):-!).

create_cell(X, Y, "player"):-	assertz(cell(X, Y, empty)), reset(X, Y).
create_cell(X, Y, "empty"):-	assertz(cell(X, Y, empty)).
create_cell(X, Y, "portal"):-	assertz(cell(X, Y, portal)).
create_cell(X, Y, "block1"):-	assertz(cell(X, Y, block1)).
create_cell(X, Y, "block2"):-	assertz(cell(X, Y, block2)).
create_cell(X, Y, "block4"):-	assertz(cell(X, Y, block4)).
create_cell(X, Y, "finish"):-	assertz(cell(X, Y, finish)).

create_all_cells([]):-!.
create_all_cells([H|T]):-create_cell(H.x, H.y, H.cell), create_all_cells(T).

create_pole(Dict):-	retractall(cell(_, _, _)),
					Pole = Dict.pole,
					create_all_cells(Pole),
					W = Dict.width, H = Dict.height,
					update_min(W*H).


get_player(Player):-	pos(X, Y),
						Player = json{x:X, y:Y}.
get_blocks1(Blocks):-	findall(json{x:X, y:Y, n:0}, cell(X, Y, block1), Blocks).
get_blocks2(N, Blocks):-T is (2-N) mod 2,
						findall(json{x:X, y:Y, n:T}, cell(X, Y, block2), Blocks).
get_blocks4(N, Blocks):-T is (4-N) mod 4,
						findall(json{x:X, y:Y, n:T}, cell(X, Y, block4), Blocks).
get_finish(Finish):-	cell(X, Y, finish),
						Finish = json{x:X, y:Y}.
get_portals(Portals):-	findall(json{x:X, y:Y}, cell(X, Y, portal), Portals).

get_pole(Pole):-get_player(Player),
				turn(N),
				get_blocks1(Blocks1),
				get_blocks2(N, Blocks2),
				get_blocks4(N, Blocks4),
				append(Blocks1, Blocks2, Blocks12),
				append(Blocks12, Blocks4, Blocks),
				get_finish(Finish),
				get_portals(Portals),
				Pole = json{player:Player, walls:Blocks, portals:Portals, finish:Finish}.
			
assert2_pole():-get_player(Player),
				turn(N),
				get_blocks1(Blocks1),
				get_blocks2(N, Blocks2),
				get_blocks4(N, Blocks4),
				append(Blocks1, Blocks2, Blocks12),
				append(Blocks12, Blocks4, Blocks),
				get_finish(Finish),
				get_portals(Portals),
				assertz2(pole(json{player:Player, walls:Blocks, portals:Portals, finish:Finish})).

find_path(Path):-findall(Pole, pole(Pole), Path).

move():-reset_finish(), %вправо
		pos(X, Y),
		NX is X+1,
		cell(NX, Y, Cell),
		moved_to_cell(cell(NX, Y, Cell)),
		assert2_pole().
move():-reset_finish(), %вниз
		pos(X, Y),
		NY is Y+1,
		cell(X, NY, Cell),
		moved_to_cell(cell(X, NY, Cell)),
		assert2_pole().
move():-reset_finish(), %влево
		pos(X, Y), NX is X-1,
		cell(NX, Y, Cell),
		moved_to_cell(cell(NX, Y, Cell)),
		assert2_pole().
move():-reset_finish(), %вверх
		pos(X, Y),
		NY is Y-1,
		cell(X, NY, Cell),
		moved_to_cell(cell(X, NY, Cell)),
		assert2_pole().

winner(_):-	min(Min), turn(N), NN is N-1, NN > Min, !, fail. %Не ищем решения длинее найденых
winner(Path):-	finish(), !,
				find_path(Path),
				turn(N),
				update_min(N).
winner(FullPath):-	move(),
					winner(FullPath).

get_path(FullPath):-setup(),
					assert2_pole(),
					winner(FullPath).

get_min(Min):-	findall(Path, get_path(Path), _),
				min(Min).

%doesn't work, use A*
%get_min_path(Path):-get_min(_),
%					get_path(Path).
    
:- http_handler(root(.), my_func, []).
	
my_func(Request):-
	reset_all(),
	http_read_json_dict(Request, Dict),
	create_pole(Dict),
	%gtrace,
	%get_min(_),
	%get_path(Path),
	%get_min_path(Path), %doesn't work with 3x3 example, updated min to infinity %try to track update_min(9)
	get_min_path(Path),
	reply_json(json{pole:Path}).
	
server():-http_server(http_dispatch, [port(1234)]).

/*----------------*/
/* Azvezda prolog */
/*----------------*/

/* Получаем состояние поля с игрком в координате X, Y, в ход N */
get_blocks1(Blocks):-
    findall(json{x:X, y:Y, n:0}, cell(X, Y, block1), Blocks).
get_blocks2(N, Blocks):-
    T is (2-N) mod 2,
	findall(json{x:X, y:Y, n:T}, cell(X, Y, block2), Blocks).
get_blocks4(N, Blocks):-
    T is (4-N) mod 4,
	findall(json{x:X, y:Y, n:T}, cell(X, Y, block4), Blocks).
get_finish(Finish):-
    cell(X, Y, finish),
	Finish = json{x:X, y:Y}.
get_portals(Portals):-
    findall(json{x:X, y:Y}, cell(X, Y, portal), Portals).

get_pole(Pole, X, Y, N):-
    Player = json{x:X, y:Y},
    get_blocks1(Blocks1),
    get_blocks2(N, Blocks2),
    get_blocks4(N, Blocks4),
    append(Blocks1, Blocks2, Blocks12),
    append(Blocks12, Blocks4, Blocks),
    get_finish(Finish),
    get_portals(Portals),
    Pole = json{player:Player, walls:Blocks, portals:Portals, finish:Finish}.

%очистка базы знаний для алгоритма A*
reset_fields():-retractall(field(_, _, _, _)).

%подготовка очереди для алгоритма A*
setup_queue(Queue):-
    reset_fields(), %очищаем базу знаний для алгоритма A*
    starting_pos(X0, Y0), %получаем начальные координаты игрока
    get_pole(Pole0, X0, Y0, 0), %полуаем начальное состояние поля
    assert(field(X0, Y0, 0, [Pole0])), %добавляем первую информацию для алгоритма A*
    Queue = [field(X0, Y0, 0, [Pole0])]. %И в очередь тоже

/* Правила перемещения */
%если стоит вечная стена, не можем сюда пойти
move_to_cell(cell(_, _, block1), _, _, _):-fail.

%если стоит стена2 и номер хода кратен 2, не можем сюда пойти
move_to_cell(cell(_, _, block2), N, _, _):-T is (N mod 2), T = 0, !, fail. %можно возвращать -1, -1 здесь, а не в check_move
%иначе можем
move_to_cell(cell(X, Y, block2), _, X, Y).

%если стоит стена4 и номер хода кратен 4, не можем сюда пойти
move_to_cell(cell(_, _, block4), N, _, _):-T is (N mod 4), T = 0, !, fail.
%иначе можем
move_to_cell(cell(X, Y, block4), _, X, Y).

%если наступили в портал, то надо изменить X, Y на координаты другого портала
move_to_cell(cell(X, Y, portal), _, I, J):-cell(I, J, portal), not(I=X), not(J=Y).

%если пустая клетка, то просто идём в нее
move_to_cell(cell(X, Y, empty), _, X, Y).
%если финашная клетка, то просто идём в нее
move_to_cell(cell(X, Y, finish), _, X, Y).

/*if_finish(finish):-
    создать path,
    выйти из while... .
    if_finish(_). % ниче не делаем*/

% проверяем можно ли пойти в X, Y
% и получаем новые координаты NX, NY (обычно равны X, Y если не портал)
check_move(X, Y, N, NX, NY):-
    cell(X, Y, Cell),
    move_to_cell(cell(X, Y, Cell), N, NX, NY), !. %move_to_cell(cell(2, 1, portal), 2, D, E)
% если check_move fails, то надо вернуть пустой список
check_move(_, _, _, -1, -1).

% если check_move fails, то надо вернуть пустой список NewField = []
check_field(-1, -1, _, _, []):-!.
% то же самое если уже есть знания в координате X, Y
% (уже найден такой же или более короткий путь в эту клетку)
check_field(X, Y, _, _, []):-
    field(X, Y, _, _), !.
% если же мы можем попасть X, Y и еще не были здесь,
% то добавляем новые знания вида field(X, Y, N, NewPath)
% также возвращаем NewField = [field(X, Y, N, NewPath)]
check_field(X, Y, N, PrevPath, NewField):-
    get_pole(Pole, X, Y, N),
    append(PrevPath, [Pole], NewPath),
    assert(field(X, Y, N, NewPath)),
    NewField = [field(X, Y, N, NewPath)].

% пытаемся переместиться
% если успешно, то NewField = [field(X, Y, N, Path)]
% иначе Field = []
try_to_move(X, Y, N, PrevPath, NewField):-
    % нельзя fail
    check_move(X, Y, N, NX, NY), 
    check_field(NX, NY, N, PrevPath, NewField).

% пытаемся переместиться
% если успешно, то Field = [field(X, Y, N, Path)]
% иначе Field = []
try_to_go_right(field(X, Y, N, Path), Field):-
    NN is N+1,
    NX is X+1,
    try_to_move(NX, Y, NN, Path, Field).

try_to_go_down(field(X, Y, N, Path), Field):-
    NN is N+1,
    NY is Y+1,
    try_to_move(X, NY, NN, Path, Field).

try_to_go_left(field(X, Y, N, Path), Field):-
    NN is N+1,
    NX is X-1,
    try_to_move(NX, Y, NN, Path, Field).

try_to_go_up(field(X, Y, N, Path), Field):-
    NN is N+1,
    NY is Y-1,
    try_to_move(X, NY, NN, Path, Field).

append5(L1, L2, L3, L4, L5, Res):-
    append(L1, L2, R12),
    append(R12, L3, R123),
    append(R123, L4, R1234),
    append(R1234, L5, Res).

% выходим из цикла если очередь пуста
while_queue_is_not_empty([]):-!. 
% иначе обрабатываем первый элемент в очереди:
% получаем новые знание вида field(X, Y, N, Path) и добавляем их в очердь.
while_queue_is_not_empty([H|T]):- 
    try_to_go_right(H, Right), 
    try_to_go_down(H, Down),
    try_to_go_left(H, Left),
    try_to_go_up(H, Up),
    append5(T, Right, Down, Left, Up, NewQueue),
    while_queue_is_not_empty(NewQueue).

% Алгоритм A*
azvezda():-
    %setup(), не нужно?
    setup_queue(Queue), % подготавливаем очередь
    while_queue_is_not_empty(Queue). %запускаем цикл пока очередь не опустеет

% Получаем кратчайший путь
get_min_path(Path):-
    azvezda(),
    cell(X, Y, finish),
    field(X, Y, _, Path),
    reset_fields().

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

/*get_blocks_old(N, Blocks):-	T4 is (N mod 4), T4 = 0, T2 is (N mod 2), T2 = 0,
						B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:0}, B4=json{x:3, y:3, n:0},
						Blocks = [B1, B2, B4], !.
get_blocks_old(N, Blocks):-	T2 is (N mod 2), T2 = 0, T4 is 4-(N mod 4),
						B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:0}, B4=json{x:3, y:3, n:T4},
						Blocks = [B1, B2, B4], !.
get_blocks_old(N, Blocks):-	T4 is 4-(N mod 4), T2 is 2-(N mod 2),
						B1=json{x:3, y:2, n:0}, B2=json{x:1, y:2, n:T2}, B4=json{x:3, y:3, n:T4},
						Blocks = [B1, B2, B4].
get_portals_old(Portals):-	P1 = json{x:2, y:1}, P2 = json{x:1, y:3}, Portals = [P1, P2].
get_finish_old(Finish):-	Finish = json{x:4, y:4}.
get_pole_old(Pole):-%Pole =json{empty:0}.
				pos(X, Y), turn(NN), N is NN-1,
				get_blocks_old(N, Blocks),
				get_portals_old(Portals),
				get_finish_old(Finish),
				Pole = json{player:json{x:X, y:Y}, walls:Blocks, portals:Portals, finish:Finish}.*/