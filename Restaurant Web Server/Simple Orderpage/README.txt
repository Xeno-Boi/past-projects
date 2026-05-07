Simple Orderpage
Author: Honam Leung (101197127)
September, 2021

Description:
	A simple restaurant order page.

To Run:
	- Execute "code/order.html"

Files:
	- order.html
	- orderStyle.css
	- client.js
	- add.png
	- remove.png


Function design:

	When the website loads, a list of available restaurants will be created and stored in the dropdown list.
	When a restaurant is chosen, it's index will be passed to the function and the chosen restaurant will be stored inside a variable.
	Then the website renders the page with that variable.

	Following information is calculated and stored as variables for easy computation in the future.
		- name of restaurant
		- minimum order
		- delivery fee

	Cart is an object tjat stores items that are chosen by the user.
		- It saves item via it's id as key.
		- It saves the item's quantity and category in an object as the value.

	Add function takes the category of the object so that it can be stored in cart.
	Stored categories helps script to find the object from the restaurant object easier.

	The page will either show a submit button or a warning message stating how much more the user need to choose before submitting.
	
	When submitting, a pop-up window will be shown to verify the action. After submittion, the page will be reset.

	When changing restaurants, the system will check for items in cart.
	If it is not empty, system will ask the user to confirm.
	Then it will empty cart and render new page.

	A go-to-top button and a checkout button is set to help users navigate the website with ease.