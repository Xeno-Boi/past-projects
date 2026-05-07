Restaurant Database Server
author: Honam Leung
Date: 11/12/2021


Description:
	A webserver that has a restaurant order page, an account login system and uses cookies.

** Install node.js and mongoDB before running server

Node.js
   1. install node.js from "https://nodejs.org/en/download"

   2. open command shell and execute "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"

MongoDB
   1. install mongoDB from "https://www.mongodb.com/try/download/community-kubernetes-operator"
	* install mongo compass to browse database entries


To run server
	1. open command shell in the file directory
	
	2. execute "run.bat"

	3. choose if database should be reset to default

	4. if "Server is listening at http://localhost:3000" is logged,
	   the server has started successfully

	5. browse "http://localhost:3000/" to access the server


To browse database entries
	1. open mongoDB compass

	2. connect to localhost:27017

	3. locate database "a4"

files:
	resource
	|	- add.png
	|
	|	- remove.png

	restaurants
	|	- aragorn.json
	|
	|	- frodo.json
	|
	|	- logolas.json

	router
	|	- userRouter.js

	scripts
	|	- login.js
	|	
	|	- logout.js
	|	
	|	- orderform.js
	|	
	|	- profile.js
	|	
	|	- register.js
	|	
	|	- user.js

	styles
	|	- forbiddenStyle.css
	|	
	|	- header.css
	|
	|	- homeStyle.css
	|	
	|	- inputPageStyle.css
	|	
	|	- loginStyle.css
	|	
	|	- orderformStyle.css
	|	
	|	- orderStyle.css
	|	
	|	- profileStyle.css
	|	
	|	- resultStyle.css
	|	
	|	- userStyle.css

	views
	|	errors
	|	|	- forbidden.pug
	|	|
	|	|	- notfound.pug
	|
	|	header
	|	|	- loggedIn.html
	|	|
	|	|	- loggedOut.html
	|
	|	home
	|	|	- home.pug
	|
	|	login
	|	|	- loginpage.pug
	|
	|	orderform
	|	|	- orderform.pug
	|	
	|	orders
	|	|	- orders.pug
	|	
	|	register
	|	|	- register.pug
	|	
	|	users
	|	|	profile
	|	|	|	- profile.pug
	|	|	
	|	|	results
	|	|	|	- results.pug
	|	|	
	|	|	- users.pug

	- database-initializer.js

	- package.json

	- README.txt

	- server.js


features:
	http://localhost:3000/ - home page

	http://localhost:3000/home - home page
	
	http://localhost:3000/users - user search page

	http://localhost:3000/users/results?<query> - search results of users

	http://localhost:3000/users/<username> - profile page of user

	http://localhost:3000/profile - profile page of logged in user

	http://localhost:3000/register - user register page

	http://localhost:3000/loginpage - login page

	http://localhost:3000/orderform - orderform

	http://localhost:3000/orders/<orderID> - order details page

	http://localhost:3000/notfound - 404 not found page

	http://localhost:3000/forbidden - 403 forbidden page

Function design:

	// server initiates

	The server uses express to handle incoming request.

	All functions and routes for "/users" are seperated to a
	router file "userRouter.js"

	When the server starts, it reads restaurant information from a
	file and store them in an object.


	// login

	Server allows client to login via ajax request. If success,
	username and password used will be saved in a session cookie

	When a client request a page, server checks cookie and determines
	if a client is logged-in by the included username and password.

	If client is logged-in, header for logged-in pages are used to render.

	Header for logged-in and non-logged-in pages are stored as html files,
	and included as headers to other pug files.

	If a client is not logged-in and trys to access logged-in only pages,
	server redirects client to login page.

	If a client is trying to access a profile page of a private account
	and client is not logged-in as the account,
	server redirects client to forbidden page.

	For every url that is not catched or links to non-existing resources,
	server redirects it to notfound page.


	// register

	When a client registers, server fetch a record with the given username
	from database. If no record is found, given username is unique and
	the process continues. Otherwise a "failed" message will be sent.	


	// storing data

	Users and orders are stored seperately inside database.

	User records include a list of ObjectID corresponding to orders made
	by user.

	Order records include a username attribute to store who it belongs to.

	Users are identified by username as usernames are unique to every user.