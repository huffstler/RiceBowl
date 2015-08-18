Startpage Version 1
===================

This is a browser Start Page, it has the time, local 5 day forecast, links to commonly visited websites, and a search form that runs on Google's API.

<h2>Libraries Uses:</h2>
ZWeatherFeed - http://www.zazar.net/developers/jquery/zweatherfeed/ <br/>
FancyBox - http://fancyapps.com/fancybox/ <br/>
Google Search - http://tutorialzine.com/2010/09/google-powered-site-search-ajax-jquery/ <br/>

<h2>Edit:</h2>
Weather Edit - replace with your weather code
```
$('#weather').weatherfeed(['USTX0542']...
```

Remove/add new websites to search by editing the list below:
```
	<li class="sel"><a href="kat.ph" id="kat">kat.ph</a></li>
	<li class="sel"><a href="soundcloud.com" id="sc">soundcloud</a></li>
	<li class="sel"><a href="youtube.com" id="yt">youtube</a></li>
	<li class="sel"><a href="vimeo.com" id="vm">vimeo</a></li>
```

Edit the list below for search types, must be at least one or a combinations of the following:
```
  <a href="#" id="web">M</a>
  <a href="#" id="images">I</a>
	<a href="#" id="video">V</a>
	<a href="#" id="news">D</a>
```						


Search can be buggy when searching something other than YouTube and Google.
The style is basic and minimal, edit as you please. Enjoy!
