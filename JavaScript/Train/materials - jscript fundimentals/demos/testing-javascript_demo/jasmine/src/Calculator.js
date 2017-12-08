function Calculator() {
}

Calculator.prototype.add = function() {
	var total = 0;
	for (var i=0; i<arguments.length; i++) {
		total += arguments[i];
	}
	return total;
};
