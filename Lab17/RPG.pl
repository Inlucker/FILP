%character(Name, HP, Dmg, Armor)
player1(character("Player1", 5, 5, 0.5)).
player2(character("Player2", 5, 4, 0.6)).

%skill(Player, HP1, Dmg1, Armor1, Player2, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2).
skill1(Player1, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, HP1, Dmg1, Armor1, NewHP2, Dmg2, Armor2):-
    NewHP2 is HP2-Dmg1*(1-Armor2),
    format('~s uses HIT dealing ~3f damage\n', [Player1, Dmg1*(1-Armor2)]). %HIT

skill1(Player1, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, HP1, Dmg1, Armor1, NewHP2, Dmg2, NewArmor2):-
    SS = Armor1, NewArmor2 is Armor2-SS*0.5, NewHP2 is HP2-SS*(1-NewArmor2),
    format('~s uses SHIELD SLAM decreasing enemy Armor by ~3f and dealing ~3f dmg\n', [Player1, SS*0.5, SS*(1-NewArmor2)]). %ARMOR REDUCTION

skill2(Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, Dmg1, Armor1, HP2, Dmg2, Armor2):-
    NewHP1 is HP1-Dmg2*(1-Armor1),
    format('~s uses HIT dealing ~3f damage\n', [Player2, Dmg2*(1-Armor1)]). %HIT

skill2(Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, Dmg1, Armor1, NewHP2, Dmg2, Armor2):-
    LL = Dmg2*0.6*(1-Armor1), NewHP2 = HP2+LL, NewHP1= HP1-LL,
    format('~s uses LIFE LEACH for ~3f dmg\n', [Player2, LL]). %LIFE LEACH

winner(character(_, HP1, _, _), character(Player2, _, _, _), Winner, _):-(HP1 < 0 ; HP1 = 0), Winner = Player2, !,
    format('~s wins!!!!!!\n\n', [Player2]).
winner(character(Player1, _, _, _), character(_, HP2, _, _), Winner, _):-(HP2 < 0 ; HP2 = 0), Winner = Player1, !,
    format('~s wins!!!!!!\n\n', [Player1]).

winner(character(Player1, HP1, Dmg1, Armor1), character(Player2, HP2, Dmg2, Armor2), Winner, N):-
    format('Turn ~d\n', [N]),
	turn(Player1, Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, N),
    format('~s: HP=~3f; Dmg=~3f; Armor=~3f\n', [Player1, NewHP1, NewDmg1, NewArmor1]),
    format('~s: HP=~3f; Dmg=~3f; Armor=~3f.\n', [Player2, NewHP2, NewDmg2, NewArmor2]),
    NN is N+1,
	winner(character(Player1, NewHP1, NewDmg1, NewArmor1), character(Player2, NewHP2, NewDmg2, NewArmor2), Winner, NN).

%turn(Player1, Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2)
turn(Player1, _, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, N):-T is (N mod 2), T = 1,
    skill1(Player1, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2).
turn(_, Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2, N):-T is (N mod 2), T = 0,
    skill2(Player2, HP1, Dmg1, Armor1, HP2, Dmg2, Armor2, NewHP1, NewDmg1, NewArmor1, NewHP2, NewDmg2, NewArmor2).

example(Player1, Player2, Winner):-player1(Player1), player2(Player2), winner(Player1, Player2, Winner, 1).

%example(Player1, Player2, Winner).
%example(character("Player1", 5, 5, 0.5), Player2, "Player1")