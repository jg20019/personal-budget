;;;; budget.lisp

(in-package #:budget)

;; A budget has different categories. 
;; The rule of thumb is 50-30-20
;; 50% goes to necessities
;; 30% goes to discretionary expenses
;; 20% goes to savings and debt goals 

;; modified for Chrisitians it would be
;; 50-20-20-10
;; 50% goes to needs
;; 20% goes to wants
;; 20% goes to savings and debt goals
;; 10% goes to tithes

(defun valid-spending-breakdown-p (categories)
  "Ensures that all spending categories cover 100% of income." 
  (= 1 (reduce (lambda (sum category)
                 (+ sum (second category))) categories :initial-value 0))) 

(defun create-spending-breakdown (&rest categories)
  "Creates a spending breakdown. Makes sure that the sum of all of the fractions in categories is 1."
  (assert (valid-spending-breakdown-p categories))
  categories) 
   
(defparameter *spending-breakdown* 
  (create-spending-breakdown 
    '(needs 1/2)
    '(wants 1/5)
    '(savings 1/10)
    '(debts 1/10)
    '(tithes 1/10)))

(defun calculate-spending (spending-breakdown net-pay)
  "Calculates how much money is available for various categories."
  (mapcar (lambda (category) 
            (list (first category) (* (second category) net-pay))) spending-breakdown))

;; Expenses 

(defun add-expense (date desc amount))

(defun view-upcoming-expenses ())


;; I think it should also list what your expenses are so that you know 
;; what you need for a given month. 

;; Lastly, it tracks what you ideally spend. 
;; Because I think saving 10% is enough. 10% should be saved and 10% should go towards 
;; killing debt. 

;; 4 categories for spending: needs, wants, savings, and debts
;; needs - rent, car note, car insurance, food, gas
;; savings - 10% of earnings 
;; debts - studnt loans, outstaning balances
;; wants - everything else; (tithes comes out of here; because I want to track it
;; is a good idea to 

;; Need
;; due-date, description, amount 

;; Debt
;; id, organization, starting-balance   
;; every time we pay on debt we add a payment (id, debt-id, amount, date) 
;; can easily figure out how much is remaining 


;; Wants
;; date, amount, description 
;; tracks what we spend money on

;; Savings - a list of deposits/withdrawals
;; every time we deposit/withdraw we create a transaction (date, amount)
;; withdrawals are negative; deposits are positive. 





