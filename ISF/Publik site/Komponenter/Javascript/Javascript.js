var cookieName 	= "ISF_rapportkorg";
cookieDays		= 1;

// Funktion för att visa/dölja tips i sök-fält vid focus/blur
$.fn.searchHint = function(defaultText) {
	return this.focus(function() {
		if( this.value == defaultText ) {
			this.value = "";
			$("#emptyQuery").val("no");
			$(this).removeClass("searchHint");
		}
	}).blur(function() {
		if( !this.value.length ) {
			this.value = defaultText;
			$("#emptyQuery").val("yes");
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
function updateShoppingBasket(animate, removeRow) 
{
	var numberOfReports = countReports();
	if (numberOfReports > 0) 
	{
		if (numberOfReports == 1 ) {
			$("#shoppingBasketContainer strong").html("1 rapport");
		} else {
			$("#shoppingBasketContainer strong").html(numberOfReports + " rapporter");
		}
		if (animate) {
			$("#shoppingBasketContainer").fadeIn('0');
		} else {
			$("#shoppingBasketContainer").show();
		}
	} 
	else 
	{
		if (animate) {
			$("#shoppingBasketContainer").fadeOut('0');
		} else {
			$("#shoppingBasketContainer").hide();
		}
		
		if ($("#orderList table") && removeRow)
		{
			$("#orderList table").remove();
			$("#orderList h2").html("Inga rapporter finns i beställningskorgen");
		}
	}
}

//-------------------
// Cookie-funktioner
//-------------------

function setCookie(value) 
{
    if (cookieDays) {
        var date = new Date();
        date.setTime(date.getTime()+(cookieDays*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = cookieName + "=" + value + expires + "; path=/";
}

function getCookie(name) 
{
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function setNumberOfReports(aReportId, aNumberOfReports, aRemoveRow) 
{
	var values 			= cookieToMap();
	values[aReportId] 	= aNumberOfReports;
	var newCookieValue 	= mapToCookie(values);	
	setCookie(newCookieValue);
	updateShoppingBasket(false, aRemoveRow);
}

function addReport(aReportId) 
{
	var values 			= cookieToMap();
	var oldValue 		= values[aReportId];
	if (oldValue == null)
	{
		values[aReportId] = 1;
	}
	else
	{
		values[aReportId] 	= parseInt(values[aReportId]) + 1;
	}
	var newCookieValue 	= mapToCookie(values);	
	setCookie(newCookieValue);
}

function countReports()
{
	var map 			= cookieToMap();
	var counter 		= 0;
	var numberOfReports	= 0;
	
	for (var i in map)
	{
		numberOfReports = map[i];
		if (!parseInt(numberOfReports))
		{
			numberOfReports = 0;
		}
		counter += parseInt(numberOfReports);	
	}
	return counter;
}

function deleteCookie(name) 
{
    setCookie(name,"",-1);
}

function cookieToMap()
{
	var cookieValue	= getCookie(cookieName);
	var items		= new Array();
	
	if (cookieValue != null)
	{
		items 		= cookieValue.split("|");
	}
	
	var data		= null;
	var temp 		= "";
	var key			= "";
	var value		= "";
	var returnMap 	= new Object();
	
	for (var i = 0; i < items.length; i ++)
	{
		temp 	= items[i];
		if (temp != null && temp != "")
		{
			data 			= temp.split("#");
			key 			= data[0];
			value 			= data[1];
			returnMap[key] 	= value;
		}
	}
	return returnMap;
}

function mapToCookie(aMap)
{
	var returnString 	= "";
	var key				= "";
	var value			= "";
	
	for (var i in aMap)
	{
		value = aMap[i];
		if (!parseInt(value))
		{
			value = 0;
		}
		returnString += i + "#" + value + "|";
	}
	return returnString;
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
	$("#emptyQuery").val("yes");
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
	$($("#conferenceForm .additionalParticipant").get().reverse()).each(function (i) {
		i = (4 - i); // Reversing id for 
		if ($(".additionalParticipant #name" + (i)).val()) {
			for (j = i; j > 0; j--) {
				$($(".additionalParticipant.id" + (i))).show();
			}
			return false;//break;
		} else {
			$(this).hide();
		}
	});
	
	if ($("#conferenceForm .additionalParticipant.id4").is(":visible")) {
		$("#conferenceForm .addMoreParticipants").hide();
	} else {
		$("#conferenceForm .addMoreParticipants").show();
	}
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
	
	// Visa uppdaterad beställningskorg när sidan laddas
	updateShoppingBasket(false, true);
	
	// Visa Ta-bort-knappar i beställningskorgen vid JS-stöd
	$("#orderList table .remove").show();
	
	// Ta bort rad i beställningskorgen
	$("#orderList table .remove a").click(function(event){
		event.preventDefault();
		var tbody = $(this).parent("td").parent("tr").parent("tbody");
		var itemId = $(this).attr("data-reportid");
				
		setNumberOfReports(itemId, 0);
		
		$("#report_" + itemId).val(0);
		
		$(this).parent("td").parent("tr").remove();	
		
		if (countReports() == 0)
		{
			updateShoppingBasket(true, true);
		}
		else
		{
			updateShoppingBasket(false, false);
		}
	});
	
	// Visa lightbox-dialog vid klick på beställningslänk
	$("a.orderPrintLink").click(function(event){
		event.preventDefault();
		// Lagra beställning i cookie som sparas 1 dag
				
		var reportId = $(this).attr("data-reportid");
		var numberOfReports = countReports();
					
		addReport(reportId);
		
		if (numberOfReports == 0)
		{
			updateShoppingBasket(true, false);
		}
		else
		{
			updateShoppingBasket(false, false);
		}
				
		//if (oldCookieVal == null || oldCookieVal == "")
		//{
			$("#shoppingLightbox").fadeIn('0');
			$("#shoppingLightbox .container").css("top", ( $(window).height() - $("#shoppingLightbox .container").height() ) / 2 + "px");						 
			$("#shoppingLightbox ul li:first-child a").focus();
		//}
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

	$("#searchField").fwcomplete({
		baseUrl : "/qc",
		minLength : 2,
		format : "json",
		highlight : true,
		hlPre : "<span class='fw_completeWritten'>",
		hlPost : '</span>'
	});
	
	$(".searchPublicationForm #textField").fwcomplete({
		baseUrl : "/qc",
		minLength : 2,
		format : "json",
		highlight : true,
		hlPre : "<span class='fw_completeWritten'>",
		hlPost : '</span>'
	});
	
});