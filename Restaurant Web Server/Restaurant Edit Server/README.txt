Restaurant Edit Server
author: Honam Leung
Date: 31/10/2021

Description:
	A webserver that allows addition and edits of restaurant data.

** Install node.js before running server
   1. install node.js from "https://nodejs.org/en/download"

   2. open command shell and execute "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"


To run server
	1. open command shell in the file directory
	
	2. execute "run.bat"

	3. if "Server is listening at http://localhost:3000" is logged,
	   the server has started successfully

	4. browse "http://localhost:3000/" to access the server

files:
	restaurants
	|	- aragorn.json
	|
	|	- frodo.json
	|
	|	- logolas.json

	routes
	|	- restaurants.js

	views
	|	addRestaurant
	|	|	- addRestaurant.html
	|
	|	home
	|	|	- index.html
	|
	|	restaurantInfo
	|	|	- restaurantInfo.pug
	|
	|	restaurants
	|	|	- restaurantsList.pug
	|	
	|	Scripts
	|	|	- addRestaurant.js
	|	|
	|	|	- restaurantInfo.js
	|	
	|	styles
	|	|	- addRestaurant.css
	|	|
	|	|	- header.css
	|	|
	|	|	- indexStyles.css
	|	|
	|	|	- rInfo.css
	|	|
	|	|	- rList.css

	- package.json

	- README.txt

	- server.js


features:
	http://localhost:3000/ - loads home page
	
	http://localhost:3000/restaurants - loads a list of restaurants

	http://localhost:3000/addrestaurant - loads a page to add new restaurant

	http://localhost:3000/restaurants/id - loads the info page of a restaurant with id

Function design:
	The server uses express to handle incoming request.

	All functions and routes for "/restaurants" are seperated to a
	router file "restaurants.js"

	When the server starts, it reads restaurant information from a
	file and store them in an object.

	When the list of restaurant is loaded, client will request a list of
	restaurants from the server to render list. Each item on the list
	is a link to the restaurant's info page.

	When the info page first loads, client will request the restaurant object
	from server and store it locally.

	Client can add a new restaurant in the addrestaurant page, which will store
	the restaurant to the server and redirect client to the restaurant info page.

	Info page displays restaurant informations such as restaurant name, and
	the full menu divided into categories. All data are requested from the server
	and generated as a page.
	
	Client can add new categories and items by using the add buttons on the info page.

	Dropdown list of categories in the "add item" box is generated from the restaurant object
	stored on client side. Everytime a new category is added or the input box is toggled,
	the list will be regenerated to provide the most updated data.

	Doing modifications and adding categories and items will only alter the data stored
	in the local restaurant file. All data will be sent to the server when the
	"update" button is clicked.

	For every input box in the system, date will be validated locally before sending to server.
	
	When trying to redirect using the header bar, client will cleck if all input boxes match
	the original value, or if any new data are stored locally.
	If so, client will send a confirm message to user to prevent accidentally wiping
	unsaved data.