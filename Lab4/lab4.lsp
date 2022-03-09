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
(defun roll-dice()
	(print (cons (+ 1 (random 6))
				 (+ 1 (random 6)))))

(defun calc-sum(roll)
	(+ (car roll)(cdr roll)))
	
(defun check-win(sum)
	(or (= sum 7) (= sum 11)))

(defun check-reroll(roll)
	(or (equal roll '(1.1)) (equal roll '(6.6))))
	
(defun turn1
	(setq roll (roll-dice))
	(cond ((check-win roll)(print "Player1 won!"))
		  ((check-reroll roll)(turn1))
		  (T (calc-sum roll))))
		  
(defun turn2
	(setq roll (roll-dice))
	(cond ((check-win roll)(print "Player2 won!"))
		  ((check-reroll roll)(turn2))
		  (T (calc-sum roll)))) 

(defun dice-game()
	)