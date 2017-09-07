# CL21 - Common Lisp in the 21st Century.

This is an experimental project aiming at redesigning *a new successor of Common Lisp*.
Discussion is highly welcome, join the issues thread and post some ideas!
(However, please read the older posts before you actually post something!)

<!-- The aim is both at -->
<!-- catching the newcomer's eye and still attracting the old-lispers -->

## Philosophy and Features

* Trying to be the true successor -- Cooperate with existing Common Lisp applications/libraries
* Clean names and clean packages -- Symbols are re-considered and re-organized
* CLOS-based functions and MOP -- write fast, tune later
* Brought more functional facilities. -- Lazyness, etc.
* Aggressive use of reader-macros.
  * Regexp literals.
  * Hash-table literals.
  * String Interpolation (once deleted, but is going to appear again in the other
    form)
* Includes Gray streams, CLtL2 Environment, etc
* Package local nicknames. (experimental)

## Usage

```common-lisp
;; Installation
(ql-dist:install-dist "http://dists.cl21.org/cl21.txt")
(ql:quickload :cl21)

(in-package :cl21-user)
(defpackage myapp (:use :cl21))
(in-package :myapp)

;; Hello, World!

(princ "Hello, World!\n")
;-> Hello, World!
;=> "Hello, World!
;   "

;; Hash Table  --  consistent interface!

(defvar *hash* #H())
(getf *hash* :name)                            ;=> NIL
(setf (getf *hash* :name) "Eitaro Fukamachi") ;=> "Eitaro Fukamachi"
(setf (getf *hash* :living) "Japan")           ;=> "Japan"
(getf *hash* :name)                            ;=> "Eitaro Fukamachi"
(coerce *hash* 'plist)                         ;=> (:LIVING "Japan" :NAME "Eitaro Fukamachi")

;; Vector      --  consistent interface again!

(defvar *vector* #())
(push 1 *vector*)
(elt *vector* 0)   ;=> 1
(push 3 *vector*)
(elt *vector* 1)   ;=> 3
(pop *vector*)     ;=> 3
(pop *vector*)     ;=> 1

;; Iteration -- `doeach` is similar to `dolist`, but it can be used with all sequences.

(doeach (x '("al" "bob" "joe"))
  (when (> (length x) 2)
    (princ #"${x}\n")))
;-> bob
;   joe


;; Functional programming

(map (compose #'sin #'1+) '(1 2 3))
;=> (0.9092974 0.14112 -0.7568025)

;; remove-if-not -> keep-if
(keep-if (conjoin #'integerp #'evenp) '(1 2 3 2.0 4))  ;=> (2 4)
(keep-if (disjoin #'oddp #'zerop) (0.. 10))            ;=> (0 1 3 5 7 9)

;; Useful Shapsign-Quote reader macro
(keep-if #'(and integerp evenp) '(1 2 3 2.0 4))        ;=> (2 4)
(keep-if #'(and integerp (or oddp zerop)) (0.. 10))    ;=> (0 1 3 5 7 9)


;; Threading macros
(-<>> (list 1 2 3)
      (remove-if #'oddp <> :count 1 :from-end t)
      (reduce #'+)
      /)
=> 1/3


;; Regular Expression (based on cl-ppcre)

(use-package :cl21.re)   ; in/use-package are redefined so that they
                         ; load the associated syntax at the same time

(re-match #/^Hello, (.+?)!$/ "Hello, World!")
;=> "Hello, World!"
;   #("World")

;; Regular expressions are ... functions!

(#/^(\d{4})-(\d{2})-(\d{2})$/ "2014-01-23")
;=> "2014-01-23"
;   #("2014" "01" "23")

(re-replace #/a/g "Eitaro Fukamachi" "α")
;=> "Eitαrow Fukαmαchi"
;   T


;; Running external programs (cl21.process)

(use-package :cl21.process)

(run-process '("ls" "-l" "/Users"))
;-> total 0
;   drwxrwxrwt    5 root         wheel   170 Nov  1 18:00 Shared
;   drwxr-xr-x+ 174 nitro_idiot  staff  5916 Mar  5 21:41 nitro_idiot
;=> #<PROCESS /bin/sh -c ls -l /Users (76468) EXITED 0>

#`ls -l /Users`
;=> "total 0
;   drwxrwxrwt    5 root         wheel   170 Nov  1 18:00 Shared
;   drwxr-xr-x+ 174 nitro_idiot  staff  5916 Mar  5 21:41 nitro_idiot
;   "
;   ""
;   0


;; Lazy Sequence

(use-package :cl21.lazy)

(defun fib-seq ()
  (labels ((rec (a b)
             (lazy-sequence (cons a (rec b (+ a b))))))
    (rec 0 1)))

(take 20 (fib-seq))
;=> #<LAZY-SEQUENCE {1009F7A893}>
(coerce * 'list)
;=> (0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181)

(take 3 (drop-while ^(< % 500) (fib-seq)))
;=> #<LAZY-SEQUENCE {1009F33693}>
(coerce * 'list)
;=> (610 987 1597)


;; package-local-nickname

CL21-USER> (defpackage mypack (:use :cl21))           ; -> #<PACKAGE "MYPACK">
CL21-USER> (in-package :mypack)                       ; -> #<PACKAGE "MYPACK">
MYPACK> (defun *2 (x) (* x x))                        ; -> *2
MYPACK> (export '*2)                                  ; -> T
MYPACK> (in-package :cl21-user)                       ; -> #<PACKAGE "CL21-USER">
CL21-USER> (add-package-local-nickname :mp :mypack)   ; -> #<PACKAGE "CL21-USER">
CL21-USER> (mp:*2 5)                                  ; -> 25
```

