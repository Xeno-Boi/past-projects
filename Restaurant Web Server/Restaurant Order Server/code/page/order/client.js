// variables

let rList = []; // list of restaurants
let restaurant = {}; // target restaurant
let rName = ""; // name of restaurant
let mFee = 0; // minimum order fee
let dFee = 0; // delivery fee
let cart = {}; // stores item in cart with id, quantity and category


// functions

/**
 * main
 */
function init() {
    // request list of restaurants
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            rList = JSON.parse(xhttp.responseText);
            renderDbox();
        }
    }
    xhttp.open("GET", "/restaurantList");
    xhttp.send();
}

/**
 * renders the dropdown box
 */
function renderDbox() {
    // render drop box
    for (let i = 0; i < rList.length; i++) {
        let temp = document.createElement("BUTTON");
        temp.setAttribute("onclick", 'toggleR(' + i + ');');
        temp.innerHTML = rList[i];
        document.getElementById("dbox").appendChild(temp);
    }
}

/**
 * toggles dropbox
 */
function showDD() {
    document.getElementById("dbox").classList.toggle("drop");
}

/**
 * closes dropbox when mouse clicks elsewhere
 */
window.onclick = function(event) {
    if (!event.target.matches('.selectR')) {
        document.getElementById("dbox").classList.remove("drop");
    }
}

/**
 * confirm render and clears cart
 * @param {int} i - the index from list which holds the restaurant to render
 */
function toggleR(i) {
    if (restaurant == {} || restaurant.name != rList[i]) { // restaurant chosen is not same as currently rendered
        if (!Object.keys(cart).length == 0) { // cart is not empty
            if (confirm('All items from cart will be removed. Do you wish to continue?')) { // user chooses yes
                cart = {}; // clears cart
                render(i);
            }
        } else { // cart is empty
            render(i);
        }
    }
}

/**
 * confirm to reload page
 * @returns true - user selects yes
 *          false - user selects no
 */
function confirmation() {
    if (!Object.keys(cart).length == 0) { // cart is not empty
        return confirm('All items from cart will be removed. Do you wish to continue?');
    } else { // cart is empty
        return true;
    }
}

/**
 * render the page for an item
 * @param {int} i - the index from list which holds the restaurant to render
 */
function render(i) {
    // request for the target restaurant
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            // save restaurant as json
            restaurant = JSON.parse(xhttp.responseText);
            // render
            renderInfo();
            renderCategories();
            renderMenu();
            renderCheckout();
        }
    }
    xhttp.open("GET", "/restaurant/" + rList[i]);
    xhttp.send();
}

/**
 * render the information box
 */
function renderInfo() {
    rName = restaurant.name;
    mFee = restaurant.min_order;
    dFee = restaurant.delivery_fee;

    // update html
    document.getElementById("rName").innerHTML = rName;
    document.getElementById("mFee").innerHTML = mFee.toFixed(2);
    document.getElementById("dFee").innerHTML = dFee.toFixed(2);
}

/**
 * render the categories list
 */
function renderCategories() {
    let temp = '<li class="title"><strong>categories</strong></li><br>';
    for (let i of Object.keys(restaurant.menu)) {
        temp += '<li><a href="#' + i + '">' + i + '</a></li>'; // hyperlinks
    }
    document.getElementById("categories").innerHTML = temp;
}

/**
 * render the menu
 */
function renderMenu() {
    let temp = '<li class="title"><strong>menu</strong></li><br>';
    for (let i of Object.keys(restaurant.menu)) { // caegories
        temp += '<div id="' + i + '">';
        temp += '<li><strong>' + i + '</strong></li><br>';
        for (let j of Object.keys(restaurant.menu[i])) { // items
            temp += '<li>' + restaurant.menu[i][j].name + ' ($' + restaurant.menu[i][j].price.toFixed(2) + ')'; // name and price
            temp += '<input class="add" type="image" src="add.png" alt="add" onclick="addToCart(\'' + j + '\',\'' + i + '\');"></input><br>'; // add button
            temp += restaurant.menu[i][j].description; // description
            temp += '<br><br></li>';
        }
        temp += '</div><br>';
    }
    document.getElementById("menu").innerHTML = temp;
}

/**
 * renders Checkout box
 */
