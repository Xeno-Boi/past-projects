document.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        submit();
    }
});

function submit() {
    let rName = document.getElementById("rName").value;
    let dFee = parseFloat(document.getElementById("dFee").value);
    let mFee = parseFloat(document.getElementById("mFee").value);
    let error = "Error!";
    if (rName.trim() == "") { // rName is empty or contains only space
        error += "\nRestaurant Name cannot be empty!";
    }
    if (isNaN(dFee)) { // dFee is not a number
        error += "\nDelivery Fee must be a number!";
    }
    if (isNaN(mFee)) { // mFee is not a number
        error += "\nMinimum Fee must be a number!";
    }
    if (error != "Error!") { // at least 1 input is invalid
        alert(error);
        return;
    } else {
        let data = { "name": rName, "delivery_fee": dFee, "min_order": mFee };

        // send request
        let xhttp = new XMLHttpRequest();

        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 201) {
                // goes to new restaurant page
                window.location.replace("/restaurants/" + JSON.parse(xhttp.responseText)["id"]);
            } else if (this.status == 404) {
                alert("error");
                return;
            }
        }
        xhttp.open("POST", "/restaurants");
        xhttp.setRequestHeader("Content-Type", "application/json");
        xhttp.send(JSON.stringify(data));
    }
}

/**
 * confirm if to remove unsaved data
 */
function confirmation() {
    let modified = false;
    if (document.getElementById("rName").value != "" || document.getElementById("mFee").value != "" || document.getElementById("dFee").value != "") {
        modified = true;
    }
    if (modified) {
        return (confirm("Redirecting will remove all unsaved data, are you sure?"));
    } else {
        return true;
    }
}