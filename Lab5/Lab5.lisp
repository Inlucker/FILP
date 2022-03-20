;1
(defun is-palindrom (lst)
	(equal lst (reverse lst)))

(defun move-to (lst result)
    (cond ((null lst) result)
          (T (move-to (cdr lst) (cons (car lst) result)))))
          
(defun my-reverse (lst)
    (move-to lst ()))

(defun is-palindrom2 (lst)
	(equal lst (my-reverse lst)))
	
;2
(defun set1-in-set2-r (set1 set2 res)
	(cond ((null set1) T)
		  ((member (car set1) set2)
		   (set1-in-set2-r (cdr set1) set2 res))
		  (T NIL)))

(defun set1-in-set2 (set1 set2)
	(set1-in-set2-r set1 set2 T))

(defun set-equal(set1 set2)
	(and (set1-in-set2 set1 set2)
		 (set1-in-set2 set2 set1)))

(setf s1 '(a b c))
(setf s2 '(c a b))
(setf s3 '(c a d))
(set-equal s1 s2)
(set-equal s1 s3)
 
;3				   
(setf t1 '((Russia . Moscow)
		   (Ukraine . Kiev)
		   (USA . Washington)
		   (England . England)))

(defun get-cap (tab coun)
	(cond ((null tab) NIL)
		  ((eql (caar tab) coun) (cdar tab))
		  (T (get-cap (cdr tab) coun))))
		  
(defun get-coun (tab cap)
	(cond ((null tab) NIL)
		  ((eql (cdar tab) cap) (caar tab))
		  (T (get-coun (cdr tab) cap))))
		  
(get-cap t1 'Russia)
(get-coun t1 'Moscow)
	
;4
(defun without-last-r(lst res)
	(cond ((null (cdr lst)) res)
          (T (without-last-r (cdr lst)
						     (append res `(,(car lst)))))))

(defun without-last(lst)
	(without-last-r lst ()))

(defun swap-first-last(lst)
	(cond ((or (null lst) (null (cdr lst))) lst)
		  (T (append (last lst)
					 (without-last (cdr lst))
					 `(,(car lst))))))

(swap-first-last '())
(swap-first-last '(1))
(swap-first-last '(1 2))
(swap-first-last '(1 2 3))

;5
(defun swap-two-ellement(lst n1 n2)
	(let ((tmp (nth n2 lst)))
		 (setf (nth n2 lst) (nth n1 lst))
		 (setf (nth n1 lst) tmp)
		 lst))
		 
;6
(defun move-left(lst tmp)
	(cond ((null (cdr lst)) (setf (car lst) tmp))
		  (T (setf (car lst) (second lst))
			  (move-left (cdr lst) tmp))))

(defun swap-to-left(lst)
	(cond ((or (null lst) (null (cdr lst))) lst)
		  (T (let ((tmp (first lst)))
				  (move-left lst tmp)
				  lst))))

(defun move-right(lst tmp2)
	(cond ((null lst) nil)
		  (T (let ((tmp3 (car lst)))
				  (setf (car lst) tmp2)
				  (move-right (cdr lst) tmp3)))))

(defun swap-to-right(lst)
	(cond ((or (null lst) (null (cdr lst))) lst)
		  (T (let ((tmp (car (last lst))))
				  (move-right lst (car lst))
				  (setf (car lst) tmp)
				  lst))))

(setf lst '(a b c d))
(swap-to-left lst)
(swap-to-right lst)

;7
(defun add-to-set(set1 el)
	(if (member el set1 :test #'equal)
		set1
		(nconc set1 (list el))))

(setf s1 '((a b) (c d)))
(add-to-set s1 '(f g))

;8 
;numbers
(defun f81(n lst)
	(setf (car lst) (* (car lst) n))
	lst)
	
;objects
(defun f82(n lst)
	(if (member T (mapcar #'numberp lst))
		(let ((i (- (length lst)(length (member T (mapcar #'numberp lst))))))
			 (setf (nth i lst) (* (nth i lst) n))
			 lst)))
		
(setf lst '(1 2 3))
(f81 7 lst)

(setf lst '(1 2 3))
(f82 7 lst)
(setf lst '(a 2 c))
(f82 7 lst)
(setf lst '(a b c))
(f82 7 lst)

;9
(defun is-between(el a b)
	(if (< a b)
		(<= a el b)
		(<= b el a)))

(defun f9(lst a b res)
	(cond ((null lst) res)
		  ((is-between (car lst) a b) (f9 (cdr lst) a b (append res `(,(car lst)))))
		  (T (f9 (cdr lst) a b res))))
;С lambda 
(defun s-b-r(lst a b res)
	(cond ((null lst) res)
		  (((lambda (el)
					(if (< a b)
						(<= a el b)
						(<= b el a)))
			(car lst))
		   (s-b-r (cdr lst) a b (append res `(,(car lst)))))
		  (T (s-b-r (cdr lst) a b res))))

(defun select-between(lst a b)
	(sort (s-b-r lst a b ()) #'<))
	
(setf lst '(5 4 3 2 1))
(select-between lst 2 4)
(select-between lst 4 2)

;Тест lambda
((lambda (x) (+ x 2)) 3)

;Тест mapcar и apply
(setf m '((1 2 3)(4 5 6)(7 8 9)))
(apply #'mapcar #'list m)
; = ((1 4 7) (2 5 8) (3 6 9))
(apply #'mapcar #'+ m)

;Диаграмма
(apply #'mapcar #'list m)

; m = ((1 2 3)(4 5 6)(7 8 9))
; (apply #'mapcar #'list m)
; Применить MAPCAR к ((1 2 3)(4 5 6)(7 8 9))
; Применить list c параметрами 1 4 7, 2 5 8 и 3 6 9
; и объеденить результаты list'ом =
; = (list (list 1 4 7) (list 2 5 8) (list 3 6 9))
; = ((1 4 7) (2 5 8) (3 6 9))
(mapcar #'list '(1 2 3) '(4 5 6) '(7 8 9))


(mapcar #'list '((1 2 3)(4 5 6)(7 8 9)))
(apply #'+ '(1 2 3))

(apply #'mapcar #'list '((1 2 3)))
(apply #'mapcar #'+ '((1 2 3)(4 5)(6)))

(defun f1(x) (+ x))
(defun f2(x y) (+ x y))
(defun f3(x y z) (+ x y z))
(mapcar #'f1 '(1 2 3))
(mapcar #'f2 '(1 2 3) '(3 4 5))
(mapcar #'f3 '(1 2 3) '(3 4 5) '(6 7 8))