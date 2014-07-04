// Funktion för att visa/dölja tips i sök-fält vid focus/blur
$.fn.searchHint = function(defaultText) {
	return this.focus(function() {
		if( this.value == defaultText ) {
			this.value = "";
			$(this).removeClass("searchHint");
		}
	}).blur(function() {
		if( !this.value.length ) {
			this.value = defaultText;
			$(this).addClass("searchHint");
		}
	});
};

// Funktion för att distribuera toppmenydelar jämnt
function distributeTopMenuBars(container, menus) {
	var containerWidth = $(container).width();
	var menuWidth = 0;
	$(menus).each( function () {
		menuWidth = menuWidth + $(this).width(); 
	} );
	var margin = Math.floor((containerWidth - menuWidth)/2);
	if (margin > 0) {
		// Sätt rätt högermarginal på första menydelen för rätt placering av den andra i mellanrummet
		$("ul#topMenuFirst").css("margin-right", margin);
	}
}


// Uppdatera och visa/dölj beställningskorgen
function updateShoppingBasket() {
	var numberOfReports = 0;
	if (getCookie('ISF_rapportkorg') != null) {
		numberOfReports = (getCookie('ISF_rapportkorg').split(',')).length;
		if (numberOfReports == 1 ) {
			$("#shoppingBasketContainer strong").html("1 rapport");
		} else {
			$("#shoppingBasketContainer strong").html(numberOfReports + " rapporter");
		}
		$("#shoppingBasketContainer").fadeIn('0');
	} else {
		$("#shoppingBasketContainer").fadeOut('0');
	}
}

// Cookie-funktioner
function setCookie(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}
function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}
function addToExistingOrSetNewCookie(name,value,days) {
	var existingCookieValue = getCookie(name);
	if (existingCookieValue != null) {
		value = existingCookieValue + "," + value;
	}
	setCookie(name,value,days);
}
function removeFromCookie(name,value,days) {
	var existingCookieValue = getCookie(name);
	var newValue = "";
	if (existingCookieValue != null) {
		if (existingCookieValue.indexOf(value + ",") != -1) {
			newValue = existingCookieValue.replace(value + ",", "");
		} else if (existingCookieValue.indexOf("," + value) != -1) {
			newValue = existingCookieValue.replace("," + value, "");
		} else if (existingCookieValue.indexOf(value) != -1) {
			newValue = existingCookieValue.replace(value, "");
		}
	}
	if (newValue.length > 0) {
		setCookie(name,newValue,days);
	} else {
		deleteCookie(name);
	}
}
function deleteCookie(name) {
    setCookie(name,"",-1);
}


