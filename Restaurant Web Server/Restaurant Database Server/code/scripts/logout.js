function logout() {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            if (window.location.pathname == "/orderform" || window.location.pathname.startsWith("/users/")) {
                location.replace("/home");
            } else {
                location.reload();
            }
        }
    }
    xhttp.open("POST", "/logout", "true");
    xhttp.send();
}