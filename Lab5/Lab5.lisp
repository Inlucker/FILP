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
(apply #'map 'list #'list m)
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

;Не нужно
(defun swap-to-right (lst &optional (res NIL))
	(print lst)
	(cond ((null (cdr lst)) res)
		  (T (cons (car lst) (swap-to-right (cdr lst) res)))))

(defun butfirst (lst &optional (n 1))
	(cond ((zerop n) lst)
		  (T (butfirst (cdr lst) (- n 1)))))

(defun myget-r(m i n res)
	(cond ((zerop n) res)
		  (T (myget-r m (swap-to-right i) (- n 1) (cons (mapcar #'nth i m) res)))))
	
(defun myget(m i)
	(myget-r m i (length m) NIL))
	
(myget lst '(0 1 2))

;better 6
(defun mybutlast (lst)
	(cond ((null (cdr lst)) nil)
		  (T (cons (car lst) (mybutlast (cdr lst))))))

(defun mylast (lst)
	(cond ((null (cdr lst)) (car lst))
		  (T (mylast (cdr lst)))))

(defun swap-to-right(lst)
	(cons (mylast lst) (mybutlast lst)))
	
(setf lstt '(a b c d))
(mybutlast lstt)
(mylast lstt)
(swap-to-right lstt)






;defend Обратная матрица
(setf lst1 '((1)))
(setf lst2 '((1 2)(3 4)))
(setf lst3 '((1 2 3)(4 5 6)(7 8 9)))
(setf lst '((2 5 7)(6 3 4)(5 -2 -3)))
(setf lst5 '((-1 -1 2 1 1)(0 -3 2 2 0)(2 1 3 0 0)(-2 3 0 -2 1)(-3 -3 3 -3 2)))

(defun butn (lst n &optional (cur_n 0))
	(cond ((null lst) NIL)
		  ((= cur_n n) (butn (cdr lst) n (+ cur_n 1)))
		  (T (cons (car lst) (butn (cdr lst) n (+ cur_n 1))))))

(defun get-min(m i j)
	(mapcar #'(lambda (x) (butn x j)) (butn m i)))

(get-min lst 0 0)

;ВЗАИМНАЯ РЕКУРСИЯ :D
(defun det-r(m &optional (cur_n 0) (len (length m)))
	(cond ((= cur_n len) NIL)
		  (T (cons (* (nth cur_n (car m)) (det (get-min m 0 cur_n))) (det-r m (+ cur_n 1) len)))))


(defun dop (lst &optional (n 0))
	(cond ((null lst) NIL)
		  ((evenp n)(cons (car lst) (dop (cdr lst) (+ n 1))))
		  (T (cons (- (car lst)) (dop (cdr lst) (+ n 1))))))

(defun det(m)
	(let ((len (length m)))
		 (cond ((= len 1) (caar m))
			   ((= len 2) (- (* (caar m) (cadadr m)) (* (cadar m) (caadr m))))
			   (T (apply #'+ (dop (det-r m)))))))
		 
(det-r lst)
(apply #'+ (dop (det-r lst)))

(det lst) ;-1
(det lst1) ;1
(det lst2) ;-2
(det lst3) ;0
(det lst5) ;-80

(defun nels (n el &optional (res NIL))
	(cond ((zerop n) res)
		  (T (nels (- n 1) el (cons el res)))))
		  
(nels 3 24)

(defun forward(n &optional (res NIL))
	(cond ((zerop n) res)
		  (T (forward (- n 1) (cons (- n 1) res)))))	  

(defun backward(n &optional (res NIL))
	(cond ((zerop n) res)
		  (T (cons (- n 1) (backward (- n 1) res)))))
		  
(forward 5)
(backward 5)

(defun get-is(n)
	(mapcar #'(lambda (x) (nels n x)) (forward n)))
	
(defun get-js(n)
	(mapcar #'(lambda (x) (forward n)) (forward n)))

(get-is 3)
(get-js 4)

(defun min-mtrx-r(m is js)
	 (cond ((or (null is) (null js))  NIL)
		   (T (cons (mapcar #'det (mapcar #'(lambda (i j) (get-min m i j)) (car is) (car js)))
					(min-mtrx-r m (cdr is) (cdr js))))))
		 
(defun min-mtrx(m)
	(let ((len (length m)))
		 (min-mtrx-r m (get-is len) (get-js len))))
		 
(min-mtrx-r lst (get-is 3) (get-js 3))
(min-mtrx lst)

(defun alg-dop(m &optional (n 0))
	(cond ((null m) NIL)
		  (T (cons (dop (car m) n) (alg-dop (cdr m) (+ n 1))))))

(alg-dop (min-mtrx lst))

(defun trans (m)
	(apply #'mapcar #'list m))
	
(trans (alg-dop (min-mtrx lst)))

(defun mtrx-mul(k m)
	(cond ((null m) NIL)
		  (T (cons (mapcar #'(lambda (x) (* k x)) (car m)) (mtrx-mul k (cdr m))))))
		  
(mtrx-mul -1 (trans (alg-dop (min-mtrx lst))))

(defun inverse-mtrx (m)
	(cond ((zerop (det m)) NIL)
		  (T (mtrx-mul (/ 1 (det m)) (trans (alg-dop (min-mtrx m)))))))
	
(inverse-mtrx lst)
(inverse-mtrx lst2)
(inverse-mtrx lst3)




;Не нужно
(defun get-row(a n &optional (j 0) (len (array-dimension a 0)))
	(cond ((= j len) NIL)
		  (T (cons (aref a n j) (get-row a n (+ j 1) len)))))
		  
(setf x (make-array '(3 3) 
   :initial-contents '((2 5 7)(6 3 4)(5 -2 -3))))
   
(setf y (make-array '(6) :initial-contents '(1 2 3 4 5 6)))

(map 'vector #'(lambda (x i) (* x i)) y '(0 1 2))

(defun make-2d-array(lst n)
	(make-array `(,n ,n)  :initial-contents lst))
	
(setf arr1 (make-2d-array '((1)) 1))
(setf arr2 (make-2d-array '((1 2)(3 4)) 2))
(setf arr (make-2d-array '((2 5 7)(6 3 4)(5 -2 -3)) 3))

(defun get-row(a n)
	(map 'list #'(lambda (x) (aref a n x)) (forward (array-dimension a 0))))
		 
(get-row arr 0)
(get-row arr 1)
(get-row arr 2)






;inverse-mtrx with array
(defun make-2d-arr(lst)
	(map 'vector #'(lambda (x) (apply #'vector x)) lst))
	
(setf arr (make-2d-arr lst))
(setf arr1 (make-2d-arr lst1))
(setf arr2 (make-2d-arr lst2))
(setf arr3 (make-2d-arr lst3))
(setf arr5 (make-2d-arr lst5))
	
(defun forward(n &optional (res NIL))
	(cond ((zerop n) res)
		  (T (forward (- n 1) (cons (- n 1) res)))))	 

(defun butn (lst n &optional (cur_n 0))
	(cond ((null lst) NIL)
		  ((= cur_n n) (butn (cdr lst) n (+ cur_n 1)))
		  (T (cons (car lst) (butn (cdr lst) n (+ cur_n 1))))))		  

(defun butn-arr(arr n &optional (len (length arr)))
	(map 'vector #'(lambda (x) (aref arr x)) (butn (forward len) n)))
	
(butn-arr arr 1)

(defun get-min-arr(a i j)
	(map 'vector #'(lambda (x) (butn-arr x j)) (butn-arr a i)))

(get-min-arr arr 0 0)

(defun ref (a i j)
	(aref (aref a i) j))

(defun det-arr-r(a &optional (len (length a)))
	(map 'vector #'(lambda (x y) (* x (det-arr y))) (aref a 0) (map 'vector #'(lambda (z) (get-min-arr a 0 z)) (forward len))))

(aref arr 0)
(map 'vector #'(lambda (z) (get-min-arr arr 0 z)) (forward (length arr)))

(det-arr-r arr)

(defun dop-arr (a &optional (n 0))
	(map 'list #'(lambda (x y) (if (evenp (+ y n)) x (- x))) a (forward (length a))))

(dop-arr (aref arr 0))

(defun det-arr(a)
	(let ((len (length a)))
		 (cond ((zerop len) NIL)
			   ((= len 1) (ref a 0 0))
			   ((= len 2) (- (* (ref a 0 0) (ref a 1 1)) (* (ref a 0 1) (ref a 1 0))))
			   (T (apply #'+ (dop-arr (det-arr-r a)))))))

(det-arr arr1) ;1
(det-arr arr2) ;-2
(det-arr arr) ;-1
(det-arr arr3) ;0
(det-arr arr5) ;-80

(defun nels (n el &optional (res NIL))
	(cond ((zerop n) res)
		  (T (nels (- n 1) el (cons el res)))))
		  
(nels 3 24)

(defun get-is(n)
	(mapcar #'(lambda (x) (nels n x)) (forward n)))
	
(defun get-js(n)
	(mapcar #'(lambda (x) (forward n)) (forward n)))

(get-is 3)
(get-js 4)
	
(apply #'map 'list #'list m)

(defun min-mtrx-arr(a &optional (len (length a)))
	(map 'vector #'(lambda (x y)
		(map 'vector #'(lambda (n)
			(det-arr (get-min-arr a (nth n x) (nth n y))))
			(forward (length a))))
		(get-is len) (get-js len)))
	
	;(map 'vector #'(lambda (x y) (det-arr (get-min-arr a x y))) (get-is len) (get-js len))		   ;v1
	;(apply #'map 'vector #'(lambda (x y) (det-arr (get-min-arr a x y))) (get-is len) (get-js len)) ;v2
	;(map 'vector #'(lambda (x y)(map 'vector #'(lambda (n) (det-arr (get-min-arr a (nth n x) (nth n y)))) (forward (length arr)))) (get-is len) (get-js len)) ;v2
	
(min-mtrx-arr arr)

(defun alg-dop-arr(a)
	(map 'vector #'(lambda (x) (apply #'vector (dop-arr x))) a))
	
(alg-dop-arr (min-mtrx-arr arr))

;STOPED HERE!!!
(defun trans-arr (a)
	(apply #'mapcar #'vector a))

(map 'vector #'(lambda (x) x) arr)	
(trans-arr (alg-dop-arr (min-mtrx-arr arr)))
	
(defun trans (m)
	(apply #'mapcar #'list m))
	
(trans (alg-dop (min-mtrx lst)))

(defun mtrx-mul(k m)
	(cond ((null m) NIL)
		  (T (cons (mapcar #'(lambda (x) (* k x)) (car m)) (mtrx-mul k (cdr m))))))
		  
(mtrx-mul -1 (trans (alg-dop (min-mtrx lst))))

(defun inverse-mtrx (m)
	(cond ((zerop (det m)) NIL)
		  (T (mtrx-mul (/ 1 (det m)) (trans (alg-dop (min-mtrx m)))))))
	
(inverse-mtrx lst)
(inverse-mtrx lst2)
(inverse-mtrx lst3)