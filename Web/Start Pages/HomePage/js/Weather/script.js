/*
	Homepage Script
	Shockersify
*/

$(document).ready(function() {
    $('#category').bind('touchstart touchend', function(e) {
        e.preventDefault();
        $(this).toggleClass('hovered');
    });
	/*Put in zip code or weather.com code(if you're not in US)*/
	$('#weather').weatherfeed(['19711'], {
		unit: 'f',
		forecast: true,
		wind: false,
		link: false,
		showerror: false,
		image: false
	});
});

$(window).bind("load", function() {
	$(".icon").each(function() {
		$(this).attr('src','images/weather/' + $(this).parent().css("background-image").substring(45,47) + '.svg');
	});
	$('.weatherForecastItem').css('background-image', 'none');
});
