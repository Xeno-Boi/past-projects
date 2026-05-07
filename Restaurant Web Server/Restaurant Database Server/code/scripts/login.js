document.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        login();
    }
});

function login() {
    let error = "ERROR!\n"
    let username = document.getElementById("username").value;
    let password = document.getElementById("password").value;
    // make sure both fields are entered
    if (username == "") {
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
                    location.reload();
                } else if (xhttp.responseText == "failed") {
                    alert("incorrect username or password");
                } else {
                    alert("login failed");
                }
            }
        }
        xhttp.open("POST", "/login", "true");
        xhttp.setRequestHeader("Content-Type", "application/json");
        xhttp.send(JSON.stringify(body));
    } else {
        alert(error);
    }
}