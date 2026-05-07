Restaurant Order Server
author: Honam Leung
Date: 31/10/2021

Description:
	A webserver that includes the order page and statistics page for some restaurants.

** Install node.js before running server
   1. install node.js from "https://nodejs.org/en/download"

   2. open command shell and execute "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"

To run server
	1. open command shell in the file directory
	
	2. execute "run.bat"

	3. if "Server is listening at http://localhost:3000" is logged,
	   the server has started successfully

	4. browse "http://localhost:3000/" to access the server

features:
	http://localhost:3000/ - loads home page
	
	http://localhost:3000/orderform - loads order page

	http://localhost:3000/statpage - loads statistics page

files:
	- server.js

	page
	|	home
	|	|	- index.html
	|	|	
	|	|	- indexStyles.css
	|	
	|	order
	|	|	- add.png
	|	|	
	|	|	- client.js
	|	|	
	|	|	- orderform.html
	|	|
	|	|	- orderStyle.css
	|	|
	|	|	- remove.png
	|	
	|	stat
	|	|	- stat.pug
	|	|
	|	|	- statStyle.css

	restaurants
	|	- aragorn.json
	|
	|	- frodo.json
	|
	|	- logolas.json

	- package.json

	- README.txt

Function design:
	The server uses a nested if design to handle incoming request.

	When the server starts, it reads restaurant information from a
	file and store them in an object.

	When the orderpage is loaded, client will request a list of
	restaurants from the server to render the drop down list.

	When a restaurant is selected, client will request a JSON containing
	the information of the required restaurant.
	The page will be rendered with the data.

	Most calculations are performed in the client side. The client sends
	the cart data to the server when submitting the order.

	The server processes the data and saves required information in arrays and variables.

	When the statistics page is requested, required data in variables will
	be saved into an object and passed to a pug template. The generated
	HTML file will be sent to the client.