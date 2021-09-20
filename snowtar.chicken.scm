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
                 tar-unpack-u8vector)

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
  (include "tar.scm"))
