;Task1
(cons lst1 lst2)
((A B) C D)

(list lst1 lst2)
((A B) (C D))

(append lst1 lst2)
(A B C D)

;Task2
(reverse ())
NIL

(last ())
NIL

(reverse '(a))
(A)

(last '(a))
(A)

(reverse '((a b c)))
((A B C))

(last '((a b c)))
((A B C))

;Task3
(defun last1(lst)
	(if (null (cdr lst))
		(car lst)
		(last1 (cdr lst))))
		
(defun last2(lst)
	(car (reverse lst)))
	
;Task4
(defun f1(lst)
	(reverse (cdr (reverse lst))))
	
(defun f2(lst)
	(if (null (cdr lst))
		NIL
		(cons (car lst) (f2 (cdr lst)))))
		
;Task5
(defun dice_roll()
	(print (cons (+ 1 (random 6))
				 (+ 1 (random 6)))))

(defun dice_game()
	)