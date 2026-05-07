/*
Routes:
    / - index with links to other pages
*/
const http = require("http");
const pug = require("pug");
const fs = require("fs");

// variables
let stat = {}; // statics of restaurants
let restaurants = {}; // to store list of restaurants

let files = fs.readdirSync('./restaurants'); // read all files from /restaurants
files.forEach(file => {
    if (file.endsWith('.json')) { // if the file is a json
        let r = require('./restaurants/' + file);
        restaurants[r.name] = r;
    }
})

for (let i in restaurants) { // initialize stat object for every restaurant
    stat[i] = { orders: {}, count: 0, total: 0 };
}

// Initiate server
const server = http.createServer(function(request, response) {
    if (request.method === "GET") {
        if (request.url === "/") {
            fs.readFile("./page/home/index.html", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "text/html");
                response.end(data);
            })
        } else if (request.url === "/orderform") {
            fs.readFile("./page/order/orderform.html", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                    return;
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "text/html");
                response.end(data);
            })
        } else if (request.url === "/orderStyle.css") {
            fs.readFile("./page/order/orderStyle.css", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                    return;
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "text/css");
                response.end(data);
            })
        } else if (request.url === "/client.js") {
            fs.readFile("./page/order/client.js", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                    return;
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "application/javascript");
                response.end(data);
            })
        } else if (request.url === "/add.png") {
            fs.readFile("./page/order/add.png", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                    return;
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "image/png");
                response.end(data);
            })
        } else if (request.url === "/remove.png") {
            fs.readFile("./page/order/remove.png", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                    return;
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "image/png");
                response.end(data);
            })
        } else if (request.url === "/indexStyles.css") {
            fs.readFile("page/home/indexStyles.css", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "text/css");
                response.end(data);
            })
        } else if (request.url === "/restaurantList") {
            response.statusCode = 200;
            response.setHeader("Content-Type", "application/json");
            response.end(JSON.stringify(Object.keys(restaurants)));
        } else if (request.url.startsWith("/restaurant/")) {
            let url = request.url.split("/");
            response.statusCode = 200;
            response.setHeader("Content-Type", "application/json");
            response.end(JSON.stringify(restaurants[url[2].replace(/%20/g, " ")])); // replacing %20 with space
        } else if (request.url === "/statpage") {
            let render = {}; // data to be rendered
            for (let i in stat) {
                render[i] = {} // an object for each restaurant
                render[i].count = stat[i].count;

                if (stat[i].count == 0) {
                    render[i].average = (0).toFixed(2);
                } else {
                    render[i].average = (stat[i].total / stat[i].count).toFixed(2);
                }

                let item = "None"; // to store the best seller
                let max = 0; // amounts of items sold
                for (let j in stat[i].orders) {
                    if (stat[i].orders[j] > max) {
                        item = j
                        max = stat[i].orders[j];
                    }
                }
                render[i].bestSeller = item;
            }
            data = pug.renderFile('./page/stat/stat.pug', { stat: render });
            response.statusCode = 200;
            response.end(data);
        } else if (request.url === "/statStyle.css") {
            fs.readFile("./page/stat/statStyle.css", function(err, data) {
                if (err) {
                    response.statusCode = 500;
                    response.end("Server error.");
                    return;
                }
                response.statusCode = 200;
                response.setHeader("Content-Type", "text/css");
                response.end(data);
            })
        } else {
            response.statusCode = 404;
            response.end("Unknown Resource");
        }
    } else if (request.method === "POST") {
        if (request.url === "/submitOrder") {
            let data = "";
            request.on('data', (chunk) => {
                data += chunk;
            });
            request.on('end', () => {
                data = JSON.parse(data);
                let targetR = data["restaurant"];
                stat[targetR].total += data["total"]; // sum new total
                stat[targetR].count += 1; // increase order count
                Object.keys(data).forEach(id => {
                    if (id != "total" && id != "restaurant") {
                        if (Object.keys(stat[targetR].orders).includes(data[id]["name"])) { // item exist in orders
                            stat[targetR].orders[data[id]["name"]] += data[id]["q"]; // {item name: quantity}
                        } else { // item does not exist in orders
                            stat[targetR].orders[data[id]["name"]] = data[id]["q"];
                        }
                    }
                })
                response.statusCode = 200;
                response.end();
                return;
            })
        } else {
            response.statusCode = 404;
            response.end("Unknown Resource");
        }
    } else {
        response.statusCode = 404;
        response.end("Unknown Resource");
    }
})

// Start server
server.listen(3000);
console.log("Server listening at http://localhost:3000");