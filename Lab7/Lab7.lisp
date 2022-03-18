;1
(defun move-to (lst result)
    (cond ((null lst) result)
          (T (move-to (cdr lst) (cons (car lst) result)))))
		  
(defun move-to (lst result)
    (cond ((null lst) result)
          (T (move-to (cdr lst) `(,(car lst) . ,result)))))
		  
(defun move-to (lst res)
    (cond ((null lst) res)
          (T (move-to (cdr lst) `(,(car lst) ,@res )))))
          
(defun my-reverse (lst)
    (move-to lst ()))

(setf lst '(a b c))
(my-reverse lst)

(defun mr2(lst res)
	(cond ((null lst) res)
		  (T ())))
	
(setf lst '(a b c))
(mr2 lst)

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
	(= (rem x 2) 1))

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

(defun gs(lst)
	(cond ((null lst) nil)
		  (T (cons (* (car lst)(car lst)) (gs (cdr lst))))))
		

;Defend
;Добавление строки матрицы s2 к s1 чтобы сократить n-ый элемент строки s2
(defun add-s(s1 s2 n)
	(mapcar #'- s2 (mapcar #'(lambda (x) (* x (/ (nth n s2) (nth n s1)))) s1)))
	
(setf mtrx '((1 -1 -5)(2 1 -7)))
(add-s '(1 -1 -5) '(2 1 -7) 0)
;Первые n элементов листа
(defun first-n-els (lst n)
	(cond ((zerop n) NIL)
		  (T (cons (car lst) (first-n-els (cdr lst) (- n 1))))))
;Последние n элементов листа
;Make better (without last and reverse)?
(defun last-n-els (lst n)
	(cond ((zerop n) NIL)
		  (T (append (last-n-els (butlast lst) (- n 1)) (last lst)))))

(setf lst '(a b c d e))
(first-n-els lst 1)
(first-n-els lst 3)
(last-n-els lst 1)
(last-n-els lst 3)
;Приведение матрицы к ступенчатому виду
;change append?
(defun step-mtrx-r(n m)
	(cond ((= n (- (length m) 1)) m)
		  (T (step-mtrx-r (+ n 1) (append (first-n-els m (+ n 1)) 
										  (mapcar #'(lambda (x)
														(add-s (nth n m) x n))
												  (last-n-els m (- (length m) n 1))))))))

(defun step-mtrx(m)
	(step-mtrx-r 0 m))

(setf mtrx '((3 2 -5 -1)(2 -1 3 13)(1 2 -1 9)))
(step-mtrx-r 0 mtrx)
(step-mtrx mtrx)
;Решение "строки матрицы" s, где res - корни, полученные на предыдущих шагах, n номер шага, cur_n номер искомого X (начиная с 0)
(defun solve-s(s res n &optional  (cur_n (- (length s) (length res) 1)))
	;(print `(,s ,res ,n ,cur_n))
	(/ (apply #'- (append (reverse (mapcar #'* (last-n-els s n) res)) (list 0))) (nth cur_n s)))

(solve-s '(0 0 30/7 120/7) '(1) 1)
(solve-s '(0 -7 19 41) '(4 1) 2)
(solve-s '(3 2 -5 -1) '(5 4 1) 3)

;Решение ступенчатой матрицы
(defun solve-step-r(m i n res)
	;(print `(,m ,i ,n ,res))
	(cond ((zerop i) (butlast res))
		  (T (solve-step-r (butlast m)
						   (- i 1)
						   (+ n 1)
						   (cons (solve-s (car (last m)) res n) res)))))

(defun solve-step(m)
	(solve-step-r m (length m) 1 '(1)))
	
(setf mtrx '((3 2 -5 -1)(2 -1 3 13)(1 2 -1 9)))
(solve-step (step-mtrx mtrx))
	
;Вывод решения
(defun print-solvations-r(res n)
	(cond ((null res) nil)
		  (T (format T "X~A = ~A~%" n (car res))
			 (print-solvations-r (cdr res) (+ n 1)))))

(defun print-solvations(res)
	(print-solvations-r res 1))

(print-solvations (solve-step (step-mtrx mtrx)))

(defun solve(SLAU)
	(print-solvations (solve-step (step-mtrx SLAU))))
	
;TESTS
(setf mtrx '((3 2 -5 -1)(2 -1 3 13)(1 2 -1 9)))
(solve mtrx)
;X1 = 3
;X2 = 5
;X3 = 4

(setf mtrx2 '((2 -5 12 42)(-94 59 -32 -6)(35 -26 -12 40)))
(solve mtrx2)
;X1 = -21092/3177
;X2 = -33578/3177
;X3 = 644/3177


















