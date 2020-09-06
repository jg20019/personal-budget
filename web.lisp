;; This file contains code for routing, sessions, and various web pages.  
(in-package :budget)
;; templates 

(djula:add-template-directory (asdf:system-relative-pathname "budget" "templates/"))
(defparameter +base.html+ (djula:compile-template* "base.html"))
(defparameter +home.html+ (djula:compile-template* "home.html"))
(defparameter +login.html+ (djula:compile-template* "login.html"))


(defparameter *acceptor* (make-instance 'hunchentoot:easy-acceptor :port 4242))
; start server
(hunchentoot:start *acceptor*)

; stop server
; (hunchentoot:stop *acceptor*)

(defun authenticate (username password) 
  "Returns t if user with given username and password exists." 
  (let ((password-hash (get-password-for-username username)))
      (when password-hash 
        (cl-pass:check-password password password-hash)))) 
 
(defun login (user-id) 
  "Log the user into the session"
  (setf (hunchentoot:session-value :user-id) user-id))

(defun logout ()
  "Log the user into the session" 
  (setf (hunchentoot:session-value :user-id) nil))

(defun logged-in-p ()
  (hunchentoot:session-value :user-id)) 

(hunchentoot:define-easy-handler (home-page :uri "/") ()
  (hunchentoot:start-session) 
  (cond ((logged-in-p) (djula:render-template* +home.html+ nil))
        (t (hunchentoot:redirect "/login")))) 

(defun login-form (&optional (username "") (error-message "")) 
  "Renders the login form. If username was provided as in the case of a failed login add that 
   to the rendered form." 
  (djula:render-template* +login.html+ nil :username username :message error-message)) 
  
(hunchentoot:define-easy-handler (login-page :uri "/login")
    ((username :request-type :POST)
     (password :request-type :POST))
  (hunchentoot:start-session) 
  (cond ((eql :GET (hunchentoot:request-method*)) (login-form))
        ((eql :POST (hunchentoot:request-method*)) 
         (cond ((authenticate username password) 
                (let ((user-id (get-user-id-for-username username)))
                  (login user-id)
                  (hunchentoot:redirect "/"))) 
               (t (login-form username "Invalid username/password."))))))

(hunchentoot:define-easy-handler (logout-page :uri "/logout") () 
  (hunchentoot:start-session)
  (logout)
  (hunchentoot:redirect "/")) 

;; Need to create wireframes for the following pages: 
;; home / spending calculator page 
;; login 

;; Want to create the following pages today: 
;; home
;; create-account
;; login
;; logout 
;; spending-calculator - this is based on spending categories 
;;  - defaults to needs - 50, wants - 30, and savings and debts - 20 
;;  - getting current debts (car notes, insurance etc. paid down asap 
;;  - saving money for weekly expenses (food and gas) 
;;  - and setting aside money for tides immediately makes the most sense. 
;;  - probably won't be able to pay car note immediately, but if wise 
;;  - I will be able to get current this month. 
;;  - but any way this page is for estimating how much money to spend on various 
;;  - categories. It is meant to help calculate but the spending decisions are up 
;;  - to the user.  
