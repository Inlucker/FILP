%Персонаж(Имя, Здоровье, Атака, Защита)
игрок1(персонаж("Player1", 100, 5, 0.5)).
игрок2(персонаж("Player2", 100, 4, 0.6)).

%навык(HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2).
навык(HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, HP1, Dmg1, Armor1, NewHP2, Dmg2, Armor2):-NewHP2 is HP2-Dmg1*(1-Armor2). %удар

победитель(персонаж(_, HP1, _, _), персонаж(Player2, _, _, _), Winner):-HP1<1, Winner = Player2, !.
победитель(персонаж(Player1, _, _, _), персонаж(_, HP2, _, _), Winner):-HP2<1, Winner = Player1, !.
%победитель(персонаж(Player1, HP1, Dmg1, Armor1), персонаж(Player2, HP2, Dmg2, Armor2), Winner):-
%	ход(Dmg1, HP2, Armor2, HP2new),
%	победитель(персонаж(Player2, HP2new, Dmg2, Armor2), персонаж(Player1, HP1, Dmg1, Armor1), Winner).
победитель(персонаж(Player1, HP1, Dmg1, Armor1), персонаж(Player2, HP2, Dmg2, Armor2), Winner):-
	ход(HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2),
    format('~s: HP=~f; ~s: HP=~f.\n', [Player1, NewHP1, Player2, NewHP2]),
	победитель(персонаж(Player2, NewHP2, NewDmg2, NewArmor2), персонаж(Player1, NewHP1, NewDmg1, NewArmor1), Winner).

%ход(Dmg1, HP2, Armor2, HP2new):-HP2new=HP2-Dmg1*(1-Armor2).
ход(HP1, Dmg1, Armor1, HP2, Dmg2, Armor2,
	NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2):-навык(HP1, Dmg1, Armor1, HP2, Dmg2, Armor2,
																NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2).

пример(Игрок1, Игрок2, Победитель):-игрок1(Игрок1), игрок2(Игрок2), победитель(Игрок1, Игрок2, Победитель).

%победитель("Player1", 100, 5, 0.5, "Player2", 100, 5, 0.5, Winner).
%победитель(персонаж("Player1", 100, 5, 0.5), персонаж("Player2", 100, 5, 0.5), Winner).
%пример(Игрок1, Игрок2, Победитель).
%ход(100, 5, 0.5, 100, 4, 0.6, Навык, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2)
%ход(100, 5, 0.5, 100, 4, 0.6, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2)