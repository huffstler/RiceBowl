/**
	Released under MIT License
	
	Copyright (c) 2010 Jukka Svahn
	<http://rahforum.biz>

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

$(document).ready(function(){
	
/**
	Add the extra stuff to the <head>,
	thus make index.html slightly cleaner
*/

	$('head').append(
		'<link rel="stylesheet" type="text/css" media="screen" title="Default" href="library/style.css" />'+
		'<title>New Tab</title>'+
		'<link rel="shortcut icon" href="library/favicon.png" type="image/png" />'
	);

/**
	Get URLs from the document body
*/
	
	var uriString = $('body').text();

/**
	Add top bar and preferences
*/

	$('body').html('<p id="bar"><span class="button" id="shown">Open shown</span><span class="button" id="each">Open all</span><span class="button" id="random">I\'m bored</span></p>');

/**
	If no URLs found,
	display a message/insturctions
*/

	if(!uriString) {
		$('body').html('<div id="message">Start by adding URLs to index.html. Currently you have no URLs defined.</div>');
		return;
	}

/**
	Adds the main content blocks to the page
*/

	$('body').append(
		'<div id="container"></div>'+
		'<p id="pages"></p>'+
		'<form action="http://www.google.com/search" method="get">'+
			'<input type="text" name="q" value="" />'+
			'<button type="submit">Search</button>'+
		'</form>'
	);

/**
	Set focus
*/

	$('input[name="q"]').focus();

/**
	Create array from the uriString
*/

	var uriArray = uriString.split("\n");

/**
	Start going thru the array
*/

	var domains = {};
	var i;
	var count = 0;
	var html = '';
	
	for(i in uriArray) {
		
		var url = jQuery.trim(uriArray[i]);
		
		/*
			If the line is empty,
			skip it
		*/
		
		if(!url)
			continue;
		
		/*
			The line doesn't start with http,
			so it must be a separator that starts
			a new page and adds a heading
		*/
			
		if(url.substr(0,4) != 'http') {
			if(count > 0)
				html = html + '</div>';
			html = html + '<div><h1>'+url+'</h1>';
			count++;
			continue;
		}
		
		/*
			Split the domain name from the URL
		*/
		
		var img = url.split(/\/+/g)[1];
		
		if(img in domains) {
			domains[img]++;
			img = img + '_' + domains[img];
		} else
			domains[img] = 1;
		
		/*
			Ready to be added to the document
		*/
		
		html = html + '<a href="'+url+'" style="background-image: url(thumbnails/' + img + '.png);"></a>';
	}
	
/**
	Add the stuff to the document
*/

	$('#container').append(
		html+'</div><span id="prev"></span><span id="next"></span>'
	);

/**
	Add page numbers to the paragraph
*/

	$('#container div').each(
		function(index) {
			var page = index+1;
			$('#pages').append('<span>' + page + '</span>');
		}
	);

/**
	Adds active state
*/

	$('#pages span:first-child').addClass('active');

	
/**
	Hovering #prev and #next causes
	the prev/next page links to glow
*/

	$('#prev').hover(
		function() {
			$('#pages span.active').prev('#pages span').addClass('shine');
		},
		function() {
			$('#pages span').removeClass('shine');
		}
	);
	
	$('#next').hover(
		function() {
			$('#pages span.active').next('#pages span').addClass('shine');
		},
		function() {
			$('#pages span').removeClass('shine');
		}
	);

/**
	When page link is
	clicked
*/

	$('#pages span').click(
		function() {	
			var page = $(this).html();
			window.location.hash = page;
			$('#pages span').removeClass('active');
			$(this).addClass('active');
			$('#container div').hide();
			$('#container div:nth-child(' + page + ')').fadeIn();
		}
	);

/**
	Hook clicks from the #prev to
	previous page link
*/
	
	$('#prev').click(
		function() {
			$('#pages span.active').prev('#pages span').click();
		}
	);

/**
	Hook click from the #next
*/

	$('#next').click(
		function() {
			$('#pages span.active').next('#pages span').click();
		}
	);

/**
	Select random URL and redirect
*/

	$('#random').click(
		function() {
			var count = $('#container a').length;
			var random = Math.floor(Math.random() * count);		
			var url = $('#container').find('a').eq(random).attr('href');
			window.location = url;
		}
	);

/**
	Open all links
*/

	$('#each').click(
		function() {
			if(confirm('Are you sure? It will open all links, and the work may render your browser insane.')) {
				$('#container a').each(
					function() {
						var url = $(this).attr('href');
						window.open(url);
					}
				);
			}
		}
	);

/**
	Open visible links
*/

	$('#shown').click(
		function() {
			if(confirm('Are you sure? It will open currently visible sites.')) {
				$('#container div:visible a').each(
					function() {
						var url = $(this).attr('href');
						window.open(url);
					}
				);
			}
		}
	);

/**
	Bind arrows, and transfer it as
	a click to the page links
*/

	$(document).keydown(
		function(event) {
			var goTo = '';
			if(event.keyCode == 37)
				goTo = 'prev';
			else if(event.keyCode == 39)
				goTo = 'next';
			if(goTo) {
				event.preventDefault();
				$('#pages span').removeClass('shine');
				$('#pages span.active')[goTo]('#pages span').click();
				return false;
			}
		}
	);

/**
	If the loaded starting URL has hash in it,
	activate that specific page
*/

	if(window.location.hash) {
		$('#pages span:nth-child(' + window.location.hash.substring(1) + ')').click();
	}

/**
	If the page somehow opens, or ends up,
	in strange cordinates, reset the location
*/

	$('body').click(scroll(0,0));
});