### Deferred List

* Multi-Threading and Multi-Processing.
* POSIX interactions.

## Requirements

CL21 is written in pure Common Lisp and intended to run on a Common Lisp implementation.
It is tested on the latest version of SBCL, Clozure CL, GNU CLISP and Allegro CL.

## Installation

```common-lisp
(ql-dist:install-dist "http://dists.cl21.org/cl21.txt")
(ql:quickload :cl21)
```

## List of major changes from standard CL

We have a list about differences between CL and CL21 at [CHANGES_AUTO.markdown](./CHANGES_AUTO.markdown) which is automatically generated by a script.

## Updating to the latest version

CL21 is continuously released at 1:00 JST (= 16:00 UTC). You can update to the HEAD version by this command.

```common-lisp
(ql:update-dist "cl21")
```

## How to use in your project

CL21 is written in Common Lisp and works as a Common Lisp library. Not only you can write your application whole in CL21, but you can write only one file of your application in CL21.

If you're going to write your application whole in CL21, add `:class` to `asdf:defsystem` form.

```common-lisp
(defsystem myapp
  :defsystem-depends-on (:cl21)
  :class :cl21-system
  :components ((:file "src/myapp")))
```

If you wanna write some files in CL21, use `:cl21-source-file` instead of `:file`.

```common-lisp
(defsystem myapp
  :defsystem-depends-on (:cl21)
  :components ((:file "src/myapp")
               (:cl21-source-file "src/myapp-written-in-cl21")))
```

If you're going to write a CL21 script, not big enough to use ASDF, ensure you're in CL21-USER package first.

```common-lisp
#!/usr/bin/env sbcl --script

(ql:quickload :cl21)
(cl21:in-package :cl21-user)

;; Start your code from here.
```

## Make an executable of CL21

```
$ sbcl --noinform --no-sysinit --no-userinit --eval '(load #P"~/quicklisp/setup.lisp")' --eval '(ql:quickload :cl21)' --eval '(cl21:in-package :cl21-user)' --eval '(sb-ext:save-lisp-and-die #P"cl21" :executable t)'
```

## Setting the startup package of SLIME

Add the following code

1) to your Lisp init file.

```common-lisp
(ql:quickload :cl21)
```

2) and, to your `.emacs.el` .

```common-lisp
(add-hook 'slime-connected-hook (lambda ()
                                  (when (slime-eval `(cl:if (cl:find-package :cl21-user) t))
                                    (slime-repl-set-package :cl21-user)
                                    (slime-repl-eval-string "(cl21:enable-cl21-syntax)"))) t)
```

## See Also

* Closer MOP
* Trivial Types
* trivial-gray-streams
* Alexandria
* Split-Sequence
* REPL-Utilities

## Credits

* [fukamachi](https://github.com/fukamachi)
* [guicho271828](https://github.com/guicho271828)
* [m-n](https://github.com/m-n)
* [snmsts](https://github.com/snmsts)
* [EuAndreh](https://github.com/EuAndreh)
* [KeenS](https://github.com/KeenS)

# License

CL21 is free and unencumbered software released into the public domain.
