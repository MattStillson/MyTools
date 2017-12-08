
function messageHandler(e) {
    var args = e.data;
    if (args.Command === "start") {
        args.Message = "Your value is: " + args.Value;
        postMessage(args);
    }
}

addEventListener("message", messageHandler, true);