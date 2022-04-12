domains
city, street = string.
house, flat = integer.
adress = adr(city, street, house, flat)
surname, tel = string.
university = string.
brand, color = string.
price = integer.
bank, account = string.
amount = integer.

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
car("Pronin", "BMW", "White", 2000000).
car("Pronin", "Ford", "Gray", 2000000).
car("Lisnevsky", "BMW", "Green", 3000000).
car("Klimov", "Ford", "Blue", 4000000).
car("Alahov", "BMW", "Red", 5000000).
car("Trunov", "Audi", "Violet", 7000000).
car("Pronin", "Audi", "Violet", 7000000).
bank_depositor("Pronin", "SberBank", "40817810099910004312", 7000000).
bank_depositor("Lisnevsky", "SberBank", "40817810099910004313", 4000000).
bank_depositor("Klimov", "VTB", "40817810099910004314", 5000000).
bank_depositor("Alahov", "VTB", "40817810099910004315", 6000000).
bank_depositor("Trunov", "RosBank", "40817810099910004316", 7000000).
bank_depositor("Trunov", "SberBank", "40817810099910004317", 7000000).
bank_depositor("Trunov", "VTB", "40817810099910004318", 7000000).
car_by_tel(T, S, B, P):-student_tel(S, T),car(S, B, _, P).
brand_by_tel(T, B):-car_by_tel(T, _, B, _).
person_by_city(S, C, St, B, T):-tel_sprav(S, T, adr(C, St, _, _)),
								bank_depositor(S, B, _, _).

person_by_car(Br, Col, S, City, T, Bank):-car(S, Br, Col, _),
										  tel_sprav(S, T, adr(City, _, _, _)),
										  bank_depositor(S, Bank, _, _).

goal
%PART 1
%tel_sprav("Pronin", "89167376051", adr("Moscow", "Tverskaya", 1, 1)).
%tel_sprav(X, Y, adr("Moscow", "Tverskaya", 1, Z)).
%car("Pronin", X, Y, Z).
%bank_depositor("Trunov", X, Y, Z).
%car_by_tel("89167376051", X, Y, Z). %1a
%brand_by_tel("89167376051", X). %1b
%person_by_city("Pronin", "Moscow", X, Y, Z). %2

%PART 2
%person_by_car("Audi", "Violet", Surname, City, Telephone, Bank). %several owners
%person_by_car("Audi", "Black", Surname, City, Telephone, Bank). %one owner
person_by_car("Audi", "Green", Surname, City, Telephone, Bank). %no owners