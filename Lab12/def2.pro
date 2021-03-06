domains
state = crazy; normal.

predicates
pos_state(state)
gen_gip(state, state)
thinks(state, state, state)
thinks2(state, state, state)

clauses
pos_state(crazy).
pos_state(normal).

thinks(S1, S2, S):-S1=normal, S2=S; S1=crazy, not(S2=S).
thinks2(S1, S2, S):-S1=normal, thinks(S2, S1, S); S1=crazy, not(thinks(S2, S1, S)).

gen_gip(S1, S2):-pos_state(S1), pos_state(S2).

goal
%thinks(crazy, normal, crazy).
gen_gip(King, Queen), thinks2(King, Queen, crazy).