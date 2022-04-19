domains
city, street = string
house, flat = integer
adress = adr(city, street, house, flat)
surname, tel = string
university = string
brand, color = string
price = integer
bank, account = string
amount = integer
building, area, water_vehicle = string
property = car(brand, color, price); build(building, price);  ar(area, price); wv(water_vehicle, price)

name = string
sex = m; f
human = h(name, sex)

predicates
student_tel(surname, tel)
university(surname, university)
un_sprav(university, tel)
student_adress(surname, adress)
tel_sprav(surname, tel, adress)
car(surname, brand, color, price)
bank_depositor(surname, bank, account, amount)
car_by_tel(tel, surname, brand, price)
brand_by_tel(tel, brand)
person_by_city(surname, city, street, bank, tel)
person_by_car(brand, color, surname, city, tel, bank)
property(surname, property)
props_names(surname, string)
props_names_prices(surname, string, integer)
prop_price(surname, symbol, price)
props_total_price(surname, price)

parent(human, human)
grandparent(human, name, sex)

clauses
student_tel("Pronin", "89167376051").
student_tel("Pronin", "89167376052").
student_tel("Lisnevsky", "89167376053").
student_tel("Lisnevsky", "89167376054").
student_tel("Klimov", "89167376055").
student_tel("Klimov", "89167376056").
student_tel("Alahov", "89167376057").
student_tel("Alahov", "89167376058").
student_tel("Trunov", "89167376050").
student_tel("Trunov", "89167376059").
university("Pronin", "BMSTU").
university("Trunov", "BMSTU").
university("Klimov", "HSE").
university("Lisnevsky", "MIRAEA").
university("Alahov", "MIPT").
un_sprav(U, T):-student_tel(S, T),university(S, U).
student_adress("Pronin", adr("Moscow", "Tverskaya", 1, 1)).
student_adress("Lisnevsky", adr("Moscow", "Tverskaya", 1, 2)).
student_adress("Klimov", adr("Moscow", "Tverskaya", 1, 3)).
student_adress("Alahov", adr("Moscow", "Tverskaya", 1, 4)).
student_adress("Trunov", adr("Moscow", "Tverskaya", 1, 5)).
tel_sprav(S, T, A):-student_tel(S, T),student_adress(S, A).
car("Pronin", "Audi", "Black", 2000000).
%car("Pronin", "BMW", "White", 2000000).
%car("Pronin", "Ford", "Gray", 2000000).
car("Lisnevsky", "BMW", "Green", 3000000).
car("Klimov", "Ford", "Blue", 4000000).
car("Alahov", "BMW", "Red", 5000000).
car("Trunov", "Audi", "Violet", 7000000).
%car("Pronin", "Audi", "Violet", 7000000).
bank_depositor("Pronin", "SberBank", "40817810099910004312", 7000000).
bank_depositor("Lisnevsky", "SberBank", "40817810099910004313", 4000000).
bank_depositor("Klimov", "VTB", "40817810099910004314", 5000000).
bank_depositor("Alahov", "VTB", "40817810099910004315", 6000000).
bank_depositor("Trunov", "RosBank", "40817810099910004316", 7000000).
bank_depositor("Trunov", "SberBank", "40817810099910004317", 7000000).
bank_depositor("Trunov", "VTB", "40817810099910004318", 8000000).
car_by_tel(T, S, B, P):-student_tel(S, T),car(S, B, _, P).
brand_by_tel(T, B):-car_by_tel(T, _, B, _).
person_by_city(S, C, St, B, T):-tel_sprav(S, T, adr(C, St, _, _)),bank_depositor(S, B, _, _).
person_by_car(Br, Col, S, City, T, Bank):-car(S, Br, Col, _),tel_sprav(S, T, adr(City, _, _, _)),bank_depositor(S, Bank, _, _).
property(S, car(B, C, P)):-car(S, B, C, P).
property("Pronin", build("Kremlin", 700)).
property("Pronin", ar("Russia", 80)).
property("Pronin", wv("Titanic", 9)).
property("Ilya", build("Mausoleum", 666)).
props_names(S, N):-property(S, car(N, _, _)); property(S, build(N, _)); property(S, ar(N, _)); property(S, wv(N, _)).
props_names_prices(S, N, P):-property(S, car(N, _, P)); property(S, build(N, P)); property(S, ar(N, P)); property(S, wv(N, P)).
prop_price(S, building, P) :- property(S,  build(_, P)), !.
prop_price(S, area, P) :- property(S,  ar(_, P)), !.
prop_price(S, water_vehicle, P) :- property(S,  wv(_, P)), !.	
prop_price(S, car, P) :- property(S,  car(_, _, P)), !.
prop_price(_, _, 0).
props_total_price(S, SUM):-prop_price(S, building, P1),
			   prop_price(S, area, P2),
			   prop_price(S, water_vehicle, P3),
			   prop_price(S, car, P4),
			   SUM = P1+P2+P3+P4.

parent(h("Sergey", m), h("Arseny", f)).
parent(h("Natalia", f), h("Arseny", f)).
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
