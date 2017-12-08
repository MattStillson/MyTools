var getDieRoll = function(dieSize) {
	var result = Math.ceil(dieSize * Math.random());
	return result;
};

var showResult = function(){
	console.log(firstDie);
	console.log(secondDie);
	console.log(firstDie + secondDie);
};

var firstDie = getDieRoll(10);
var secondDie = getDieRoll(10);
showResult();