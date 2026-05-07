// variables
let restaurant = {};
let id = 0;
let modified = false;

/**
 * get the restaurant object from server and find the max id
 */
function init() {
    let temp = window.location.href.split("#")[0].split("/");
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            restaurant = JSON.parse(xhttp.responseText);
            id = findMaxId(restaurant);
        }
    }
    xhttp.open("GET", "/restaurants/" + temp[temp.length - 1]);
    xhttp.setRequestHeader("Content-Type", "application/json");
    xhttp.send();
}

/**
 * finds the largest id in a restaurant object 
 * @returns the largest id
 */
function findMaxId(restaurant) {
    let id = 0;
    for (let c in restaurant["menu"]) { // for every category
        for (let i in restaurant["menu"][c]) { // for every id in category
            if (parseInt(i) > id) {
                id = parseInt(i);
            }
        }
    }
    return id + 1;
}

/**
 * submits the updated restaurant object to server
 */
function submit() {
    if (updateRestaurantInfo()) {
        let temp = window.location.href.split("#")[0].split("/");
        let xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                alert("success");
                window.location.reload();
            }
        }
        xhttp.open("PUT", "/restaurants/" + temp[temp.length - 1]);
        xhttp.setRequestHeader("Content-Type", "application/json");
        xhttp.send(JSON.stringify(restaurant));
    }
}

/**
 * checks for valid input and update restaurant information in object
 */
function updateRestaurantInfo() {
    let rName = document.getElementById("rName").value;
    let mFee = restaurant["min_order"];
    let dFee = restaurant["delivery_fee"];
    let error = "Error!\n";
    if (document.getElementById("mFee").value != "") {
        mFee = parseFloat(document.getElementById("mFee").value);
    }
    if (document.getElementById("dFee").value != "") {
        dFee = parseFloat(document.getElementById("dFee").value);
    }
    if (rName.trim() == "") {
        error += "Restaurant Name is invalid\n";
    }
    if (isNaN(mFee)) {
        error += "Minimum Order is invalid!\n";
    }
    if (isNaN(dFee)) {
        error += "Delivery Fee is invalid!\n";
    }
    if (error == "Error!\n") { // all input are valid
        restaurant["name"] = rName;
        restaurant["min_order"] = mFee;
        restaurant["delivery_fee"] = dFee;
        return true;
    } else {
        alert(error);
        return false;
    }
}

/**
 * toggles input box
 * @param {string} id of box to toggle
 */
function showBox(id) {
    document.getElementById(id).classList.toggle("show");
    if (id == "iBox") {
        renderIbox();
    }
}

/**
 * checks for dublicate and update the object and page with new category
 */
function addCategory() {
    let input = document.getElementById("cName").value;
    if (Object.keys(restaurant["menu"]).includes(input)) {
        // category already exist
        alert("Category alreaty exist!\nPlease enter a unique category!");
    } else {
        // update object
        restaurant["menu"][input] = {};
        // update html
        let newC = document.createElement("li");
        let strong = document.createElement("strong");
        strong.innerHTML = input;
        newC.appendChild(strong);
        newC.innerHTML += "<br>";
        let ul = document.createElement("ul");
        ul.setAttribute('id', input);
        newC.appendChild(ul);
        newC.innerHTML += "<hr>";
        document.getElementById("menu").appendChild(newC);
        renderIbox();
        modified = true;
        // reset input box
        document.getElementById("cName").value = "";
        showBox('cBox');
    }
}

/**
 * renders drop down box with updated categories
 */
function renderIbox() {
    let first = document.getElementById("first");
    // remove original drop down list
    first.removeChild(document.getElementById("ddList"));
    // create new drop down list
    let ddList = document.createElement("select");
    ddList.setAttribute("id", "ddList");
    for (let category of Object.keys(restaurant["menu"])) {
        let option = document.createElement("option");
        option.innerHTML = category;
        option.setAttribute("value", category);
        ddList.appendChild(option);
    }
    first.appendChild(ddList);
}

/**
 * update object and page with new item
 */
function addItem() {
    let category = document.getElementById("ddList").value;
    let itemName = document.getElementById("iName").value;
    let description = document.getElementById("description").value;
    let price = parseFloat(document.getElementById("price").value);
    let error = "Error!\n";
    if (itemName.trim() == "") {
        error += "Item Name can't be empty!\n";
    }
    if (description.trim() == "") {
        error += "Description can't be empty!\n";
    }
    if (isNaN(price)) {
        error += "Price must be a number!\n";
    }
    if (error == "Error!\n") { // input is valid
        // update restaurant object
        restaurant["menu"][category][id.toString()] = { "name": itemName, "description": description, "price": price };
        id++;
        // update page

        // item list
        let itemUl = document.createElement("ul");
        // item id
        let item = document.createElement("li");
        let strong = document.createElement("strong");
        strong.innerText = "Id: " + (id - 1).toString();
        item.appendChild(strong);
        itemUl.appendChild(item);
        // item name
        item = document.createElement("li");
        item.innerText = "Name: " + itemName;
        itemUl.appendChild(item);
        // description
        item = document.createElement("li");
        item.innerText = "Description: " + description;
        itemUl.appendChild(item);
        // price
        item = document.createElement("li");
        item.innerText = "Price: $ " + price.toFixed(2).toString();
        itemUl.appendChild(item);

        // li in category list
        let li = document.createElement("li");
        li.setAttribute("class", "left");
        li.appendChild(itemUl);

        // category list
        let c = document.getElementById(category);
        c.appendChild(li);
        modified = true;
        // reset input box
        document.getElementById("iName").value = "";
        document.getElementById("description").value = "";
        document.getElementById("price").value = "";
        showBox('iBox');
    } else {
        alert(error);
    }
}

/**
 * confirm if to remove unsaved data
 */
function confirmation() {
    if (document.getElementById("rName").value != restaurant["name"] || document.getElementById("mFee").value != restaurant["min_order"] || document.getElementById("dFee").value != restaurant["delivery_fee"]) {
        modified = true;
    }
    if (modified) {
        return (confirm("Redirecting will remove all unsaved data, are you sure?"));
    } else {
        return true;
    }
}