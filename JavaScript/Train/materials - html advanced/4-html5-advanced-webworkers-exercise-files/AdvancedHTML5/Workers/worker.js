var intervalId = 0;
var i = 10000000001;
var root;
var response = { Message: "", Root: 0 };
var responseString;

function messageHandler(e) {
    if (e.data === "start") {
        run("start");
    } else if (e.data === "pause") {
        clearInterval(intervalId);
    }
}

function run(message) {
    try {
        intervalId = setInterval(function () {
            response.Root = Math.sqrt(i -= 100000);
            responseString = JSON.stringify(response);
            postMessage(responseString);
        }, 10);
    } catch (e) {
        clearInterval(intervalId);
        postMessage(e.Message);
    }
}

addEventListener("message", messageHandler, true);