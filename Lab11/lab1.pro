domains
name, tel = string.

predicates
sprav(name, tel)

clauses
sprav("Arseny", "89167376051").
sprav("Arseny", "89167376052").
sprav("Artem", "89167376053").
sprav("Artem", "89167376054").
sprav("Ilya", "89167376055").
sprav("Ilya", "89167376056").
sprav("Andrey", "89167376057").
sprav("Andrey", "89167376058").

goal
%sprav("Arseny", "89167376052").
%sprav(X, "89167376053").		
sprav("Ilya", X).