function renderCheckout() {
    renderCart();
    document.getElementById("subtotal").innerHTML = sumCart().toFixed(2); // subtotal
    document.getElementById("tax").innerHTML = (sumCart() * 0.1).toFixed(2); // tax
    document.getElementById("delivery").innerHTML = dFee.toFixed(2); // delivery
    document.getElementById("total").innerHTML = (sumCart() * 1.1 + dFee).toFixed(2); // total

    if (sumCart().toFixed(2) >= mFee) { // total fee reach minimum order
        showSB();
    } else { // total fee doesn't reach minimum order
        document.getElementById("addMore").innerHTML = (mFee - sumCart()).toFixed(2);
        removeSB();
    }
}

/**
 * renders list of items in checkout
 */
function renderCart() {
    let temp = '';
    for (let i of Object.keys(cart)) {
        temp += '<li>' + restaurant.menu[cart[i].c][i].name + ' x ' + cart[i].q + ' (' + (cart[i].q * restaurant.menu[cart[i].c][i].price) + ')'; // name quantity and price
        temp += '<input class="remove" type="image" src="remove.png" alt="remove" onclick="removeFromCart(\'' + i + '\')"></input></li><br>' // remove button
    }
    document.getElementById("cart").innerHTML = temp;
}

/**
 * add an item to cart
 * @param {string} i - index of item
 * @param {string} cat - category of item
 */
function addToCart(i, cat) {
    if (!(i in cart)) { // add new item
        cart[i] = { q: 1, c: cat }; // q = quantity, c = category
    } else { // add quantity
        cart[i].q += 1;
    }
    renderCheckout(restaurant);
}

/**
 * remove an item from cart
 * @param {string} i - index of item
 */
function removeFromCart(i) {
    if (cart[i].q == 1) { // this is the last item
        delete cart[i];
    } else { // this is not the last item
        cart[i].q -= 1;
    }
    renderCheckout(restaurant);
}

/**
 * calculated the sum of every item in cart
 * @returns the sum of every item in cart
 */
function sumCart() {
    sum = 0;
    for (let i of Object.keys(cart)) {
        sum += (cart[i].q * restaurant.menu[cart[i].c][i].price); // quantity * price
    }
    return sum;
}

/**
 * resets the page
 */
function resetPage() {
    // reset variables
    cart = {}; // clears cart;
    restaurant = {}; // reset target restaurant
    rName = "Select a Restaurant"; // reset name of restaurant
    mFee = 0; // reset minimum order fee
    dFee = 0; // reset delivery fee

    // reset list
    renderCheckout(); // resets checkout box
    document.getElementById("rName").innerHTML = rName; // render info box
    document.getElementById("mFee").innerHTML = mFee.toFixed(2); // render info box
    document.getElementById("dFee").innerHTML = dFee.toFixed(2); // render info box
    document.getElementById("categories").innerHTML = '<li class="title"><strong>categories</strong></li><br>'; // resets categories
    document.getElementById("menu").innerHTML = '<li class="title"><strong>menu</strong></li><br>'; // resets menu
    document.getElementById("submit").classList.remove("drop"); // remove submit button
    document.getElementById("warning").classList.remove("show"); // remove warnings
}

/**
 * submit the order
 */
function submit() {
    if (confirm("Are you sure?")) { // user confirms submittion
        let data = cart;
        Object.keys(data).forEach(id => {
            data[id]["name"] = restaurant.menu[data[id]["c"]][id].name;
        })
        data["total"] = sumCart() * 1.1 + dFee; // [cart, total, restaurant]
        data["restaurant"] = restaurant.name;
        console.log(data);
        let xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4) { // response received
                if (this.status == 200) { // request successful
                    alert("Order Placed!");
                    resetPage();
                } else { // request failed
                    alert("Order Failed! Please try again.");
                    return;
                }
            }
        }
        xhttp.open("POST", "/submitOrder");
        xhttp.send(JSON.stringify(data));

    }
}

/**
 * shows submit button and removes warnings
 */
function showSB() {
    document.getElementById("submit").classList.add("drop");
    document.getElementById("warning").classList.remove("show");
}

/**
 * removes submit button and shows warnings
 */
function removeSB() {
    document.getElementById("submit").classList.remove("drop");
    document.getElementById("warning").classList.add("show");
}