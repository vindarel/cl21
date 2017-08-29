(in-package :cl-user)
(defpackage cl21.core.arrows
  (:use :cl)
  (:import-from :cl-arrows
                :->
                :->>
                :-<>
                :-<>>)
  (:export :->
           :->>
           :-<>
           :-<>>))
