# budget
### John Gibson <jg20019@gmail.com>_

This is a project to do build a web app for helping to create
a budget. It is based on something I learned about recently 
called the 50-30-20 rule. 

50% of income should go towards things you need (rent, food, gas, bills). 
30% of income should go towards things you want.
20% of income should go towards savings and debt. 

Using this as the template, when users create an account it sets the above 
as the default. Users can modify how much they want to spend in each category, 
and what the categories are. 

After the spending breakdown has been completed. Users can use a spending calculator
where they input how much money they have earned from i.e a paycheck and it calculates
how much money should be spent in the various categories. 

In the future, I plan to add areas on the site where you track past/future expenses, 
past/future income, so that you can better see where you are spending money and where
you need to spend money. The idea here is something I read in a previous book called 
"The Power of Habit" where participants in a study just by keeping a food journal ended
up making better eating habits and lost weight. 

## Usage
The app is very much a work in progress. If you wanted to run it, everything is written 
in either Common Lisp/HTML. It uses a PostgreSQL database. When you quickload the app, 
it loads the database configuration from the environment and starts the server. 

As it is now, it also deletes the database each time opting instead to create the tables
over again. (It is in early stages of development so I figured it would be ok.)  

The environment variables that need to be set are: 
1. DB_NAME 
2. DB_USERNAME
3. DB_PASSWORD

If DB_HOST is not set, it defaults to localhost. 
If DB_PORT is not set, it defaults to 5432. 

How to configure PostgreSQL is up to you.
Assuming it is up and running, quickloading the app should work.  

## Plans
As it is now, it is barely a working app. The only thing that can be done is 
loggin in, logging out and seeing a dummy page for after you login. It is really 
in the early stages of development. The next thing I will work on is the user interface
especially for the spending calculator, followed by the page where you can update 
the spending categories and their weights. 
## License

Specify license here

