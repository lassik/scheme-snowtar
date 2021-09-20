(define-syntax-rule (define-alias-syntax new old)
  (define-syntax-rule (old . args)
    (new . args)))

(define-syntax-rule (defalias (name . args) body ...)
  (define-compiler-syntax name
    (syntax-rules ()
      ((_ . args2)
       ((lambda args body ...) . args2)))))

(define-syntax-rule (alias new old)
  (define-compiler-syntax new
    (syntax-rules ()
      ((_ . args) (old . args)))))

(define-syntax-rule (defnoop new)
  (define-syntax new
    (syntax-rules ()
      ((_ . args) (begin)))))

(define-syntax-rule (defidentity new)
  (defalias (new x) x))

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


;;; general

(defnoop package*)

(define-syntax define-macro
  (syntax-rules ()
    ((_ (name) val)
     (define-syntax-rule (name) val))))

(alias snow-raise signal)

(definternal (snow-make-filename . parts)
  (string-intersperse parts "/"))

(definternal snow-cond? (condition-predicate 'snow))

(definternal (make-snow-cond type data) ; probably only sensible for tar
  (make-composite-condition
   (make-property-condition 'exn 'message (vector-ref data 0))
   (make-property-condition 'snow 'type type 'data (vector-ref data 0))
   (make-property-condition (car type))))

(defalias (snow-cond-type c)
  (get-condition-property c 'snow 'type))

(defalias (snow-cond-fields c)
  (get-condition-property c 'snow 'data))


;;; genport

(defalias (genport-write-subu8vector u8 s e p)
  (write-u8vector u8 p s e))

(defalias (genport-read-subu8vector u8 s e p)
  (read-u8vector! (fx- e s) u8 p s))

(alias genport-close-input-port close-input-port)
(alias genport-close-output-port close-output-port)
(alias genport-open-output-u8vector open-output-string)

(definternal (genport-open-input-file name)
  (open-input-file name #:binary))

(definternal (genport-open-output-file name)
  (open-output-file name #:binary))

(definternal (genport-open-input-u8vector v)
  (open-input-string (blob->string (u8vector->blob/shared v))))

(definternal (genport-get-output-u8vector p)
  (blob->u8vector/shared (string->blob (get-output-string p))))

(definternal (genport-read-file fname)
  ;;(blob->u8vector/shared (string->blob (read-all fname)))
  (blob->u8vector/shared (string->blob (read-string fname))))


;;; homovector

(alias snow-make-u8vector make-u8vector)
(alias snow-u8vector-set! u8vector-set!)
(alias snow-u8vector-ref u8vector-ref)
(alias snow-u8vector-length u8vector-length)
(alias snow-subu8vector subu8vector)

(definternal (snow-subu8vector-move! src src-s src-e dst dst-s)
  (move-memory!
   (u8vector->blob/shared src)
   (u8vector->blob/shared dst)
   (fx- src-e src-s)
   src-s dst-s))

(definternal (snow-ISO-8859-1-string->u8vector str)
  (blob->u8vector/shared (string->blob str)))

(definternal (snow-u8vector->ISO-8859-1-string v)
  (blob->string (u8vector->blob/shared v)))


;;; bignum

(alias bignum->string number->string)
(alias string->bignum string->number)
(defidentity fixnum->bignum)
(defidentity bignum->fixnum)


;;; time

(alias current-time-seconds current-seconds)


;;; filesys

(alias snow-file-directory? directory?)
(alias snow-directory-files directory)
