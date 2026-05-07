let restaurant_A = {
    name: "Aragorn's Orc BBQ", //The name of the restaurant
    min_order: 20, //The minimum order amount required to place an order
    delivery_charge: 5, //The delivery charge for this restaurant
    //The menu
    menu: {
        //First category
        "Appetizers": {
            //First item of this category
            0: {
                name: "Orc feet",
                description: "Seasoned and grilled over an open flame.", //
                price: 5.50
            },
            1: {
                name: "Pickled Orc fingers",
                description: "Served with warm bread, 5 per order.",
                price: 4.00
            },
            2: { //Thank you Kiratchii
                name: "Sauron's Lava Soup",
                description: "It's just really spicy water.",
                price: 7.50
            },
            3: {
                name: "Eowyn's (In)Famous Stew",
                description: "Bet you can't eat it all.",
                price: 0.50
            },
            4: {
                name: "The 9 rings of men.",
                description: "The finest of onion rings served with 9 different dipping sauces.",
                price: 14.50
            }
        },
        "Combos": {
            5: {
                name: "Buying the Farm",
                description: "An arm and a leg, a side of cheek meat, and a buttered biscuit.",
                price: 15.99
            },
            6: {
                name: "The Black Gate Box",
                description: "Lots of unidentified pieces. Serves 50.",
                price: 65.00
            },
            7: { //Thanks to M_Sabeyon
                name: "Mount Doom Roast Special with Side of Precious Onion Rings.",
                description: "Smeagol's favorite.",
                price: 15.75
            },
            8: { //Thanks Shar[TA]
                name: "Morgoth's Scorched Burgers with Chips",
                description: "Blackened beyond recognition.",
                price: 13.33

            },
            10: {
                name: "Slab of Lurtz Meat with Greens.",
                description: "Get it while supplies last.",
                price: 17.50
            },
            11: {
                name: "Rangers Field Feast.",
                description: "Is it chicken? Is it rabbit? Or...",
                price: 5.99
            }
        },
        "Drinks": {
            12: {
                name: "Orc's Blood Mead",
                description: "It's actually raspberries - Orc's blood would be gross.",
                price: 5.99
            },
            13: {
                name: "Gondorian Grenache",
                description: "A fine rose wine.",
                price: 7.99
            },
            14: {
                name: "Mordor Mourvedre",
                description: "A less-fine rose wine.",
                price: 5.99
            }
        }
    }
};

let restaurant_B = {
    name: "Lembas by Legolas",
    min_order: 15,
    delivery_charge: 3.99,
    menu: {
        "Lembas": {
            0: {
                name: "Single",
                description: "One piece of lembas.",
                price: 3
            },
            1: {
                name: "Double",
                description: "Two pieces of lembas.",
                price: 5.50
            },
            2: {
                name: "Triple",
                description: "Three pieces, which should be more than enough.",
                price: 8.00
            }
        },
        "Combos": {
            3: {
                name: "Second Breakfast",
                description: "Two pieces of lembas with honey.",
                price: 7.50
            },
            4: {
                name: "There and Back Again",
                description: "All you need for a long journey - 6 pieces of lembas, salted pork, and a flagon of wine.",
                price: 25.99
            },
            5: {
                name: "Best Friends Forever",
                description: "Lembas and a heavy stout.",
                price: 6.60
            }
        }
    }
};

