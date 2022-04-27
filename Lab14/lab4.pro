domains
name = string
sex = m; f
human = h(name, sex)

predicates
parent(human, human)
grandparent(human, name, sex)

clauses
parent(h("Sergey", m), h("Arseny", m)).
parent(h("Natalia", f), h("Arseny", m)).
parent(h("Mihail", m), h("Sergey", m)).
parent(h("Mura", f), h("Sergey", m)).
parent(h("Leonid", m), h("Natalia", f)).
parent(h("Maria", f), h("Natalia", f)).
grandparent(h(GN, GS), N, PS):-parent(h(PN, PS), h(N, _)), parent(h(GN, GS), h(PN, PS)).

goal
%grandparent(h(N, f), "Arseny", _). %1
%grandparent(h(N, m), "Arseny", _). %2
%grandparent(h(N, _), "Arseny", _). %3
%grandparent(h(N, f), "Arseny", f). %4
grandparent(h(N, _), "Arseny", f). %5
