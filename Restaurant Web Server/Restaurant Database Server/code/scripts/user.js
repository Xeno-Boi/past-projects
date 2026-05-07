document.addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
        search();
    }
});

function search() {
    let search = document.getElementById("search").value;
    if (search == "") {
        window.location.pathname = "/users/results";
    } else {
        window.location.href = "/users/results?username=" + search;
    }
}