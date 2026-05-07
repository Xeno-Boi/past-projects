/*
Routes:
    / - index with links to other pages
*/
const http = require("http");
const pug = require('pug');
const fs = require("fs");

// create express app
const express = require('express');
let app = express();

// view engine
app.set("view engine", "pug");

// variables
let restaurants = {}; // to store list of restaurants

let files = fs.readdirSync('./restaurants'); // read all files from /restaurants
files.forEach(file => {
    if (file.endsWith('.json')) { // if the file is a json
        let r = require('./restaurants/' + file);
        restaurants[r.id] = r;
    }
})

// set up routers
const restaurantsRoute = require("./routes/restaurants.js")(restaurants);

// routes
app.use(express.static("views/styles")); // handles all css requests
app.use(express.static("views/scripts")); // handles all .js requests
app.get("/", sendIndex);
app.use('/restaurants', restaurantsRoute);
app.get('/addrestaurant', addRestaurant);

// extract data from router
// console.log(restaurantsRoute.test);

/**
 * sends index page
 */
function sendIndex(req, res, next) {
    res.status(200);
    res.sendFile('views/home/index.html', { root: __dirname });
}

/**
 * sends addRestaurant page 
 */
function addRestaurant(req, res, next) {
    res.status(200);
    res.sendFile('views/addRestaurant/addRestaurant.html', { root: __dirname });
}

// Start server
app.listen(3000);
console.log("Server listening at http://localhost:3000");