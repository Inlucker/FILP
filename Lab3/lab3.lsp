(defun f1(a)
	(if (evenp a)
		a
		(+ a 1)))
		
(defun f2(a)
	(if (< a 0)
		(- a 1)
		(+ a 1)))

(defun f3(a b)
	(if (< a b)
		(list a b)
		(list b a)))
		
(defun f4(a b c)
	(if (or (and (< a c) (> a b))
			(and (> a c) (< a b)))
		T
		NIL))
		
(defun f6(a b)
	(if (< a b)
		NIL
		T))
		
(defun pred1 (x) 
	(and (numberp x) (plusp x)))

(defun pred2 (x)
	(and (plusp x)(numberp x)))
	
(defun f8if(a b c)
	(if (< a c)
		(> a b)
		(and (> a c) (< a b))))
		
(defun f8cond(a b c)
	(cond
		((< a c) (> a b))
		((> a c) (< a b))))
			
(defun f8and_or(a b c)
	(or (and (< a c) (> a b))
		(and (> a c) (< a b))))
		
		
(defun how_alike(x y)
	(cond ((or (= x y) (equal x y)) 'the_same)
	((and (oddp x) (oddp y)) 'both_odd)
	((and (evenp x) (evenp y)) 'both_even)
	(t 'difference) ))
		
(defun how-alike(x y)
	(if (or (= x y) (equal x y))
		'the_same
		(if (and (oddp x) (oddp y))
			'both_odd
			(if (and (evenp x) (evenp y))
				'both_even
				'difference))))

;вывод в файл		 
(with-open-file (str "filename.txt" :direction :output :if-exists :supersede :if-does-not-exist :create)
(format str "Hello world!"))

;защита
(defun solve(a b c)
	(cond ((= a b c 0) '(Любой корень))
		  ((= a b 0) '(Нет корней))
		  ((= a 0) `(Один корень = ,(/ (- c) b)))
		  (T (let* ((D (- (* b b) (* 4 a c))) (x1 (/ (- (- b) (sqrt D)) (* 2 a))) (x2 (/ (+ (- b) (sqrt D)) (* 2 a)))) 
			(cond
			((< D 0) `(Комплексные корни = ,(realpart x1) ,(imagpart x1)i и ,(realpart x2) ,(imagpart x2)i))
			((= D 0) `(Один корень = ,(/ (- b) (* 2 a))))
			((> D 0) `(Два корня = ,x1 и ,x2)))))
	))
	
(defun print-in-file(str lst)
	(or (null (car lst))
		(format str "~A " (car lst))
		(print-in-file str (cdr lst))))
	
(defun my-print(lst)
	(with-open-file (str "filename.txt" :direction :output :if-exists :supersede :if-does-not-exist :create)
					(or (null (car lst))
						(print-in-file str lst))))

(defun solve-and-print(a b c)
	(my-print (solve a b c)))
	
;fiveAM
(ql:quickload "fiveam")

(fiveam:test D-below-zero
	(fiveam:is (equal '(КОМПЛЕКСНЫЕ КОРНИ = 3.0 -2.0 I И 3.0 2.0 I ) (solve 1 -6 13))))
  
(fiveam:test D-equals-zero
	(fiveam:is (equal '(Один корень = -1) (solve 1 2 1))))
						
(fiveam:test D-over-zero
	(fiveam:is (equal '(ДВА КОРНЯ = -2.618034 И -0.381966) (solve 1 3 1))))
  
(fiveam:test a-equals-zero
	(fiveam:is (equal '(Один корень = -1/2) (solve 0 2 1))))

(fiveam:test no-solution
	(fiveam:is (equal '(Нет корней) (solve 0 0 1))))
	
(fiveam:test any-solution
	(fiveam:is (equal '(бред корень) (solve 0 0 0))))
  
(fiveam:run!)

(solve-and-print 1 2 1)
(solve-and-print 2 -3 1)+++