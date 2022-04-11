domains
name, tel, university = string.

predicates
sprav(name, tel)
university(name, university)
un_sprav(university, tel)

clauses
sprav("Arseny", "89167376051").
sprav("Arseny", "89167376052").
sprav("Artem", "89167376053").
sprav("Artem", "89167376054").
sprav("Ilya", "89167376055").
sprav("Ilya", "89167376056").
sprav("Andrey", "89167376057").
sprav("Andrey", "89167376058").
sprav("Artemy", "89167376050").
sprav("Artemy", "89167376059").

university("Arseny", "BMSTU").
university("Artemy", "BMSTU").
university("Ilya", "HSE").
university("Artem", "MIRAEA").
university("Andrey", "MIPT").

un_sprav(U, T):-sprav(S, T),university(S, U).

goal
%university("Ilya", "BMSTU").
%university(X, "BMSTU").
un_sprav("BMSTU", X).
%un_sprav(X, "89167376059").