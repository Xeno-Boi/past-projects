function setPublic() {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            location.reload();
        }
    }
    xhttp.open("PUT", "/users/setpublic", "true");
    xhttp.send();
}

function setPrivate() {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            location.reload();
        }
    }
    xhttp.open("PUT", "/users/setprivate", "true");
    xhttp.send();
}