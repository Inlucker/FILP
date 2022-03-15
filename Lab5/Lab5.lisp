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
(defun f2 (set1 set2 res)
	(cond ((null set1) T)
		  ((member (car set1) set2) (f2 (cdr set1) set2 res))
		  (T NIL)))

(defun set1-in-set2 (set1 set2)
	(f2 set1 set2 T))

(defun set-equal(set1 set2)
	(and (set1-in-set2 set1 set2)
		 (set1-in-set2 set2 set1)))
		 
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
	
;4lst	
(defun f4(lst res)
	(cond ((null (cdr lst)) res)
          (T (f4 (cdr lst)(append res `(,(car lst)))))))

(defun without-last(lst)
	(f4 lst ()))

(defun swap-first-last(lst)
	(cond ((or (null lst) (null (cdr lst))) lst)
		  (T (append (last lst)
					 (without-last (cdr lst))
					 `(,(car lst))))))

;5
(defun swap-two-ellement(lst n1 n2)
	(let ((tmp (nth n2 lst)))
		 (setf (nth n2 lst) (nth n1 lst))
		 (setf (nth n1 lst) tmp)
		 lst))
		 
;6
(setf lst '(a b c d))

(defun move-left(lst tmp)
	(cond ((null (cdr lst)) (setf (car lst) tmp))
		  (T (setf (car lst) (second lst))
			  (move-left (cdr lst) tmp))))

(defun swap-to-left(lst)
	(cond ((or (null lst) (null (cdr lst))) lst)
		  (T (let ((tmp (first lst)))
				  (move-left lst tmp)
				  lst))))

(swap-to-left lst)

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

(swap-to-right lst)

;7
(setf s1 '((a b) (c d)))

(defun add-to-set(set1 el)
	(if (member el set1 :test #'equal)
		set1
		(nconc set1 (list el))))

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
(defun f9(lst a b res)
	(cond ((null lst) res)
		  (((lambda (el)
					(if (< a b)
						(<= a el b)
						(<= a el b)))
			(car lst)) (f9 (cdr lst) a b (append res `(,(car lst)))))
		  (T (f9 (cdr lst) a b res))))

(defun select-between(lst a b)
	(sort (f9 lst a b ()) #'<))
	
(setf lst '(5 4 3 2 1))
(select-between lst 2 4)

;Тест lambda
((lambda (x) (+ x 2)) 3)
	