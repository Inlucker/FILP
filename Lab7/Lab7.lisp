;1
(defun move-to (lst result)
    (cond ((null lst) result)
          (T (move-to (cdr lst) (cons (car lst) result)))))
          
(defun my-reverse (lst)
    (move-to lst ()))
	
;3
(defun get-first(lst)
	)
	
;4