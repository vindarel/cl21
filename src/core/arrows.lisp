(in-package :cl-user)
(defpackage cl21.core.repl
  (:use :cl)
  (:import-from :arrow-macros
                :->
                :->>
                :some->
                :some->>
                :as->
                :cond->
                :cond->>

                :-<>
                :-<>>
                :some-<>
                :some-<>>)
  (:export :->
           :->>
           :some->
           :some->>
           :as->
           :cond->
           :cond->>

           :-<>
           :-<>>
           :some-<>
           :some-<>>))
