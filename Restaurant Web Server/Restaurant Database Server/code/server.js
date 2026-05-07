const express = require("express");
const session = require("express-session");
const fs = require("fs");
const mongoose = require("mongoose");

let app = express();
app.set("view engine", "pug");
app.use(session({
    secret: "secret key",
    resave: true,
    saveUninitialized: true,
    username: null,
    password: null
}));

// variables
let restaurants = {}; // to store list of restaurants

let files = fs.readdirSync('./restaurants'); // read all files from /restaurants
files.forEach(file => {
    if (file.endsWith('.json')) { // if the file is a json
        let r = require('./restaurants/' + file);
        restaurants[r.name] = r;
    }
})

// mongoose model
let userSchema = mongoose.Schema({
    username: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    privacy: {
        type: Boolean,
        required: true
    },
    orders: {
        type: Array,
        required: true
    }
});
let userModel = mongoose.model("users", userSchema);

let orderSchema = mongoose.Schema({
    cart: {
        type: Object,
        required: true
    },
    restaurant: {
        type: String,
        required: true
    },
    subtotal: {
        type: Number,
        required: true
    },
    total: {
        type: Number,
        required: true
    },
    username: {
        type: String,
        required: true
    }
});
let orderModel = mongoose.model("orders", orderSchema);

// static files
app.use(express.static("scripts"));
app.use(express.static("styles"));
app.use(express.static("resource"));
app.use(express.json());

// routers
const userRouter = require("./router/userRouter.js")(userModel, renderWithHeader, sessionLoggedIn);

// routes
app.use("/users", userRouter);

// home
app.get("/", function(req, res) {
    res.redirect("/home");
})
app.get("/home", function(req, res) {
    renderWithHeader(req, res, "./home/home", {}, 200);
})

// orderform
app.get("/orderform", function(req, res) {
    renderForbiddenPage(req, res, "./orderform/orderform.pug", {}, "/loginpage");
})
app.post("/submitOrder", function(req, res) {
    let loggedIn = sessionLoggedIn(req);
    loggedIn.then(function(result) {
        if (result) { // logged in
            let order = req.body;
            saveOrder(req, res, order);
        } else {
            res.status(403).end();
        }
    })
})
app.get("/restaurantList", function(req, res) {
    res.json(Object.keys(restaurants));
})
app.get("/restaurant/:restaurant", function(req, res) {
    res.json(restaurants[req.params.restaurant]);
})

// user profile
app.get("/profile", function(req, res) {
    let loggedIn = sessionLoggedIn(req);
    loggedIn.then(function(result) {
        if (result) { // logged in
            res.redirect("/users/" + req.session.username)
        } else { // not logged in
            res.redirect("/loginpage");
        }
    })
})

// order info
app.get("/orders/:orderID", function(req, res) {
    orderModel.findById(req.params.orderID, function(err, order) {
        if (order == null) { // not found
            res.redirect("/notfound");
        } else { // found
            userModel.findOne(function(err, user) {
                if (err) throw err;
                if (user.privacy) { // belongs to private account
                    let loggedIn = sessionLoggedIn(req);
                    loggedIn.then(function(loggedIn) {
                        if (loggedIn) { // logged in
                            if (req.session.username == order.username) { // owns order
                                renderWithHeader(req, res, "./orders/orders.pug", { order: order, restaurant: restaurants[order.restaurant] }, 200);
                            } else { // doesn't own order
                                res.redirect("/forbidden");
                            }
                        } else { // not logged in
                            res.redirect("/forbidden");
                        }
                    })
                } else { // belongs to public account
                    renderWithHeader(req, res, "./orders/orders.pug", { order: order, restaurant: restaurants[order.restaurant] }, 200);
                }
            }).where("username").equals(order.username);
        }
    });
})

