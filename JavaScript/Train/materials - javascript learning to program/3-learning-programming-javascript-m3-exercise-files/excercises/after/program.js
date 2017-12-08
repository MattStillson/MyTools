var x = 3, 
    y = 2.5;

var z = '3';
var result = x > y;

var writeGreeting = function(name) {
	var message = "Hello, " + name;	
	console.log(message);	
}

writeGreeting("Scott");
writeGreeting("Allen");

var answer = parseInt(z) + y;
console.log(answer);
console.log(typeof answer);

console.log(typeof result);
console.log(typeof y);
console.log(typeof z);
console.log(typeof console);
console.log(typeof console.log);