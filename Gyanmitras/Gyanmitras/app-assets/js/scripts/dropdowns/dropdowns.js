
// Polaris Checkbox & Radio
$('.skin-polaris input').iCheck({
	checkboxClass: 'icheckbox_polaris',
	radioClass: 'iradio_polaris',
	increaseArea: '-10%'
});

// Futurico Checkbox & Radio
$('.skin-futurico input').iCheck({
	checkboxClass: 'icheckbox_futurico',
	radioClass: 'iradio_futurico',
	increaseArea: '20%'
});

// Switchery
	var i = 0;
	if (Array.prototype.forEach) {
		var elems = Array.prototype.slice.call(document.querySelectorAll('.switchery'));

		elems.forEach(function (html) {
			var switchery = new Switchery(html);
		});
	} else {
		var elems1 = document.querySelectorAll('.switchery');

		for (i = 0; i < elems1.length; i++) {
			var switchery = new Switchery(elems1[i]);
		}
	}

	var elemXsmall = document.querySelectorAll('.switchery-xs');
	for (i = 0; i < elemXsmall.length; i++) {
		new Switchery(elemXsmall[i], {className:"switchery switchery-xsmall"});
	}