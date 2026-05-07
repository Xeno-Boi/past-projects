const express = require('express');
let router = express.Router();

module.exports = function(userModel, renderWithHeader, sessionLoggedIn) {
    router.get("/", function(req, res) {
        renderWithHeader(req, res, "./users/users.pug", {}, 200);
    })

    router.get("/results", function(req, res) {
        let username = "";
        if (Object.keys(req.query).includes("username")) {
            username = req.query.username;
        }
        userModel.find(function(err, result) {
                renderWithHeader(req, res, "./users/results/results.pug", { results: result }, 200);
            }).where({ username: { $regex: username, $options: "i" } })
            .where("privacy").equals(false);
    })

    router.get("/:username", function(req, res) {
        userModel.findOne(function(err, result) { // fetch record that matches given username
            if (result == null) { // username is not valid
                res.redirect("../../notfound");
            } else { // username is valid
                let loggedIn = false;
                let ownsProfile = false;
                // check for login
                let login = sessionLoggedIn(req);
                login.then(function(loginResult) {
                    if (loginResult) { // logged in
                        loggedIn = true;
                        if (req.params.username == req.session.username) { // client owns profile
                            ownsProfile = true;
                        } else {
                            ownsProfile = false;
                        }
                    } else { // not logged in
                        loggedIn = false;
                        ownsProfile = false;
                    }
                    if (result["privacy"] && !ownsProfile) { // profile is private and client doesn't own profile
                        res.redirect("/forbidden");
                    } else {
                        res.status(200).render("./users/profile/profile.pug", { user: result, loggedIn: loggedIn, ownsProfile: ownsProfile });
                    }
                })
            }
        }).where("username").equals(req.params.username);
    })

    router.put("/setPublic", function(req, res) {
        let loggedIn = sessionLoggedIn(req);
        loggedIn.then(function(loginResult) {
            if (loginResult) { // logged in
                userModel.findOneAndUpdate({ "username": req.session.username }, { "privacy": false }, { new: true }, function() {
                    res.end();
                });

            } else { // not logged in
                res.status(403).end();
            }
        })
    })

    router.put("/setPrivate", function(req, res) {
        let loggedIn = sessionLoggedIn(req);
        loggedIn.then(function(loginResult) {
            if (loginResult) { // logged in
                userModel.findOneAndUpdate({ "username": req.session.username }, { "privacy": true }, { new: true }, function() {
                    res.end();
                });

            } else { // not logged in
                res.status(403).end();
            }
        })
    })

    return router;
}