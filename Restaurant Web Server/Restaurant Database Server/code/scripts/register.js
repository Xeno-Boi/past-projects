document.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        register();
    }
});

function register() {
    let error = "ERROR!\n"
    let username = document.getElementById("username").value;
    let password = document.getElementById("password").value;
    // make sure both fields are entered
    if (username.trim() == "") {
        error += "Username can't be empty!\n";
    }
    if (password == "") {
        error += "Password can't be empty!\n";
    }
    if (error == "ERROR!\n") { // no error
        // generate request body
        let body = { "username": username, "password": password };
        // ajax
        let xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                if (xhttp.responseText == "success") {
                    location.replace("/users/" + username);
                } else if (xhttp.responseText == "failed") {
                    alert("Username is already taken");
                } else {
                    alert("register failed");
                }
            }
        }
        xhttp.open("POST", "/register", "true");
        xhttp.setRequestHeader("Content-Type", "application/json");
        xhttp.send(JSON.stringify(body));
    } else {
        alert(error);
    }
}