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
	
;objcets
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
		 
;???????????????????
(defun basis-r(n M res)
	(cond ((< n M) res)
		  (T (nconc res (list (next-prime (car (last res)))))
			 (basis-r n (apply #'* res) res))))

(defun basis(n)
	(cdr (basis-r n 1 '(1))))
;???????????????????

;defend: 10сс->СОК
(defun primep (n &optional (a 2) (b (isqrt n)))
	(print `(,n ,a ,b))
	(cond ((> a b))
		  ((zerop (mod n a)) nil)
          (t (primep n (1+ a) b))))

;Предикат - является ли число простым
(defun primep-r (n a)
	(let ((b (isqrt n)))
		 (cond ((> a b))
			   ((zerop (mod n a)) NIL)
			   (T (primep-r n (+ a 1))))))

(defun primep (n)
	(primep-r n 2))

;Все простые числа до n
(defun primes-r(n a)
	(cond ((> a n) nil)
		  ((primep a) (cons a (primes-r n (+ a 1))))
		  (T (primes-r n (+ a 1)))))

(defun primes(n)
	(primes-r n 1))

;Следующее простое число	
(defun next-prime(n)
	(cond ((null n) 1)
		  ((primep (+ n 1)) (+ n 1))
		  (T (next-prime (+ n 1)))))

;добавление в конец
(defun lst-wtih-n(lst n)
	(append lst `(,n)))

;Определение базиса для числа
(defun basis-r(n M res)
	(cond ((< n M) res)
		  (T (let ((next-res (lst-wtih-n res (next-prime (car (last res))))))
				  (basis-r n (apply #'* next-res) next-res)))))

(defun basis(n)
	(cdr (basis-r n 1 '(1))))

;Первеод числа в СОК	
(defun RNS(n &optional (b (basis n)))
	(mapcar #'(lambda (x) (mod n x)) b))
	
(defun to-RNS(n &optional (b (basis n)))
	(format t "Число ~A можно представить в виде кортежа ~A в СОК с базисом ~A"
					n (mapcar #'(lambda (x) (mod n x)) b) b))

;Mi
(defun get-Ms-r(bas M)
	(cond ((null bas) nil)
		  (T (cons (/ M (car bas)) (get-Ms-r (cdr bas) M)))))
					
(defun get-Ms(b)
	(get-Ms-r b (apply #'* b)))
	
;Bi
(defun Bi-r(p Mi res)
	(cond ((= (mod (* Mi res) p) 1) res)
		  (T (Bi-r p Mi (+ res 1)))))
		  
(defun Bi(p Mi)
	(Bi-r p Mi 1))

(defun get-Bs(bas &optional (Ms (get-Ms bas)))
	(mapcar #'Bi bas Ms))

;Перевод числа обратно в 10сс		
(defun from-RNS(x b)
	(mod (apply #'+ (mapcar #'* x (get-Ms b) (get-Bs b)))
		 (apply #'* b)))
		 
;tests
(to-rns 29)
(to-rns 1 '(2 3 5))
(to-rns 7 '(2 3 5))
(from-rns '(1 2 4) '(2 3 5))
(from-rns '(1 1 2) '(2 3 5))

;Чтобы не считать (get-Ms b) 2 раза
(defun from-RNS(x b)
	(let ((Ms (get-Ms b)))
		 (mod (apply #'+ (mapcar #'* x Ms (get-Bs b Ms)))
			  (apply #'* b))))