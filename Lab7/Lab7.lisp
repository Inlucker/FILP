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
;???????????????????? ???????????? ?????????????? s2 ?? s1 ?????????? ?????????????????? n-???? ?????????????? ???????????? s2
(defun add-s(s1 s2 n)
	(mapcar #'- s2 (mapcar #'(lambda (x) (* x (/ (nth n s2) (nth n s1)))) s1)))
	
(setf mtrx '((1 -1 -5)(2 1 -7)))
(add-s '(1 -1 -5) '(2 1 -7) 0)
;???????????? n ?????????????????? ??????????
(defun first-n-els (lst n)
	(cond ((zerop n) NIL)
		  (T (cons (car lst) (first-n-els (cdr lst) (- n 1))))))
;?????????????????? n ?????????????????? ??????????
(defun last-n-els (lst n)
	(cond ((zerop n) NIL)
		  (T (append (last-n-els (butlast lst) (- n 1)) (last lst)))))

;Make better (without last)? (DONE)
(defun last-n-els-r (lst n)
	(cond ((zerop n) lst)
		  (T (last-n-els-r (cdr lst) (- n 1)))))

(defun last-n-els (lst n)
	(last-n-els-r lst (- (length lst) n)))

(setf lst '(a b c d e))
(first-n-els lst 1)
(first-n-els lst 3)
(last-n-els lst 1)
(last-n-els lst 3)
;???????????????????? ?????????????? ?? ???????????????????????? ????????
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
;?????????????? "???????????? ??????????????" s, ?????? res - ??????????, ???????????????????? ???? ???????????????????? ??????????, n ?????????? ????????, cur_n ?????????? ???????????????? X (?????????????? ?? 0)
(defun solve-s(s res n &optional  (cur_n (- (length s) (length res) 1)))
	;(print `(,s ,res ,n ,cur_n))
	(/ (apply #'- (append (reverse (mapcar #'* (last-n-els s n) res)) (list 0))) (nth cur_n s)))

(solve-s '(0 0 30/7 120/7) '(1) 1)
(solve-s '(0 -7 19 41) '(4 1) 2)
(solve-s '(3 2 -5 -1) '(5 4 1) 3)

;?????????????? ?????????????????????? ??????????????
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

;???????????????? ??????????
(defun check-SLAU-r(m len)
	;(print `(,m ,len))
	(cond ((null m) T)
		  (T (and (= len (length (car m)))
				  (check-SLAU-r (cdr m) len)))))

(defun check-SLAU(m)
	(check-SLAU-r m (+ (length m) 1)))
	
(setf mtrx '((3 2 -5 -1)(2 -1 3 13)(1 2 -1 9)))
(setf mtrx2 '((2 -5 12 42)(-94 59 -32 -6)(35 -26 -12 40)))
(setf mtrx3 '((3 2 -5 -1)(2 -1 3 13)))
(check-SLAU mtrx)
(check-SLAU mtrx2)
(check-SLAU mtrx3)

;???????????????????? ??????????????
(defun solve(SLAU)
	(solve-step (step-mtrx SLAU)))

;solve ?? ??????????????????
(defun solve(SLAU)
	(and (check-SLAU SLAU)
		 (solve-step (step-mtrx SLAU))))

;?????????? ??????????????
(defun print-solvations-r(res n)
	(cond ((null res) NIL)
		  (T (format T "X~A = ~A~%" n (car res))
			 (print-solvations-r (cdr res) (+ n 1)))))

(defun print-solvations(res)
	(print-solvations-r res 1))
	
(defun solve-and-print(SLAU)
	(print-solvations (solve SLAU)))
	
;TESTS
(setf mtrx '((3 2 -5 -1)(2 -1 3 13)(1 2 -1 9)))
(solve mtrx)
(solve-and-print mtrx)
;X1 = 3
;X2 = 5
;X3 = 4

(setf mtrx2 '((2 -5 12 42)(-94 59 -32 -6)(35 -26 -12 40)))
(solve mtrx2)
(solve-and-print mtrx2)
;X1 = -21092/3177
;X2 = -33578/3177
;X3 = 644/3177

(setf mtrx3 '((3 2 -5 -1)(2 -1 3 13)))
(solve mtrx3)
(solve-and-print mtrx3)

;fiveam
(ql:quickload "fiveam")

(fiveam:test Test-gauss
	"Test-gauss"
	(fiveam:is (equal '(3 5 4) (solve '((3 2 -5 -1)(2 -1 3 13)(1 2 -1 9)))))
	(fiveam:is (equal '(0 1/3 1/3) (solve '((1 1 2 1)(2 3 3 2)(4 4 5 3)))))
	(fiveam:is (equal '(-21092/3177 -33578/3177 644/3177) (solve '((2 -5 12 42)(-94 59 -32 -6)(35 -26 -12 40)))))
	(fiveam:is (null (solve '((3 2 -5 -1)(2 -1 3 13))))))

(fiveam:run! 'Test-gauss)





;ARRAY ?????? ???????????? ?? setf
(defun make-2d-arr(lst)
	(map 'vector #'(lambda (x) (apply #'vector x)) lst))
	
(setf arr (make-2d-arr mtrx))
(setf arr2 (make-2d-arr mtrx2))
(setf arr3 (make-2d-arr mtrx3))
	
(defun add-s-arr(s1 s2 n)
	(map 'vector #'- s2
		(map 'vector #'(lambda (x)
			(* x (/ (aref s2 n) (aref s1 n)))) s1)))

(add-s-arr #(1 -1 -5) #(2 1 -7) 0)

(defun forward(n &optional (res NIL))
	(cond ((zerop n) res)
		  (T (forward (- n 1) (cons (- n 1) res)))))
		  
(defun first-n-els-arr (a n)
	(map 'vector #'(lambda (x) (aref a x)) (forward n)))

(defun last-n-els-arr (a n)
	(map 'vector #'(lambda (x) (aref a x))
		 (mapcar #'(lambda (x) (+ (- (length a) n) x)) (forward n))))
	
(setf ar #(a b c d e))
(first-n-els-arr ar 1)
(first-n-els-arr ar 3)
(last-n-els-arr ar 1)
(last-n-els-arr ar 3)

(defun step-arr(a &optional (n 0) (len (length a)))
	(cond ((= n (- len 1)) a)
		  (T (step-arr (concatenate 'vector (first-n-els-arr a (+ n 1))
											 (map 'vector #'(lambda (x)
												(add-s-arr (aref a n) x n))
												(last-n-els-arr a (- len n 1)))) (+ n 1) len))))
												
(step-arr arr)

(defun solve-s-arr (s res n &optional  (cur_n (- (length s) (length res) 1)))
	(/ (apply #'- (append (reverse (map 'list #'* (last-n-els-arr s n) res)) (list 0))) (aref s cur_n)))

(solve-s-arr #(0 0 30/7 120/7) '(1) 1)
(solve-s-arr #(0 -7 19 41) '(4 1) 2)
(solve-s-arr #(3 2 -5 -1) '(5 4 1) 3)

(defun butlast-arr(a)
	(first-n-els-arr a (- (length a) 1)))

(defun solve-step-arr(a &optional (i (length a)) (n 1) (res '(1)))
	;(print `(,a ,i ,n ,res))
	(cond ((zerop i)(butlast res))
		  (T (solve-step-arr (butlast-arr a)
						 (- i 1)
						 (+ n 1)
						 (cons (solve-s-arr (aref (last-n-els-arr a 1) 0) res n) res)))))
						 
(solve-step-arr (step-arr arr))

(defun check-SLAU-arr(a &optional (len (+ (length a) 1)))
	(and (> len 1)
		 (every #'(lambda (x)
			(not (null x)))
				(map 'list #'(lambda (x)
					(= (length x) len)) a))))
	
(check-SLAU-arr arr)
(check-SLAU-arr arr2)
(check-SLAU-arr arr3)
(check-SLAU-arr #())

(defun solve-arr(SLAU)
	(and (check-SLAU-arr SLAU)
		 (solve-step-arr (step-arr SLAU))))
		 
(solve-arr arr)
(solve-arr arr2)
(solve-arr arr3)
(solve-arr #())

(defun print-solvations-r(res n)
	(cond ((null res) NIL)
		  (T (format T "X~A = ~A~%" n (car res))
			 (print-solvations-r (cdr res) (+ n 1)))))

(defun print-solvations(res)
	(print-solvations-r res 1))

(defun solve-and-print-arr(SLAU)
	(print-solvations (solve-arr SLAU)))
	
;TESTS
(solve-and-print-arr arr)
;X1 = 3
;X2 = 5
;X3 = 4

(solve-and-print-arr arr2)
;X1 = -21092/3177
;X2 = -33578/3177
;X3 = 644/3177

(solve-and-print-arr arr3)
;NIL

;fiveAM
(ql:quickload "fiveam")

(fiveam:test Test-gauss-arr
	"Test-gauss-arr"
	(fiveam:is (equal '(3 5 4) (solve-arr #(#(3 2 -5 -1)#(2 -1 3 13)#(1 2 -1 9)))))
	(fiveam:is (equal '(0 1/3 1/3) (solve-arr #(#(1 1 2 1)#(2 3 3 2)#(4 4 5 3)))))
	(fiveam:is (equal '(-21092/3177 -33578/3177 644/3177) (solve-arr #(#(2 -5 12 42)#(-94 59 -32 -6)#(35 -26 -12 40)))))
	(fiveam:is (null (solve-arr #(#(3 2 -5 -1)#(2 -1 3 13))))))

(fiveam:run! 'Test-gauss-arr)





;ARRAY ?????????? ?????????? :(
;???????????? array (???? ??????????)
(defun arr-reverse (a)
	(let* ((len (array-dimension a 0))(res (make-array `(,len))))
		(loop for i from (- len 1) downto 0 do
			(setf (aref res(- len i 1)) (aref a i)))
		res))
		
(arr-reverse y)

;???????????????? array
(setf x (make-array '(3 4) 
   :initial-contents '((3 2 -5 -1) (2 -1 3 13) (1 2 -1 9))))

;???????????????????? ?? ???????????????????????? ????????
(defun step-array(a)
	(dotimes (i (- (array-dimension a 0) 1))
		(loop for j from (+ i 1) to (- (array-dimension a 0) 1) do
			(let ((mn (/ (aref a j i) (aref a i i))))
				(dotimes (k (array-dimension a 1))
					(setf (aref a j k) (- (aref a j k) (* (aref a i k) mn)))))))
	a)

(step-array x)

;???????????????? ???????????? ???????????????????? ??????????????
(defun get-row (a r)
	(let ((res (make-array `(,(array-dimension a 1)))))
		(dotimes (i (array-dimension a 1))
			(setf (aref res i) (aref a r i)))
		res))
		
(get-row x 1)

;???????????? ???????????? ??????????????
(defun solve-row(a n res)
	(let* ((len (- (length a) 1)) (x (aref a len)))
		(loop for i from (+ n 1) to (- len 1) do
			(setf x (- x (* (aref a i) (nth (- i n 1) res)))))
		(setf x (/ x (aref a n)))))
	
(solve-row (get-row x 2) 2 '())
(solve-row (get-row x 1) 1 '(4))
(solve-row (get-row x 0) 0 '(5 4))

;???????????? ?????????????????????? ?????????????????? array
(defun solve-step-array (a)
	(let ((res '()))
		 (loop for i from (- (array-dimension a 0) 1) downto 0 do
			(setf res (cons (solve-row (get-row a i) i res) res)))
		 res))

(solve-step-array x)

;??????????
(defun print-solvations-arr(res)
	(dotimes (i (length res))
		(format T "X~A = ~A~%" (+ i 1) (nth i res))))
		
;??????????????
(defun solve-arr(a)
	(cond ((= (array-dimension a 0) (- (array-dimension a 1) 1))
		   (solve-step-array (step-array a)))
		   (T NIL)))
	
(solve-arr x)
	
(defun solve-and-print-arr(a)
	(print-solvations-arr(solve-arr a)))
	
(setf x (make-array '(3 4) :initial-contents '((3 2 -5 -1) (2 -1 3 13) (1 2 -1 9))))
(solve-and-print-arr x)
;X1 = 3
;X2 = 5
;X3 = 4

(setf y (make-array '(3 4) :initial-contents '((2 -5 12 42)(-94 59 -32 -6)(35 -26 -12 40))))
(solve-and-print-arr y)
;X1 = -21092/3177
;X2 = -33578/3177
;X3 = 644/3177

(setf z (make-array '(3 4) :initial-contents '((1 1 2 1)(2 3 3 2)(4 4 5 3))))
(solve-and-print-arr z)
;X1 = 0
;X2 = 1/3
;X3 = 1/3

;fiveam
(ql:quickload "fiveam")

(fiveam:test my-test-arr
	"My-test-arr"
	(fiveam:is (equal '(3 5 4) (solve-arr (make-array '(3 4) :initial-contents '((3 2 -5 -1) (2 -1 3 13) (1 2 -1 9))))))
	(fiveam:is (equal '(0 1/3 1/3) (solve-arr (make-array '(3 4) :initial-contents '((1 1 2 1)(2 3 3 2)(4 4 5 3))))))
	(fiveam:is (equal '(-21092/3177 -33578/3177 644/3177) (solve-arr (make-array '(3 4) :initial-contents '((2 -5 12 42)(-94 59 -32 -6)(35 -26 -12 40))))))
	(fiveam:is (null (solve-arr (make-array '(2 4) :initial-contents '((3 2 -5 -1)(2 -1 3 13)))))))

(fiveam:run! 'my-test-arr)

;????????????????????????
(setf arr (make-array '(6) :initial-contents '(1 2 3 4 5 6)))
(map 'vector #'+ arr arr)

(setf lst '(1 2 3 4 5 6))
(map 'vector #'+ lst lst)
(map 'vector #'+ lst arr)