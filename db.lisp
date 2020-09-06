(in-package :budget)

;; Contains functions that allows us to interact with the database 

(define-condition not-configured-error (error) 
  ((text :initarg text :reader text)))

;; load db credentials from environment - need to be set before running project. 
(defparameter *db-name*
  (or (uiop:getenv "DB_NAME")
      (error 'not-configured-error :text "DB_NAME was not set in environment")))

(defparameter *db-username*
  (or (uiop:getenv "DB_USERNAME")
      (error 'not-configured-error :text "DB_USERNAME was not set in environment"))) 

(defparameter *db-password* 
  (or (uiop:getenv "DB_PASSWORD")
      (error 'not-configure-error :text "DB_PASSWORD was not set in environment")))

(defparameter *db-host*
  (or (uiop:getenv "DB_HOST") "localhost"))

(defparameter *db-port*
  (or (uiop:getenv "DB_PORT") 5432))

;; Connect to db
(postmodern:connect-toplevel *db-name* *db-username* *db-password* *db-host* :port *db-port*)

;; Create a users table 

(postmodern:query "DROP TABLE IF EXISTS categories;")
(postmodern:query "DROP TABLE IF EXISTS users;")
(postmodern:query "CREATE TABLE IF NOT EXISTS users (
                    id SERIAL NOT NULL PRIMARY KEY,
                    username TEXT NOT NULL UNIQUE, 
                    password TEXT NOT NULL);")

(postmodern:query "CREATE TABLE IF NOT EXISTS categories (
                     user_id INTEGER NOT NULL, 
                     name VARCHAR(255) NOT NULL, 
                     percent INTEGER, 
                     CHECK (percent > 0), 
                     CHECK (percent < 100), 
                     CONSTRAINT fk_users 
                     FOREIGN KEY (user_id)
                     REFERENCES users(id));")


(defun create-user (username password) 
  (postmodern:with-transaction ()
    (postmodern:query "INSERT INTO users (username, password)
                       VALUES ($1, $2);" username password)

    (postmodern:query "INSERT INTO categories (user_id, name, percent) 
                     VALUES (currval('users_id_seq'), 'needs', 50);")

    (postmodern:query "INSERT INTO categories (user_id, name, percent) 
                     VALUES (currval('users_id_seq'), 'wants', 30);")

    (postmodern:query "INSERT INTO categories (user_id, name, percent) 
                     VALUES (currval('users_id_seq'), 'savings and debts', 20);")))

(defun get-user-id-for-username (username) 
  "Returns id for user with given username. If user with username does not exist 
   returns nil." 
  (postmodern:query "SELECT id FROM users WHERE username=$1" username :single)) 

(defun get-password-for-username (username) 
  "Returns password for user with given username. If user with username does not exist 
   returns nil." 
  (postmodern:query "SELECT password FROM users WHERE username=$1" username :single))

(defun get-user-categories (&key user-id) 
  "Returns a list of users categories sorted by weight." 
  (postmodern:query
    "SELECT name, percent FROM categories WHERE user_id=$1 ORDER BY percent DESC;" user-id :lists)) 
;; creates a test user upon intialization. 
;; TODO: remove this from code. 
(create-user "jgibson" (cl-pass:hash "password"))

;; Categories can vary by user so, it makes sense to create a general categories table. 
;; Each row in the table contains a user-id, name, percent
;; When creating a new user, create a new categories table that defaults to 50-30-20
;; updating the category table happens in bulk, you have to update the entire thing 
;; all at once, to ensure that the percentages always add up to 1. 

;; Goals for today
;; Users are able to sign up and create categories for spending. 
;; Using the categories that they decide they can use the site to calculate how much 
;; money they should be spending each week in each area. 

;; Users should be able to add sources of income.
;; Users should then be able to add spending and categorize spending based on their categories. 
;; The site will show them where they are spending their money, but it will also show them 
;; when they are overspending in various categories. 

;; So, let's see - goals
;; 4. Create new account page
;; 5. Create update categories page
