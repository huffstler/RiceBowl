/*
 * boxes.js
 * 
 * Copyright 2014 pache <github.com/mukyu>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 */
var currentpage = 0;

$(document).ready(function(){
	drawNavs();
	colorIn(currentpage);
	addPages();
	drawPages();
	showPage(currentpage);
	$("a.box").css("color", textcolor);
	$("h2").css("color", textcolor);
});

function addPages(){
	for(var i = 0; i <= (Pages.length - 1); i++){
		$("#pages").append("<div id='p"+i+"'></div>");
	}
}

function drawNavs(){
	for(var i = 0; i <= (Pages.length - 1); i++){
		$("#nav").append("<li class='navigator'><a href='#' id='"+i+"' onclick='handleClick("+i+");'>■</a></li>");
	}
}

function handleClick(number){
	colorIn(number);
	showPage(number);
}

function drawPages(){
	for(var i = 0; i <= (Pages.length - 1); i++){
		for(var j = 0; j <= (Pages[i].Cells.length - 1); j++){
			$("#p"+i).append("<a class='box' href='"+Pages[i].Cells[j].URL+"'><p>"+Pages[i].Cells[j].Name+"</p></a>");
		}
	}
}

function showPage(requested){
	for(var i = 0; i <= Pages.length; i++){
		if(i == requested){
			$("#p"+requested).slideDown();
		}
		else{
			$("#p"+i).slideUp();
		}
	}
}

function colorIn(exception){
	for(var i = 0; i <= Pages.length; i++){
		if(i == exception){
			$("#" + exception).css("color", "rgba(255,255,255,1)");
		}
		else{
			$("#" + i).css("color", "rgba(70,70,70,0.8)");
		}
	}
}

function Page(Cells){
	this.Cells = Cells;
}

function Cell(Name, URL){
	this.Name = Name;
	this.URL = URL;
}
