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