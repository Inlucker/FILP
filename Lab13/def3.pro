domains
id, int = integer
text, date = string

predicates
country(id, text)
sponsor(id, id, text)
team(id, id, id, text)
player(id, id, id, text, text, text, int, text, int)
studio(id, id, text)
commentator(id, id, id, text, text, text, int, int)
tournament(id, id, text, int)
match(id, id, id, id, id, id, date)
team_winner(id, text)
best_players(text, int)
%get_age_stats(text, int, int, int)

clauses
country(1, "Russia").
country(2, "USA").
country(3, "Ukraine").

sponsor(1, 1, "GGBet").
sponsor(2, 2, "Red Bull").
sponsor(3, 2, "Coca-cola").

team(1, 1, 1, "Virtus Pro").
team(2, 2, 2, "Evil Geniuses").
team(3, 3, 3, "Natus Vincere").

player(1, 1, 1, "GPK", "Danil", "Skutin", 2001, "Midlaner", 12000).
player(2, 2, 1, "Nightfall", "Egor", "Grigorenko", 2002, "Offlaner", 11000).
player(3, 3, 3, "Noone", "Vladimir", "Minenko", 1997, "Midlaner", 10000).

studio(1, 1, "RuHub").
studio(2, 2, "Beyond the Summit").
studio(3, 3, "Maincast").

commentator(1, 1, 1, "4ce", "Dmitriy", "Filinov", 1991, 10000).
commentator(2, 2, 2, "Forsaken Oracle", "Kyle", "Freedman", 1993, 11000).
commentator(3, 3, 3, "ALWAYSWANNAFLY", "Andrey", "Bondarenko", 1991, 12000).

tournament(1, 2, "The Inernational 2021", 40018195).

match(1, 2, 1, 1, 1, 1, "2021-11-07").
match(2, 3, 2, 2, 2, 1, "2021-11-08").
match(3, 1, 3, 3, 3, 1, "2021-11-09").

team_winner(ID, NAME):-team(ID, _, _, NAME), match(_, _, ID, _, _, _, _).
best_players(Nickname, Rating):-player(_, _, _, Nickname, _, _, _, _, Rating), Rating>11000.

goal
%match(T1ID, T2ID, WID, SID, 2, TID, DATE). 
%findall((T1ID, T2ID, WID, SID, 2, TID, DATE), match(T1ID, T2ID, WID, SID, 2, TID, DATE), L)

%team_winner(ID, NAME).
%findall((ID, NAME), team_winner(ID, NAME), L)

best_players(N, R).
%findall((N, R), best_players(N, R), L)