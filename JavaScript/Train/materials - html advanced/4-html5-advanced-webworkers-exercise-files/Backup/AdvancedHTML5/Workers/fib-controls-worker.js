var results = [];

function createNewArgs(message, result) {
    return { Message: message, Result: result };
}

function messageHandler(e) {
    if (e.data.Command === "start") {
        generateFibonacciSeries(e.data.Value);
    }
    
    if (e.data.Command === "close") {
        this.close();
        var args = createNewArgs("Closing worker thread");
        postMessage(args);
    }

    if (e.data.Command === "echo") {
        var args = createNewArgs(e.data.Message);
        postMessage(args);
    }
}

function calculateNextFibonacciValue(n) {
    var s = 0;
    var returnValue;

    if (n == 0) {
        return (s);
    }
    if (n == 1) {
        s += 1;
        return (s);
    }
    else {
        return (calculateNextFibonacciValue(n - 1) + calculateNextFibonacciValue(n - 2));
    }
}

function generateFibonacciSeries(n) {
    results.length = 0;
    for (var i = 0; i <= n-1; i++) {
        results.push(calculateNextFibonacciValue(i));
    }
    var args = createNewArgs("Generated Fibonacci series.", results);
    postMessage(args);
}

this.addEventListener("message", messageHandler, true);