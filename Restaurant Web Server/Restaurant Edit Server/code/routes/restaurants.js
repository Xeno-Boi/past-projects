const express = require('express');
let router = express.Router();

module.exports = function(restaurants) {
    // routes
    router.use(express.json());
    router.get("/", sendRestaurants);
    router.post("/", addRestaurant);
    router.get("/:id", handleID);
    router.put("/:id", updateRestaurant);

    /**
     * sends restaurants list
     */
    function sendRestaurants(req, res, next) {
        if (req.get('Content-Type') == 'application/json') { // if require json
            let output = {};
            output["restaurants"] = Object.keys(restaurants);
            res.json(output);
        } else if (req.accepts('text/html') == 'text/html') { // if require anything that can be translated to html
            res.status(200);
            res.render('restaurants/restaurantsList', { restaurants: restaurants });
        } else {
            res.status(400);
            res.end("Cannot GET /restaurants with Content-Type " + req.get("Content-Type"));
        }
    }

    /**
     * save new restaurant into database
     */
    function addRestaurant(req, res, next) {
        let r = req.body;
        if ("name" in r && "delivery_fee" in r && "min_order" in r && updateHasCorrectType(r)) { // check if everything is in body and has correct datatype
            r.id = 0;
            Object.keys(restaurants).forEach(id => {
                // find max id in database
                if (parseInt(id) > r.id) {
                    r.id = parseInt(id);
                }
            })
            r.id = r.id + 1; // id = max id + 1
            updateToFloat(r);
            r.menu = {};
            restaurants[r.id] = r;
            res.status(201).set("Content-Type", "application/json").end(JSON.stringify(r));
        } else {
            res.status(400).end("incorrect syntax");
        }
    }

    /**
     * datatype checker for addRestaurant 
     */
    function updateHasCorrectType(r) {
        if (r["name"].trim() == "" || isNaN(r["delivery_fee"]) || isNaN(r["min_order"])) {
            return false;
        }
        return true;
    }

    /**
     * converts datatype to float for addRestaurant 
     */
    function updateToFloat(r) {
        r["delivery_fee"] = parseFloat(r["delivery_fee"]);
        r["min_order"] = parseFloat(r["min_order"]);
    }

    /**
     * handles id and send restaurant data 
     */
    function handleID(req, res, next) {
        if (req.params.id in restaurants) { // id exist
            if (req.get("Content-Type") == "application/json") {
                // json
                res.status(200).set("Content-Type", "application/json");
                res.end(JSON.stringify(restaurants[req.params.id]));
            } else if (req.accepts("text/html")) {
                // html
                res.status(200).set("Content-Type", "text/html");
                res.render("restaurantInfo/restaurantInfo", { restaurant: restaurants[req.params.id] });
            } else {
                res.status(415).end("Content-Type unsupported");
            }
        } else {
            res.status(404).end("Restaurant #" + req.params.id + " not found");
        }
    }

    /**
     * updates restaurants using request body 
     */
    function updateRestaurant(req, res, next) {
        if (req.params.id in restaurants) { // id exist
            restaurants[req.params.id] = req.body;
            res.status(200).end("Restaurant #" + req.params.id + "is updated");
        } else {
            res.status(404).end("Restaurant #" + req.params.id + " not found");
        }
    }

    return router;
};