;;;; budget.asd

(asdf:defsystem #:budget
  :description "Describe budget here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (:postmodern
               :hunchentoot
               :djula
               :cl-pass)
  :components ((:file "package")
               (:file "budget")
               (:file "web")
               (:file "db")))
