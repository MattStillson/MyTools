	
(function handleClick($) {
	
	var pasteButton = $('input[type=button]');
	pasteButton.click(function pasteButtonClickHandler() {
		var target = $('div#target');
		var input = $('#phrase');
		target.append(input.val());
	});		
	
})(jQuery);