;1
(defun move-to (lst result)
    (cond ((null lst) result)
          (T (move-to (cdr lst) (cons (car lst) result)))))
          
(defun my-reverse (lst)
    (move-to lst ()))
	
;3
(defun get-first-lst(lst)
	(cond ((null lst) NIL)
		  ((and (listp (car lst)) (not (null (car lst))))
		   (car lst))
		  (T (get-first-lst (cdr lst)))))

;7
;numbers
(defun mul1(n lst)
	(cond ((null lst) NIL)
		  (T (setf (car lst) (* n (car lst)))
			 (mul1 n (cdr lst))))
	lst)

;objects
(defun mul2(n lst)
	(cond ((null lst) NIL)
		  ((numberp (car lst))
		   (setf (car lst) (* n (car lst)))
		   (mul2 n (cdr lst)))
		  (T (mul2 n (cdr lst))))
	lst)

(setf lst '(1 2 3 4 5))
(mul1 2 lst)

(setf lst '(1 2 3 4 5))
(mul2 2 lst)
(setf lst '(1 a b c 5))
(mul2 2 lst)
(setf lst '(a b c d e))
(mul2 2 lst)

;81
(defun s-b-r(lst a b res)
	(cond ((null lst) res)
		  (((lambda (el)
					(if (< a b)
						(<= a el b)
						(<= b el a)))
			(car lst))
		   (s-b-r (cdr lst) a b (cons (car lst) res)))
		  (T (s-b-r (cdr lst) a b res))))

(defun select-between(lst a b)
	(sort (s-b-r lst a b ()) #'<))
	
(setf lst '(5 4 3 2 1 6 7 8 9 10))
(select-between lst 2 4)
(select-between lst 9 7)

;4
(defun between-1-10(lst)
	(select-between lst 1 10))
	
(setf lst '(50 4 30 2 10 6 70 8 90 10))
(between-1-10 lst)

;82
(defun rec-add1-r(lst res)
	(cond ((null lst) res)
		  ((numberp (car lst))
		   (rec-add1-r (cdr lst) (+ res (car lst))))
		  (T (rec-add1-r (cdr lst) res))))

(defun rec-add1(lst)
	(rec-add1-r lst 0))

(defun rec-add2-r(lst res)
	(cond ((null lst) res)
		  ((numberp (car lst))
		   (rec-add2-r (cdr lst) (+ res (car lst))))
		  ((and (listp (car lst)) (not (null lst)))
		   (rec-add2-r (cdr lst)
					   (rec-add2-r (car lst) res)))))
		   
(defun rec-add2(lst)
	(rec-add2-r lst 0))

(setf lst '(a 1 b 1 c 1 d 1 e 1))
(rec-add1 lst)

(setf lst '((1 1 (1 (1 1))) 1 1 ((1) 1) 1))
(rec-add2 lst)

;9
(defun recnth(n lst)
	(cond ((= n 0) (car lst))
		  (T (recnth (- n 1) (cdr lst)))))
		  
;10
(defun my-oddp(x)
	(if (= (rem x 2) 1)
		T))

(defun allodd(lst)
	(cond ((null lst) T)
		  ((my-oddp (car lst)) (allodd (cdr lst)))
		  (T NIL)))
		  
(allodd '(1 3 5))
(allodd '(1 2 3 4 5))

;11
(defun get-odd(lst)
	;(print lst)
	(cond ((null lst) NIL)
		  ((and (numberp (car lst)) (my-oddp (car lst)))
		   (car lst))
		  ((and (listp (car lst)) (not (null lst)))
		   (or (get-odd (car lst)) (get-odd (cdr lst))))
		  (T (get-odd (cdr lst)))))

(setf lst '((a b (c (ddd d))) c d 3))
(get-odd lst)

;12
(defun get-squares-r(lst res)
	(cond ((null lst) res)
		  (T (get-squares-r (cdr lst)
					(cons (* (car lst) (car lst)) res)))))
(defun get-squares(lst)
	(my-reverse (get-squares-r lst NIL)))
	
(get-squares '(1 2 3 4 5))