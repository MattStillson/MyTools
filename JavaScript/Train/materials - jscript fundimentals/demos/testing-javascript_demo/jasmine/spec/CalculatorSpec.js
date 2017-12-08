describe("Calculator", function() {
	var calculator;
	
	beforeEach(function() {
		calculator = new Calculator();
	});
	
	describe("when adding positive numbers", function() {
		var firstNum, secondNum;
		
		beforeEach(function() {
			firstNum = 14;
			secondNum = 54;			
		});
		
		it("should calculate the correct result", function() {
			var result = calculator.add(firstNum, secondNum);
			expect(result).toEqual(68);
		});
	});
	
	describe("when adding positive and negative numbers", function() {
		var firstNum, secondNum, thirdNum;
		
		beforeEach(function() {
			firstNum = 14;
			secondNum = 54;		
			thirdNum = -769;		
		});
		
		it("should calculate the correct result", function() {
			var result = calculator.add(firstNum, secondNum, thirdNum);
			expect(result).toEqual(-701);
		});
	});


});