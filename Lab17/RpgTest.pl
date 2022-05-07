%character(Name, HP, Dmg, Armor)
player1(character(Name, HP, Dmg, Armor)):-name1(Name), reset_hp1(HP), reset_dmg1(Dmg), reset_armor1(Armor).
name1(N):-N="Player1".

reset_hp1(HP):-HP=10, retractall(hp1(_)), asserta(hp1(HP)).
reset_dmg1(Dmg):-Dmg=3, retractall(dmg1(_)), asserta(dmg1(Dmg)).
reset_armor1(Armor):-Armor=0.7, retractall(armor1(_)), asserta(armor1(Armor)).

change_hp1(D):-hp1(HP), NewHP is HP+D, retractall(hp1(HP)), asserta(hp1(NewHP)).
change_dmg1(D):-dmg1(Dmg), NewDmg is Dmg+D, retractall(dmg1(Dmg)), asserta(dmg1(NewDmg)).
change_armor1(D):-armor1(Armor), NewArmor is Armor+D, retractall(armor1(Armor)), asserta(dmg1(NewArmor)).

player2(character(Name, HP, Dmg, Armor)):-name2(Name), reset_hp2(HP), reset_dmg2(Dmg), reset_armor2(Armor).
name2(N):-N="Player2".

reset_hp2(HP):-HP=10, retractall(hp2(_)), asserta(hp2(HP)).
reset_dmg2(Dmg):-Dmg=6, retractall(dmg2(_)), asserta(dmg2(Dmg)).
reset_armor2(Armor):-Armor=0.4, retractall(armor2(_)), asserta(armor2(Armor)).

change_hp2(D):-hp2(HP), NewHP is HP+D, retractall(hp2(HP)), asserta(hp2(NewHP)).
change_dmg2(D):-dmg2(Dmg), NewDmg is Dmg+D, retractall(dmg2(Dmg)), asserta(dmg2(NewDmg)).
change_armor2(D):-armor2(Armor), NewArmor is Armor+D, retractall(armor2(Armor)), asserta(armor2(NewArmor)).

%skill(Player, HP1, Dmg1, Armor1, Player2, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2).
skill1(Skill):-dmg1(Dmg1), armor2(Armor2), DHP = Dmg1*(1-Armor2), change_hp2(-DHP),
    name1(Player1), format('~s uses HIT dealing ~3f damage\n', [Player1, DHP]),
    Skill = "HIT1". %HIT

skill1(Skill):-armor1(Armor1), DA = Armor1*0.5, DHP = Armor1*(1-NewArmor2), change_armor2(-DA), armor2(NewArmor2), change_hp2(-DHP),
    name1(Player1), format('~s uses SHIELD SLAM decreasing enemy Armor by ~3f and dealing ~3f dmg\n', [Player1, DA, DHP]),
    Skill = "SHIELD SLAM1". %ARMOR REDUCTION

skill2(Skill):-dmg1(Dmg2), armor2(Armor1), DHP = Dmg2*(1-Armor1), change_hp1(-DHP),
    name2(Player2), format('~s uses HIT dealing ~3f damage\n', [Player2, DHP]),
    Skill = "HIT2". %HIT

skill2(Skill):-dmg2(Dmg2), armor1(Armor1), LL = Dmg2*0.6*(1-Armor1), change_hp1(-LL), change_hp2(LL),
    name2(Player2), format('~s uses LIFE LEACH for ~3f dmg\n', [Player2, LL]),
    Skill = "LIFE LEACH2". %LIFE LEACH

winner(Winner, _, WinStrat, WinStrat):-hp1(HP1), (HP1 = 0.0 ; HP1 < 0.0), !,
    name2(Player2), 
    %format('~s wins!!!!!!\n\n', [Player2]),
    Winner = Player2.
winner(Winner, _, WinStrat, WinStrat):-hp2(HP2), (HP2 = 0.0 ; HP2 < 0.0), !,
    name1(Player1),
    %format('~s wins!!!!!!\n\n', [Player1]),
    Winner = Player1.

winner(Winner, N, Strat, WinStrat):-
    %format('Turn ~d\n', [N]),
	turn(N, Skill),
    name1(Player1), hp1(NewHP1), dmg1(NewDmg1), armor1(NewArmor1),
    format('~s: HP=~3f; Dmg=~3f; Armor=~3f\n', [Player1, NewHP1, NewDmg1, NewArmor1]),
    name2(Player2), hp2(NewHP2), dmg2(NewDmg2), armor2(NewArmor2),
    format('~s: HP=~3f; Dmg=~3f; Armor=~3f.\n', [Player2, NewHP2, NewDmg2, NewArmor2]),
    NN is N+1, append(Strat, [Skill], NewStrat),
	winner(Winner, NN, NewStrat, WinStrat).

%turn(N, Skill)
turn(N, Skill):-T is (N mod 2), T = 1, skill1(Skill).
turn(N, Skill):-T is (N mod 2), T = 0, skill2(Skill).

%example(Winner):-player1(Player1), player2(Player2), winner(Player1, Player2, Winner, 1).
get_win_strategy(Winner, Strat):-player1(_), player2(_), winner(Winner, 1, [], Strat).

get_all_win_strats1(Strats, WinsCount):-
    name1(Winner), findall(WinStrat, get_win_strategy(Winner, WinStrat), Strats), length(Strats, WinsCount).
get_all_win_strats2(Strats, WinsCount):-
    name2(Winner), findall(WinStrat, get_win_strategy(Winner, WinStrat), Strats), length(Strats, WinsCount).

get_win_percentage(P1, P2):-get_all_win_strats1(_, WinsCount1), get_all_win_strats2(_, WinsCount2),
    P1 is WinsCount1/(WinsCount1+WinsCount2), P2 is WinsCount2/(WinsCount1+WinsCount2).

%example(Winner).
%name1(Winner), example(Winner).
%get_win_strategy(Winner, WinStrat).
%name1(Winner), get_win_strategy(Winner, WinStrat).
%name2(Winner), get_win_strategy(Winner, WinStrat).
%get_all_win_strats1(Strats1, WinsCount1).
%get_all_win_strats2(Strats2, WinsCount2).
%get_win_percentage(P1, P2).