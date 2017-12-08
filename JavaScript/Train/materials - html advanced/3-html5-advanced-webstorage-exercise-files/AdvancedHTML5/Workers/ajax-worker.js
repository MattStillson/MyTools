
function messageHandler(e) {
    if (e.data === "fetch") {
        fetchContent();
    }
}

function fetchContent() {
    var xmlhttp;

    if (XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();
    }
    else {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            postMessage(xmlhttp.responseText);
        }
    }

    xmlhttp.open("GET", "ajax-content.htm", true);
    xmlhttp.send();
}

addEventListener("message", messageHandler, true);