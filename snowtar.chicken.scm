(module snowtar (tar-rec?
                 make-tar-rec
                 tar-rec-name tar-rec-name-set!
                 tar-rec-mode tar-rec-mode-set!
                 tar-rec-uid tar-rec-uid-set!
                 tar-rec-gid tar-rec-gid-set!
                 tar-rec-mtime tar-rec-mtime-set!
                 tar-rec-type tar-rec-type-set!
                 tar-rec-linkname tar-rec-linkname-set!
                 tar-rec-uname tar-rec-uname-set!
                 tar-rec-gname tar-rec-gname-set!
                 tar-rec-devmajor tar-rec-devmajor-set!
                 tar-rec-devminor tar-rec-devminor-set!
                 tar-rec-atime tar-rec-atime-set!
                 tar-rec-ctime tar-rec-ctime-set!
                 tar-rec-content tar-rec-content-set!
                 make-tar-condition
                 tar-condition?
                 tar-condition-msg
                 tar-pack-genport
                 tar-pack-file
                 tar-pack-u8vector
                 tar-unpack-genport
                 tar-unpack-file
                 tar-unpack-u8vector
                 tar-read-file)

  (import scheme)
  (cond-expand
    (chicken-4
     (import chicken
             extras
             miscmacros)
     (use data-structures
          lolevel
          numbers
          posix
          srfi-4
          utils))
    (chicken-5
     (import (chicken base)
             (chicken blob)
             (chicken condition)
             (chicken file posix)
             (chicken file)
             (chicken fixnum)
             (chicken io)
             (chicken memory)
             (chicken module)
             (chicken pathname)
             (chicken platform)
             (chicken process-context)
             (chicken string)
             (chicken syntax)
             (chicken time)
             (srfi 4)
             (miscmacros))))

  (include "snow-compatibility.scm")

  ;;; general

  (cond-expand
    (chicken
     (alias snow-raise signal))
    (r7rs
     (alias snow-raise raise)))

  (definternal (snow-make-filename . parts)
    (if (null? parts) ""
        (let loop ((whole (car parts)) (parts (cdr parts)))
          (if (null? parts) whole
              (loop (string-append whole "/" (car parts))
                    (cdr parts))))))

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

  (include "tar.scm"))
