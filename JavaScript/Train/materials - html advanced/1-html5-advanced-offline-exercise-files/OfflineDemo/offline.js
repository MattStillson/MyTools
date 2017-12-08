var log;

function logEvent(msg) {
    log.html(log.html() + "<li>" + msg + "</li>");
}

$(function () {

    if (window.applicationCache) {
        log = $("#log");
        if (!document.getElementById("log")) { alert("An event log container is required.") }

        window.applicationCache.onchecking = function (e) {
            logEvent("Checking cache");
        }

        window.applicationCache.oncached = function (e) {
            logEvent("Cached");
        }

        window.applicationCache.onnoupdate = function (e) {
            logEvent("No Update");
        }

        window.applicationCache.onobsolete = function (e) {
            logEvent("Obsolete");
        }

        window.applicationCache.ondownloading = function (e) {
            logEvent("Downloading");
        }

        window.applicationCache.onerror = function (e) {
            logEvent("Error");
        }

        logEvent("Window Load");
    }
});