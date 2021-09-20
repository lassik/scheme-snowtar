;;;; snowtar.scm


(use srfi-4 numbers lolevel posix utils data-structures)

(include "snow-compatibility.scm")

(define-record tar-rec
  name
  mode
  uid
  gid
  mtime
  type
  linkname
  uname
  gname
  devmajor
  devminor
  atime
  ctime
  content)

(include "tar.scm")
