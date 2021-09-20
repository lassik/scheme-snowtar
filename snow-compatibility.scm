(define-syntax defalias
  (syntax-rules ()
    ((_ (name . args) body ...)
     (define-compiler-syntax name
       (syntax-rules ()
         ((_ . args2)
          ((lambda args body ...) . args2)))))))

(define-syntax alias
  (syntax-rules ()
    ((_ new old)
     (define-compiler-syntax new
       (syntax-rules ()
         ((_ . args) (old . args)))))))

(define-syntax defnoop
  (syntax-rules ()
    ((_ new)
     (define-syntax new
       (syntax-rules ()
         ((_ . args) (begin)))))))

(define-syntax defidentity
  (syntax-rules ()
    ((_ new)
     (defalias (new x) x))))

(define-syntax definternal
  (syntax-rules ()
    ((_ (name . args) body ...)
     (begin
       (declare (hide name))
       (define (name . args) body ...)))
    ((_ name val)
     (begin
       (declare (hide name))
       (define name val)))))

(define-syntax define-macro
  (syntax-rules ()
    ((_ (name) val)
     (define-syntax name
       (syntax-rules ()
         ((_)
          val))))))
