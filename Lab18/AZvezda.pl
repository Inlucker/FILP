%Azvezda prolog

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

azvezda():-
    %setup(), не нужно?
    setup_queue(Queue), % подготавливаем очередь
    while_queue_is_not_empty(Queue). %запускаем цикл пока очередь не опустеет
    %Нужно сохрнаить здесь результат
    %reset_fields().

get_min_path(Path):-
    azvezda(),
    cell(X, Y, finish),
    field(X, Y, _, Path).

/* Для дебага */

starting_pos(0, 0).

cell(0, 0, empty).
cell(1, 0, empty).

cell(0, 1, finish).
cell(1, 1, empty).


/*
starting_pos(0, 1).

cell(0, 0, empty).
cell(1, 0, empty).
cell(2, 0, empty).
cell(3, 0, empty).
cell(4, 0, empty).

cell(0, 1, empty).
cell(1, 1, empty).
cell(2, 1, portal).
cell(3, 1, empty).
cell(4, 1, empty).

cell(0, 2, empty).
cell(1, 2, block2).
cell(2, 2, empty).
cell(3, 2, block1).
cell(4, 2, empty).

cell(0, 3, empty).
cell(1, 3, portal).
cell(2, 3, empty).
cell(3, 3, block4).
cell(4, 3, empty).

cell(0, 4, empty).
cell(1, 4, empty).
cell(2, 4, empty).
cell(3, 4, empty).
cell(4, 4, finish).
*/