// login / logout
app.get("/loginpage", function(req, res) {
    renderWithHeader(req, res, "./login/loginpage.pug", {}, 200);
})
app.post("/login", function(req, res) {
    loggedIn = login(req.body.username, req.body.password);
    loggedIn.then(function(result) {
        if (result) { // logged in
            req.session.username = req.body.username;
            req.session.password = req.body.password;
            res.end("success");
        } else { // not logged in
            res.end("failed");
        }
    })
})
app.post("/logout", function(req, res) {
    logout(req);
    res.end();
})

// register
app.get("/register", function(req, res) {
    renderWithHeader(req, res, "register/register.pug", {}, 200);
})
app.post("/register", function(req, res) {
    if (!Object.keys(req.body).includes("username") || !Object.keys(req.body).includes("password")) { // data not valid
        res.status(400).end("invalid");
    } else { // data is valid
        userModel.findOne(function(err, results) {
            if (results == null) { // unique username
                let newRecord = new userModel({
                    "username": req.body.username,
                    "password": req.body.password,
                    "privacy": false,
                    "orders": [],
                })
                newRecord.save(function(err) {
                    if (err) throw err;
                })
                req.session.username = req.body.username;
                req.session.password = req.body.password;
                res.status(200).end("success");
            } else { // username not unique
                res.status(200).end("failed");
            }
        }).where("username").equals(req.body.username);
    }
})

// error pages
app.get("/forbidden", function(req, res) {
    renderWithHeader(req, res, "./errors/forbidden.pug", {}, 403);
})
app.get("/notfound", function(req, res) {
    renderWithHeader(req, res, "./errors/notfound.pug", {}, 404);
})
app.use("/", function(req, res) {
    res.redirect("/notfound");
})

// functions
/**
 * checks if a set of username and password is correct
 */
async function login(username, password) {
    let result = await userModel.findOne()
        .where("username").equals(username)
        .where("password").equals(password);
    if (result == null) {
        return false;
    } else {
        return true;
    }
}
/**
 * checks if a session is logged in
 */
async function sessionLoggedIn(req) {
    let loggedIn = await login(req.session.username, req.session.password);
    return loggedIn;
}

/**
 * removes username and password from session
 */
function logout(req) {
    req.session.username = null;
    req.session.password = null;
}

/**
 * renders a page with given header
 * checks if a client is logged in
 * waits for async function to finish running
 */
function renderWithHeader(req, res, url, input, status) {
    let loggedIn = sessionLoggedIn(req);
    loggedIn.then(function(result) {
        input.loggedIn = result;
        res.status(status).render(url, input);
    })
}

/**
 * render forbidden pages that requires login
 * if not logged in, redirects to destURl
 */
function renderForbiddenPage(req, res, sourceURL, input, destURL) {
    let loggedIn = sessionLoggedIn(req);
    loggedIn.then(function(result) {
        if (result) { // logged in
            input.loggedIn = true;
            res.status(200).render(sourceURL, input);
        } else { // not logged in
            res.redirect(destURL);
        }
    })
}

/**
 * saves an order to database
 * and update a user record
 */
function saveOrder(req, res, order) {
    // rearrange items in cart to categories
    Object.keys(order["cart"]).forEach(item => {
        // get category of item
        let category = order["cart"][item]["c"];
        delete order["cart"][item]["c"];
        // create category in order if needed
        if (!(category in order["cart"])) {
            order["cart"][category] = {};
        }
        // save item it category
        order["cart"][category][item] = order["cart"][item];
        delete order["cart"][item];
    })
    order["username"] = req.session.username;

    let newOrder = new orderModel(order);
    // save order record
    newOrder.save(function(err, newOrder) {
        if (err) throw err;
        // update user record
        userModel.findOneAndUpdate({ "username": req.session.username }, { $push: { "orders": newOrder.id } },
            function() {
                res.end();
            });
    })
}

// Initiate server
mongoose.connect("mongodb://localhost:27017/a4");
let db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    app.listen(3000);
    console.log("Server listening at http://localhost:3000");
});