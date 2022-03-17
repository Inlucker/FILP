(defun get_gip(a b)
	(sqrt (+ (* a a) (* b b))))
	
(defun get_vol(a b c)
	(* a b c))
	
(defun longer_than(a b)
	(if (> (length a) (length b)) T nil))
	
(+ (length '(for 2 too)) (car '(21 22 23)))

(defun mystery (x) (list (second x) (first x)))
	
(defun f-to-c(temp)
	(* (- temp 32) (/ 5 9)))