country(1, "Russia").
country(2, "USA").
country(3, "Ukraine").
country(3, "Ukraine2").

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

get_matches(CID, RES):-findall((T1ID, T2ID, WID, SID, CID, TID, DATE), match(T1ID, T2ID, WID, SID, CID, TID, DATE), RES).

team_winner(ID, NAME):-team(ID, _, _, NAME), match(_, _, ID, _, _, _, _).
team_winners(RES):-findall((ID, NAME), team_winner(ID, NAME), RES).

best_player(Nickname, Rating):-player(_, _, _, Nickname, _, _, _, _, Rating), Rating>=11000.
best_players(RES):-findall((N, R), best_player(N, R), RES).

year(Year) :-
    get_time(Stamp),
    stamp_date_time(Stamp, DateTime, local),
    date_time_value(year, DateTime, Year).

sum_r([], Sum0, Sum, _):- Sum = Sum0, !.
sum_r([H|T], Sum0, Sum, Y):-Sum1 is Sum0 + Y - H, sum_r(T, Sum1, Sum, Y).
sum(List, Sum):-year(Year), sum_r(List, 0, Sum, Year).

get_avgage(Role, Avg):-findall(Age, player(_, _, _, _, _, _, Age, Role, _), Res), sum(Res, Sum), proper_length(Res, Len), Avg is Sum/Len.
get_maxage(Role, Max):-findall(Age, player(_, _, _, _, _, _, Age, Role, _), Res), min_list(Res, MaxY), year(Y), Max is Y-MaxY.
get_minage(Role, Min):-findall(Age, player(_, _, _, _, _, _, Age, Role, _), Res), max_list(Res, MinY), year(Y), Min is Y-MinY.
get_age_stats(RES):-findall(("Midlaner", Avgage, Minage, Maxage), (get_avgage("Midlaner", Avgage),get_maxage("Midlaner", Maxage),get_minage("Midlaner", Minage)), R1),
    				findall(("Offlaner", Avgage, Minage, Maxage), (get_avgage("Offlaner", Avgage),get_maxage("Offlaner", Maxage),get_minage("Offlaner", Minage)), R2),
    				append(R1, R2, RES).

%get_matches(2, MATCHES)
%team_winners(TEAMS)
%best_players(PLAYERS)
%get_age_stats(STATS)