let restaurant_C = {
    name: "Frodo's Flapjacks",
    min_order: 35,
    delivery_charge: 6,
    menu: {
        "Breakfast": {
            0: {
                name: "Hobbit Hash",
                description: "Five flapjacks, potatoes, leeks, garlic, cheese.",
                price: 9.00
            },
            1: {
                name: "The Full Flapjack Breakfast",
                description: "Eight flapjacks, two sausages, 3 eggs, 4 slices of bacon, beans, and a coffee.",
                price: 14.00
            },
            2: {
                name: "Southfarthing Slammer",
                description: "15 flapjacks and 2 pints of syrup.",
                price: 12.00
            }

        },
        "Second Breakfast": {
            3: {
                name: "Beorning Breakfast",
                description: "6 flapjacks smothers in honey.",
                price: 7.50
            },
            4: {
                name: "Shire Strawberry Special",
                description: "6 flapjacks and a hearty serving of strawberry jam.",
                price: 8
            },
            5: {
                name: "Buckland Blackberry Breakfast",
                description: "6 flapjacks covered in fresh blackberries. Served with a large side of sausage.",
                price: 14.99
            }
        },
        "Elevenses": {
            6: {
                name: "Lembas",
                description: "Three pieces of traditional Elvish Waybread",
                price: 7.70
            },
            7: {
                name: "Muffins of the Marish",
                description: "A variety of 8 different types of muffins, served with tea.",
                price: 9.00
            },
            8: {
                name: "Hasty Hobbit Hash",
                description: "Potatoes with onions and cheese. Served with coffee.",
                price: 5.00
            }
        },
        "Luncheon": {
            9: {
                name: "Shepherd's Pie",
                description: "A classic. Includes 3 pies.",
                price: 15.99
            },
            10: {
                name: "Roast Pork",
                description: "An entire pig slow-roasted over a fire.",
                price: 27.99
            },
            11: {
                name: "Fish and Chips",
                description: "Fish - fried. Chips - nice and crispy.",
                price: 5.99
            }
        },
        "Afternoon Tea": {
            12: {
                name: "Tea",
                description: "Served with sugar and cream.",
                price: 3
            },
            13: {
                name: "Coffee",
                description: "Served with sugar and cream.",
                price: 3.50
            },
            14: {
                name: "Cookies and Cream",
                description: "A dozen cookies served with a vat of cream.",
                price: 15.99
            },
            15: {
                name: "Mixed Berry Pie",
                description: "Fresh baked daily.",
                price: 7.00
            }
        },
        "Dinner": {
            16: {
                name: "Po-ta-to Platter",
                description: "Boiled. Mashed. Stuck in a stew.",
                price: 6
            },
            17: {
                name: "Bree and Apple",
                description: "One wheel of brie with slices of apple.",
                price: 7.99
            },
            18: {
                name: "Maggot's Mushroom Mashup",
                description: "It sounds disgusting, but its pretty good",
                price: 6.50
            },
            19: {
                name: "Fresh Baked Bread",
                description: "A whole loaf of the finest bread the Shire has to offer.",
                price: 6
            },
            20: {
                name: "Pint of Ale",
                description: "Yes, it comes in pints.",
                price: 5
            }
        },
        "Supper": {
            21: {
                name: "Sausage Sandwich",
                description: "Six whole sausages served on a loaf of bread. Covered in onions, mushrooms and gravy.",
                price: 15.99
            },
            22: {
                name: "Shire Supper",
                description: "End the day as you started it, with a dozen flapjacks, 5 eggs, 3 sausages, 7 pieces of bacon, and a pint of ale.",
                price: 37.99
            }
        }
    }
};

// variables

let restaurants = [restaurant_A, restaurant_B, restaurant_C];
let r; // target restaurant
let rName = ""; // name of restaurant
let mFee = 0; // minimum order fee
let dFee = 0; // delivery fee
let cart = {}; // stores item in cart with id, quantity and category


// functions

/**
 * main
 */
function init() {
    renderDbox();
}

/**
 * renders the dropdown box
 */
function renderDbox() {
    let temp = "";
    for (let i = 0; i < restaurants.length; i++) {
        temp += '<button onclick="toggleR(' + i + ');">' + restaurants[i].name + '</button>';
    }
    document.getElementById("dbox").innerHTML = temp;

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
    console.log(r);
    console.log(r != restaurants[i]);
    if (r != restaurants[i]) { // restaurant chosen is not same as currently rendered
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
 * render the page for an item
 * @param {int} i - the index from list which holds the restaurant to render
 */
function render(i) {
    r = restaurants[i];
    renderInfo();
    renderCategories();
    renderMenu();
    renderCheckout();
}

/**
 * render the information box
 */
function renderInfo() {
    rName = r.name;
    mFee = r.min_order;
    dFee = r.delivery_charge;
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
    for (let i of Object.keys(r.menu)) {
        temp += '<li><a href="#' + i + '">' + i + '</a></li>'; // hyperlinks
    }
    document.getElementById("categories").innerHTML = temp;
}

/**
 * render the menu
 */
function renderMenu() {
    let temp = '<li class="title"><strong>menu</strong></li><br>';
    for (let i of Object.keys(r.menu)) { // caegories
        temp += '<div id="' + i + '">';
        temp += '<li><strong>' + i + '</strong></li><br>';
        for (let j of Object.keys(r.menu[i])) { // items
            temp += '<li>' + r.menu[i][j].name + ' ($' + r.menu[i][j].price.toFixed(2) + ')'; // name and price
            temp += '<input class="add" type="image" src="add.png" alt="add" onclick="addToCart(\'' + j + '\',\'' + i + '\');"></input><br>'; // add button
            temp += r.menu[i][j].description; // description
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
        temp += '<li>' + r.menu[cart[i].c][i].name + ' x ' + cart[i].q + ' (' + (cart[i].q * r.menu[cart[i].c][i].price) + ')'; // name quantity and price
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
        cart[i] = { q: 1, c: cat };
    } else { // add quantity
        cart[i].q += 1;
    }
    renderCheckout(r);
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
    renderCheckout(r);
}

/**
 * calculated the sum of every item in cart
 * @returns the sum of every item in cart
 */
function sumCart() {
    sum = 0;
    for (let i of Object.keys(cart)) {
        sum += (cart[i].q * r.menu[cart[i].c][i].price); // quantity * price
    }
    return sum;
}

/**
 * resets the page
 */
function resetPage() {
    // reset variables
    cart = {}; // clears cart;
    r = undefined; // reset target restaurant
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
        alert("Order Placed!");
        resetPage();
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