%character(Name, HP, Dmg, Armor)
player1(character(N, 5, 2.5, 0.75)):-name1(N).
player2(character(N, 5, 6, 0.4)):-name2(N).
name1(N):-N="Player1".
name2(N):-N="Player2".

%skill(Player, HP1, Dmg1, Armor1, Player2, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2).
skill1(Player1, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, HP1, Dmg1, Armor1, NewHP2, Dmg2, Armor2, Skill):-
    NewHP2 is HP2-Dmg1*(1-Armor2),
    %format('~s uses HIT dealing ~3f damage\n', [Player1, Dmg1*(1-Armor2)]),
    Skill = "HIT1". %HIT

skill1(Player1, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, HP1, Dmg1, Armor1, NewHP2, Dmg2, NewArmor2, Skill):-
    SS = Armor1, NewArmor2 is Armor2-SS*0.5, NewHP2 is HP2-SS*(1-NewArmor2),
    %format('~s uses SHIELD SLAM decreasing enemy Armor by ~3f and dealing ~3f dmg\n', [Player1, SS*0.5, SS*(1-NewArmor2)]),
    Skill = "SHIELD SLAM1". %ARMOR REDUCTION

skill2(Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, Dmg1, Armor1, HP2, Dmg2, Armor2, Skill):-
    NewHP1 is HP1-Dmg2*(1-Armor1),
    %format('~s uses HIT dealing ~3f damage\n', [Player2, Dmg2*(1-Armor1)]),
    Skill = "HIT2". %HIT

skill2(Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, Dmg1, Armor1, NewHP2, Dmg2, Armor2, Skill):-
    LL = Dmg2*0.6*(1-Armor1), NewHP2 = HP2+LL, NewHP1= HP1-LL,
    %format('~s uses LIFE LEACH for ~3f dmg\n', [Player2, LL]),
    Skill = "LIFE LEACH2". %LIFE LEACH

winner(character(_, HP1, _, _), character(Player2, _, _, _), Winner, _, WinStrat, WinStrat):-
    (HP1 < 0 ; HP1 = 0), !,
    %format('~s wins!!!!!!\n\n', [Player2]),
    Winner = Player2.
winner(character(Player1, _, _, _), character(_, HP2, _, _), Winner, _, WinStrat, WinStrat):-
    (HP2 < 0 ; HP2 = 0), !,
    %format('~s wins!!!!!!\n\n', [Player1]),
    Winner = Player1.

winner(character(Player1, HP1, Dmg1, Armor1), character(Player2, HP2, Dmg2, Armor2), Winner, N, Strat, WinStrat):-
    %format('Turn ~d\n', [N]),
	turn(Player1, Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, N, Turn),
    %format('~s: HP=~3f; Dmg=~3f; Armor=~3f\n', [Player1, NewHP1, NewDmg1, NewArmor1]),
    %format('~s: HP=~3f; Dmg=~3f; Armor=~3f.\n', [Player2, NewHP2, NewDmg2, NewArmor2]),
    NN is N+1, append(Strat, [Turn], NewStrat),
	winner(character(Player1, NewHP1, NewDmg1, NewArmor1), character(Player2, NewHP2, NewDmg2, NewArmor2), Winner, NN, NewStrat, WinStrat).

%turn(Player1, Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2)
turn(Player1, _, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, N, Turn):-T is (N mod 2), T = 1,
    skill1(Player1, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, Turn).
turn(_, Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, N, Turn):-T is (N mod 2), T = 0,
    skill2(Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, Turn).

%example(Winner):-player1(Player1), player2(Player2), winner(Player1, Player2, Winner, 1).
get_win_strategy(Winner, Strat):-player1(Player1), player2(Player2), winner(Player1, Player2, Winner, 1, [], Strat).

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