// Efter laddning av sidan
$(document).ready(function() {

	// Visa med hovereffekt att hela nyheternas yta är klickbar 
	$(".newsItem").bind('mouseenter', function(){
		$(this).toggleClass("newsListHover");
	}).bind('mouseleave', function(){
		$(this).toggleClass("newsListHover");
	});
	// Gör hela nyheternas yta klickbar 
	$(".newsItem").click(function(event){
		var newsLink = $(this).children('h3').children('a').attr('href');
		$(location).attr('href',newsLink);
	});

	// Visa med hovereffekt att hela pressträffytan är klickbar 
	$(".eventItem").bind('mouseenter', function(){
		$(this).toggleClass("eventListHover");
	}).bind('mouseleave', function(){
		$(this).toggleClass("eventListHover");
	});
	// Gör hela pressträffens yta klickbar 
	$(".eventItem").click(function(event){
		var newsLink = $(this).children('h3').children('a').attr('href');
		$(location).attr('href',newsLink);
	});

	// Visa med hovereffekt att hela bannerns yta är klickbar 
	$(".bannerBlock .banner").bind('mouseenter', function(){
		$(this).toggleClass("bannerHover");
	}).bind('mouseleave', function(){
		$(this).toggleClass("bannerHover");
	});
	// Gör hela bannerns yta klickbar 
	$(".bannerBlock .banner").click(function(event){
		var bannerLink = $(this).children('div').children('p').children('a').attr('href');
		$(location).attr('href',bannerLink);
	});

	// Justera till jämn höjd på bannerrad i mittenkolumnen
	var bannerMargins = parseInt($('#mainColContainer .banner').css('marginTop')) + parseInt($('#mainColContainer .banner').css('marginBottom'));
	$("#mainColContainer .banner").each(function () {
	  $(this).height($(this).parent().height() - bannerMargins);
	});
	
	// Visa/dölj tips i sök-fält
	var defaultTextWebSearch = "Sök på webbplatsen";
	var defaultTextPublicationSearch = "Fritextsökning";
	// Initiera
	$("#searchField").val(defaultTextWebSearch);
	$("#textField").val(defaultTextPublicationSearch);
	$("#searchField, #textField").addClass("searchHint");
	// Focus/blur
	$("#searchField").searchHint(defaultTextWebSearch);	
	$("#textField").searchHint(defaultTextPublicationSearch);	

	// Animering vänstermeny
	if ( $("#navMenuContainer").length ) {
		$("#navMenuContainer ul li.selected>ul").hide();
		$("#navMenuContainer ul li.selected>ul").slideDown('0');
	}
	
	// Distribuera toppmenydelar jämnt
	distributeTopMenuBars("#topMenuContainer .innerContainer", "#topMenuContainer .innerContainer ul");
	
	// Anmälningsformulär konferens: lägg till fler deltagare
	// Startläge
	$("#conferenceForm .additionalParticipant span").hide();
	$("#conferenceForm .additionalParticipant").hide();
	$("#conferenceForm .addMoreParticipants").show();
	// Visa fält vid lägg till deltagare, lägg till fält för en ny deltagare i taget
	$("#conferenceForm .addMoreParticipants").click(function(event){
		// Förhindra länknavigering
		event.preventDefault();
		// Kontrollera vilka nya deltagarfält som ska läggas till
		var indexNextParticipant = 0;
		$("#conferenceForm .additionalParticipant").each(function() {
			if ($(this).is(':visible')) {
				indexNextParticipant += 1;
			}
		});
		// Visa nya deltagarfält
		$("#conferenceForm .additionalParticipant:eq(" + indexNextParticipant + ")").slideDown('0');
		// Dölj länk när antal extra deltagare är max
		if (indexNextParticipant == ($("#conferenceForm .additionalParticipant").length - 1)) {
			$("#conferenceForm .addMoreParticipants").hide();
		}
	});
	
	// Förhindra att telefonnummer och datum bryts i tabeller eller att de kolumnerna blir olika breda
	if ($(".contactDetailsList table, .publicationList table, .projectList table, .conferenceList table")) {
		$(".contactDetailsList table tr td:last-child, .publicationList table tr td:last-child, .projectList table tr td:last-child, .conferenceList table tr td:last-child").addClass("minimumWidthNoWrapColumn");
	}
	
	
	
	
	
	
	
	
	
	
	
	// UPPDATERING
	
	// Linjera rapportnummerkolumner för samtliga publikationslistor på sidan
	var reportNoColMaxWidth = 0;
	$('.publicationList table tr td:first-child:not(:has(a))').each(function() {
		//alert('Hittade en!');
		reportNoColMaxWidth = Math.max($(this).width(), reportNoColMaxWidth);
		$(this).wrapInner('<span class="linkLook" />');
		$(this).parents("tr").find('a').addClass("middleColLink");
	}).width(reportNoColMaxWidth);
	
	// Visa med hovereffekt att rapportnummerkolumnen är klickbar 
	$(".publicationList table tr td span.linkLook, .publicationList table tr td a").bind('mouseenter', function(){
		$(this).parents("td").parents("tr").toggleClass("publicationListHover");
	}).bind('mouseleave', function(){
		$(this).parents("td").parents("tr").toggleClass("publicationListHover");
	});
	// Gör rapportnummerkolumnen klickbar 
	$(".publicationList table tr td span.linkLook").click(function(event){
		var reportLink = $(this).parents("td").parents("tr").find('a').attr('href');
		$(location).attr('href',reportLink);
	});
	
	// SLUT UPPDATERING
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	// Visa uppdaterad beställningskorg när sidan laddas
	updateShoppingBasket();

	// Fyll i beställningskorgens tabell med data från cookie
	if ($("#orderList table").length > 0 && getCookie('ISF_rapportkorg') != null) {
		// Ta bort defaultrad (för direktbeställning utan JS)
		$("#orderList table tr:nth-child(2)").remove();
		// Lägg på rader med rapporter från cookie
		var reports = getCookie('ISF_rapportkorg').split(',');
		for(var i=0;i < reports.length;i++) {
			var report = reports[i];
			$('#orderList table').append('<tr><td><a href="#">' + report + '</a></td><td>' + i + '</td><td><input type="text" value="1" /></td><td class="remove"><a href="#">Ta bort</a></td></tr>');
		}
	}
	
	// Visa Ta-bort-knappar i beställningskorgen vid JS-stöd
	$("#orderList table .remove").show();
	
	// Ta bort rad i beställningskorgen
	$("#orderList table .remove a").click(function(event){
		event.preventDefault();
		$(this).parent("td").parent("tr").remove();
		removeFromCookie('ISF_rapportkorg', $(this).parent("td").parent("tr").children("td:first-child").html(), 1);
		updateShoppingBasket();
		if ($(this).parent("td").parent("tr").parent("table").children("tr").length < 2 ) {
			$("#orderList table").remove();
			$("#orderList h2").html("Inga rapporter finns i beställningskorgen");
		}
	});
	
	// Visa lightbox-dialog vid klick på beställningslänk
	$("a.orderPrintLink").click(function(event){
		event.preventDefault();
		// Lagra beställning i cookie som sparas 1 dag
		addToExistingOrSetNewCookie('ISF_rapportkorg', $("h1").html(), 1);
		updateShoppingBasket();
		$("#shoppingLightbox").fadeIn('0');
		$("#shoppingLightbox .container").css("top", ( $(window).height() - $("#shoppingLightbox .container").height() ) / 2 + "px");						 
		$("#shoppingLightbox ul li:first-child a").focus();
	});

	// Förhindra tabbning utanför lightbox
	$("#shoppingLightbox ul li:first-child a").blur(function(event){
		$("#shoppingLightbox ul li:last-child a").focus();
	});
	$("#shoppingLightbox ul li:last-child a").blur(function(event){
		$("#shoppingLightbox ul li:first-child a").focus();
	});

	// Stäng lightbox vid klick på tillbaka-länk i lightbox-dialog
	$("#shoppingLightbox a.closeShoppingLightbox").click(function(event){
		event.preventDefault();
		$("#shoppingLightbox").fadeOut('0');
		$("a.orderPrintLink").focus();
	});

	// Gå till varukorg/beställning vid klick på visa/ändra-länk samt i lightbox-dialog
	$("#shoppingLightbox a.goToShoppingBasket, #shoppingBasketContainer a").click(function(event){
		var pageLink = 'ISF_bestall.html';
		$(location).attr('href',pageLink);
	});

	// Gå till bekräftelsesida vid klick i beställningsformulär
	$("#orderForm .button").click(function(event){
		var pageLink = 'ISF_bestallningsbekraftelse.html';
		$(location).attr('href',pageLink);
		// Radera cookie med beställningens innehåll
		deleteCookie('ISF_rapportkorg');
	});







	// OBS!!!! -------------------- BARA I PROTOTYP FÖR ENKEL NAVIGERING nedanför denna rad - implementeras EJ --------------------------------------------
	// Gå till sök publikationsida vid klick på publikationssökknapp
	$("#publicationSearch .searchButton").click(function(event){
		$(location).attr('href','ISF_sok_publikation.html');
	});
	// Gå till söksida vid klick på sökknapp
	$("#searchContainer .searchButton").click(function(event){
		$(location).attr('href','ISF_sok.html');
	});
	// Gå till publikationssida vid klick i publikationslista
	$(".publicationList table td a, #publicationSearchResults table td a").click(function(event){
		event.preventDefault();
		var pageLink = 'ISF_rapportsida.html';
		if ($(this).hasClass('arbetsrapportlank')) {
			pageLink = 'ISF_arbetsrapportsida.html';
		} else if ($(this).hasClass('wplank')) {
			pageLink = 'ISF_wpsida.html';
		} else if ($(this).hasClass('pdfLink')) {
			pageLink = '';
		} else if ($(this).hasClass('wp-english')) {
			pageLink = 'ISF_wp.html';
		}
		if (pageLink != '') {
			$(location).attr('href',pageLink);
		}
	});
	// Gå till projektsida vid klick i projektlista
	$(".projectList a").click(function(event){
		var pageLink = 'ISF_projektsida.html';
		$(location).attr('href',pageLink);
	});
	// Gå till pressmeddelandesida vid klick i nyhetslista
	$(".newsItem").click(function(event){
		var pageLink = 'ISF_pressmeddelande.html';
		$(location).attr('href',pageLink);
	});
	// Gå till pressträffsida vid klick i pressträfflistan 
	$(".eventItem").click(function(event){
		var pageLink = 'ISF_presstraff.html';
		$(location).attr('href',pageLink);
	});

	// Gå till bekräftelsesida vid klick i anmälningsformulär konferens
	$("#conferenceForm .button").click(function(event){
		var pageLink = 'ISF_konferensanmalan_bekraftelse.html';
		$(location).attr('href',pageLink);
	});	

});
