;1
(defun f1(lst)
	(mapcar #'(lambda (x)
				(if (numberp x)
					(- x 10)
					x)) lst))
					
(f1 '(1 2 3 4 d c))
	
;2 
;numbers
(defun mul-lst1(n lst)
	(mapcar #'(lambda (x) (* x n)) lst))
	
;numbers
(defun mul-lst2(n lst)
	(mapcar #'(lambda (x)
				(if (numberp x)
					(* x n)
					x)) lst))
					
(mul-lst1 2 '(1 2 3))
(mul-lst2 2 '(1 2 3 d c))
				
;3	
(defun my-reverse (lst)
	(let ((res nil))
		 (mapcar #'(lambda (el)
						(setf res (cons el res))) lst)
		 res))

(defun is-palindrom (lst)
	(equal lst (my-reverse lst)))
	
(is-palindrom '(a b c))
(is-palindrom '(a b a))

;4
(defun set1-in-set2 (set1 set2)
		(if (member NIL
				(mapcar #'(lambda (el)
								(if (member el set2) T))
						set1))
			NIL
			T))

(defun set-equal(set1 set2)
	(and (set1-in-set2 set1 set2)
		 (set1-in-set2 set2 set1)))

(setf s1 '(a b c))
(setf s2 '(c a b))
(setf s3 '(c a d))
(set-equal s1 s2)
(set-equal s1 s3)

;5
(defun get-squares(lst)
	(mapcar #'(lambda (el) (* el el)) lst))

(get-squares '(1 2 3))

;6 
(defun select-between(lst a b)
	(sort
	(mapcan #'(lambda (el)
					(cond ((or (<= a el b) (<= b el a)) `(,el))
						   (T NIL))) lst) #'<))
	
(setf lst '(5 4 3 2 1))
(select-between lst 2 4)
(select-between lst 3 1)

;7
(defun decart (lstX lstY)
    (mapcan #'(lambda (x)
                    (mapcar #'(lambda (y)
                                (list x y)) lstY))
                                            lstX))
                                                
(decart '(a b) '(1 2))

;8
(reduce #'+ '(0)) == (+ 0) => 0
(reduce #'+ ()) == (+) => 0

;9
(defun get-len(lst)
	(apply #'+ (mapcar #'length lst)))
	
(setf lol '((1 2)(3 4)))
(get-len lol)
