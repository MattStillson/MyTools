function messageHandler(e) {
    // importScripts accepts a comma-separated 
    // list of file paths for loading multiple files
    importScripts("fib-library.js");
    if (e.data > 0) {
        generateFibonacciSeries(e.data);
    }
}

addEventListener("message", messageHandler, true);