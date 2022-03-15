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
(defun roll(n)
	(let ((d1 (+ 1 (random 6))) (d2 (+ 1 (random 6))))
		 (format t "Player~A rolled ~A+~A=~A~%" n d1 d2 (+ d1 d2))
		 (+ d1 d2)))
	
(defun check_win(sum)
	(or (= sum 7) (= sum 11)))
	
(defun check_reroll(sum)
	(or (= sum 2) (= sum 12)))

(defun turn(n)
	(let ((sum (roll n)))
		(cond ((check_win sum) nil)
			  ((check_reroll sum) (turn n))
			  (T sum))))

(defun dice_game()
	(cond ((not (setf p1 (turn 1))) (print '(Player1 won!)))
		  ((not (setf p2 (turn 2))) (print '(Player2 won!)))
		  (T (cond ((> p1 p2) (print '(Player1 won!)))
				   ((< p1 p2) (print '(Player2 won!)))
				   (T (print 'Tie!))))))
	