var currentPosition = null;

$(document).ready(function() {
	
	
	
	$("#menuHeader a").click(function(event) {
		$("#loggedOutHeader").toggle();
	});
	
	/*---------------
	  Expandable menu
	  ---------------*/

	$(".expand").click(function(event) {
		event.preventDefault();
		/* CLOSE OTHERS BEFORE OPENING
		if ($(event.target).closest("li").hasClass("active"))
		{
			$(event.target).closest("li").children("ul").slideUp(200);
			$(event.target).closest("li").removeClass("active");
		}
		else
		{
			$("ul#menuTree").find("li.active").find("ul").slideUp(100);
			$("ul#menuTree").find("li.active").removeClass("active");
			$(event.target).closest("li").children("ul").slideDown(200);
			$(event.target).closest("li").addClass("active");
		}
		*/
		$(event.target).closest("li").toggleClass("active");
		$(event.target).closest("li").children("ul").slideToggle(200);
	});

	$("#menu").click(function() {
		$("#searchForm").hide().removeClass("expanded");
		$("#vt-menu").show();
		toggleMenu();
	});
	
	$(".magglas").click(function() {
		$("#searchForm").show();
		toggleSearch();
	});
	
	/*-------------------
	     Search field
	  -------------------*/
	
	$("#searchButton").click(function () {
		$(this).closest("form").submit();
	});
		
	$(".searchBox").keyup(function() {
		if ($(this).val() == "")
		{
			$("#clearButton").hide();
		}
		else
		{
			$("#clearButton").show();
		}
			
	});
	
	$("#clearButton").click(function() {
		var textField = $(this).closest("form").find("input[type='text']");
		textField.val("");
		textField.focus();
		$("#clearButton").hide();
	});
	
	$(".topAlertClose").click(function () {
		$(".topAlert").slideUp(200);
	});
	
	$("#backToTop").click(function () {
		$('body,html').animate({
		  scrollTop: 0
		}, 200);
	});
	
	if (isMobile.iOS())
	{		
		$("#searchField").focus(function() {
			$(window).scrollTop(0);
			
			$("#mainMenu").css("position", "absolute");
			$("#mainMenu").css("top", "0");
			$("#searchForm").css("position", "absolute");
			$("#searchForm").css("top", "45px");
		});
		
		$("#searchField").blur(function() {
			$("#mainMenu").css("position", "fixed");
			$("#mainMenu").css("top", "0");
			$("#searchForm").css("position", "fixed");
			$("#searchForm").css("top", "45px");
		});
	}
	
	/*----------------------------------
	  Swipe event for the main container
	  ----------------------------------*/
	/*
	$("#vt-container").swipe({
		excludedElements:".cardRoller",
		click: function (event, target) {
			//$(target).trigger("click");
		},
		swipeRight:function(event, direction, distance, duration, fingerCount) {
			showMenu();
			$("#searchForm").hide().removeClass("expanded");
		},
		swipeLeft:function(event, direction, distance, duration, fingerCount) {
			hideMenu();
		}
	});
	*/
	
	/*----------------------------------
	  Events for the overlay
	  ----------------------------------*/

	$("#vt-overlay").click(function () {
		hideMenu();
		hideSearch();
	});
	
	$("#vt-pusher").click(function () {
		hideMenu();
	});
	
	setupCaroufredsel("#newsfeed");
	setupCaroufredsel("#trafficSituations");
});

function setupCaroufredsel(container)
{
	if ($(container + " .cardRoller").size() > 0)
	{
		$(container + " .cardRoller").carouFredSel({
		    circular 		: true,
			infinite		: false,
			swipe        	: {
		        onTouch     : true,
		        onMouse     : true
			},
			items 			: {
				visible 	: 1
			},
			responsive  	: true,
			direction 		: "left",
			scroll : {
				items 		: 1,
				easing 		: "swing",
				duration 	: 200,
			},
			pagination		: {
				container	: container + " .cardSwiperPagination",
				keys        : false
			},
			auto : {
				play		: false
			}
		});

		$(container + ".cardRoller").swipe({
			click: function (event, target) {
				document.location.href = $(target).closest("li").attr("data-target");
			}
		});
	}
}

$(window).resize(function() 
{ 
	$("#newsfeed .cardRoller").trigger("destroy");
	$("#trafficSituations .cardRoller").trigger("destroy"); 
	
	setupCaroufredsel("#newsfeed");
	setupCaroufredsel("#trafficSituations");

}); 

function showMenu()
{
	$("#vt-container").addClass("openMenu").removeClass("closeMenu");
	$("#mainMenu").appendTo("#vt-pusher");
	$("#vt-overlay").show();
}

function hideMenu()
{
	$("#vt-container").removeClass("openMenu").addClass("closeMenu");
	setTimeout(function() {
		$("#mainMenu").appendTo("#vt-container");
		$("#vt-menu").hide();
	}, 200);
	$("#vt-overlay").hide();
}

function toggleMenu()
{
	if ($("#vt-container").hasClass("openMenu"))
	{
		hideMenu();
	}
	else
	{
		showMenu();
	}
}

function showSearch() {
	$("#searchForm").show().addClass("expanded");
	$("#vt-overlay").show();
	$("#searchField").focus();
}

function hideSearch() {
	if (isMobile.iOS())
	{
		$("#mainMenu").css("position", "fixed");
		$("#mainMenu").css("top", "0");
		$("#searchForm").blur();
		$("#searchForm").css("position", "fixed");
		$("#searchForm").css("top", "-200px");
	}
	$("#searchForm").removeClass("expanded");
	$("#vt-overlay").hide();
}

function toggleSearch()
{
	if ($("#searchForm").hasClass("expanded"))
	{
		hideSearch();
	}
	else
	{
		showSearch();
	}
}

function getPosition()
{
	$("#location").html("Var god vänta. Position hämtas...");
	if (navigator.geolocation)
	{
		position = navigator.geolocation.getCurrentPosition(function(position) {
			currentPosition = position;
			showPosition();
		}, showError);
	}
	else
	{
		alert("Din webbläsare stöder inte GPS-position.");
	}
}

function showPosition()
{
	if (currentPosition != null)
	{
		$("#location").html(currentPosition.coords.latitude + ", " + currentPosition.coords.longitude);
	}
	else
	{
		alert("Du måste hämta positionen först.");
	}
}

function showError(error)
{
	switch(error.code) 
	{
		case error.PERMISSION_DENIED:
			alert("User denied the request for Geolocation.")
		break;
		case error.POSITION_UNAVAILABLE:
			alert("Location information is unavailable.")
		break;
		case error.TIMEOUT:
			alert("The request to get user location timed out.")
		break;
		case error.UNKNOWN_ERROR:
			alert("An unknown error occurred.")
		break;
	}
}

var isMobile = {
    Android: function() {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
        return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
};