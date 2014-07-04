var countdown                   = 100; //600
var currentCountdown            = countdown;
var countdownSliderStartHeight  = 999;
var plantPresentationTemplate   = null;
var fredselHasBeenInitialized   = false;
var valueColor                  = "#ff642a";
var fillerColor                 = "#e9eae5";
var response					= null;
var animationInterval			= 50;
var barAnimationTime			= 2000;
var currentSlide				= null;
var hasBeenInitialized			= false;

function animateProgressBar(totalValue)
{
	if (currentSlide.find(".progressBarContainer").size() > 0)
	{		
		var currentValue 	= 0;
		var maxValue 		= response.maximumProduction;
		var stepSize		= barAnimationTime / animationInterval;
			
		var i = setInterval(function ()
	    {
	        if (currentValue >= totalValue)
	        {
	            clearInterval(i);
	            if (currentValue > totalValue)
	            {
	            	currentSlide.find(".progressBarContainer .value").text(totalValue);
	            }
	            animateThisWillPower();
	        }
	        else
	        {
	            currentValue = currentValue + Math.round((totalValue / stepSize));
	            currentSlide.find(".progressBarContainer .value").text(currentValue);
	            currentSlide.find(".progressBarContainer .bar").width((currentValue / maxValue) * currentSlide.find(".progressBarContainer").width());
	        }
	    }, animationInterval);
	}
}

function animateThisWillPower()
{
	if (currentSlide.find("#thisWillPowerContainer").size() > 0)
	{
		var currentNumberOfIcons 	= 0;
		var newIcon 				= null;
		var thisWillPower 			= Math.round(response.totalProductionValue / response.oneUnitConsumes);
		var scale					= response.oneIconEqualsXUnits;
		var numberOfIconsToShow 	= Math.ceil(thisWillPower / scale);
		
		var size					= (scale / 2) + 5;
		
		$("#thisWillPowerTitle").fadeIn(500, function () {
			$("#thisWillPowerContainer").show(function() {
				var i = setInterval(function ()
			    {
			        if (currentNumberOfIcons >= numberOfIconsToShow)
			        {
			            clearInterval(i);
		            	currentSlide.find("#thisWillPowerNumber").text(thisWillPower);
		            	currentSlide.find("#thisWillPowerWhat").text(response.what);
		            	currentSlide.find("#thisWillPowerContainer .infoText").fadeIn(500);
		            	currentSlide.find("#scale").text(scale);
			        }
			        else
			        {
			            currentNumberOfIcons = currentNumberOfIcons + 1;
			            newIcon = $("<div class='thisWillPower'>").appendTo(currentSlide.find("#thisWillPowerIcons"));
			            newIcon.width(size).height(size).show();
			        }
			    }, 5);
			});
		});
	}
}

function setupMaps()
{
    //------------------------------------------------------------
    // Add the type as a prefix to the maps to create unique ids.
    //------------------------------------------------------------
    
    $(".map").each(function() {
        $(this).attr("id", $(this).closest(".slide").attr("id") + "_" + $(this).attr("id"));
    });
    
    $(".map").each(function() {
        setupMap($(this).attr("id"), new google.maps.LatLng(parseInt($(this).attr("data-lat")), parseInt($(this).attr("data-long"))));
    });
}

function setupMap(aDivId, aLocation) 
{
    var mapOptions = {
        zoom: 4,
        center: aLocation,
        disableDefaultUI: true,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    }
        
        var map = new google.maps.Map(document.getElementById(aDivId), mapOptions);
    
    var marker = new google.maps.Marker({
        position: aLocation,
        map: map
    });
}

function setupCharts()
{
	if (currentSlide.attr("id") != "windspeed")
	{
		currentSlide.find(".plantPresentation").each(function() {
	        setupChart($(this));
	    });
	};
}

function setupChart(presentationObject)
{
    var data = [
        {
            value: parseInt($(presentationObject).attr("data-value")),
            color: valueColor
        },
        {
            value: 100 - parseInt($(presentationObject).attr("data-value")),
            color : fillerColor
        }            
    ];
    
    var ctx = $(presentationObject).find(".chart").get(0).getContext("2d");
    var chartOptions = {segmentShowStroke : true, segmentStrokeColor : "#bbb", segmentStrokeWidth : 1, animation: true};
    var myNewChart = new Chart(ctx).Pie(data, chartOptions);
}

function setupFanSpeed()
{
    $(".windicon").each(function() {
        var dataValue = parseInt($(this).closest(".plantPresentation").attr("data-value"));
        var windSpeed = 4000 - ((4000 / 25) * dataValue) + 500;
        if (dataValue > 0)
        {
            $(this).css("-webkit-animation-duration", windSpeed + "ms");
        }
    });
    
}

function checkTimeout()
{
    currentCountdown = currentCountdown - 1;
    
    $("#countdownSlider").height((currentCountdown / countdown) * countdownSliderStartHeight);
    
    if (currentCountdown <= 0)
    {
        refresh();
    }
}

function resetViews(aNewSlide)
{
	aNewSlide.find(".bar").width(1);
	aNewSlide.find(".plantPresentation").each(function() {
        if ($(this).closest(".slide").attr("id") != "windspeed")
        {
            var ctx = $(this).find(".chart").get(0).getContext("2d");
            ctx.clearRect(0, 0, 200, 200);
        }
    });
    aNewSlide.find(".thisWillPower").remove();
    aNewSlide.find("#thisWillPowerTitle").hide();
    aNewSlide.find("#thisWillPowerContainer .infoText").hide();
}

function runAnimations()
{	
	//--------------------------------------------------------
	// Timer to make the animation wait a bit before starting
	//--------------------------------------------------------
	
	setTimeout(function() {
		setupCharts();
		animateProgressBar(response.totalProductionValue);
	}, 500);
}

function setupLabels()
{
	$("[class ^= label_]").each(function () {
		var label = $(this).attr("class");
		$(this).text(response.labels[label]);
	});
}

function refresh()
{
    currentCountdown = countdown;
    
    currentSlide = $("#slides .slide:first-child");
    
    resetViews(currentSlide);

    $("#countdown").fadeOut(1000);
	$("#latestUpdateContainer").fadeOut(1000, function() {
		$("#info").fadeIn(1000, function() {
			$.getJSON("jsonData.json", function(jsonResponse) {
		    	response = jsonResponse;
		    	
		    	setupLabels();

		    	$("#maximumProductionValue").text(response.maximumProduction);
		    	
		    	if ($.fn.carouFredSel && !fredselHasBeenInitialized)
				{
					initializeFredsel();
					fredselHasBeenInitialized = true;
				}
				plantPresentationTemplate.into($("#windspeed .dataContent")).render(response.measurements.windspeed);
				plantPresentationTemplate.into($("#capacity .dataContent")).render(response.measurements.capacity);
				plantPresentationTemplate.into($("#availability .dataContent")).render(response.measurements.availability);
				
				$("#nordpool").text(response.marketValue.nordpool);
				$("#nasdaq").text(response.marketValue.nasdaq);
				$(".marketValueRow .unit").text(response.labels.currency);
				
				setupMaps();
				setupFanSpeed();
				var updateTime = new Date();
				var padding = "";
				if (updateTime.getMinutes() < 10)
				{
					padding = "0";
				}
				
				$("#info").fadeOut(1000, function() {
					$("#latestUpdate").text(updateTime.getHours() + ":" + padding + updateTime.getMinutes());
					$("#latestUpdateContainer").fadeIn(1000);
					$("#countdown").fadeIn(1000);
			    	runAnimations();
				});
				
				if (!hasBeenInitialized)
				{
					$("#loadingLayer").fadeOut(200);
					hasBeenInitialized = true;
				}
		    });
		});
	});
}

function refreshSmall()
{
	currentSlide = $("#slides");
	
	$.getJSON("jsonData.json", function(jsonResponse) {
    	response = jsonResponse;
    	
    	setupLabels();
    	
    	$("#maximumProductionValue").text(response.maximumProduction);
    	
		plantPresentationTemplate.into($("#windspeed .dataContent")).render(response.measurements.windspeed);
		plantPresentationTemplate.into($("#capacity .dataContent")).render(response.measurements.capacity);
		plantPresentationTemplate.into($("#availability .dataContent")).render(response.measurements.availability);
		
		$("#nordpool").text(response.marketValue.nordpool);
		$("#nasdaq").text(response.marketValue.nasdaq);
		$(".marketValueRow .unit").text(response.labels.currency);
		
		setupMaps();
		setupFanSpeed();
	    runAnimations();
    });
}

function initializeFredsel()
{
    $(".slide").height($(window).height());
    $(".slide").width($(window).width());
    
    $("#slides").carouFredSel({
        items       	: {
        	visible		: 1,
        	height		: "100%"
        },
        width        	: "100%",
        height			: "100%",
        responsive    	: true,
        auto        	: false,
        /*
        auto : {
	        //easing          : "elastic",
	        duration        : 2000,
	        timeoutDuration    : 5000,
	        pauseOnHover    : false
	    },
	    */
        prev         	: "#prev",
        next         	: "#next",
        scroll      	: {
        	onBefore 	: function(data) {
        		console.log("Plopp: ", data.items);
        		newSlide = $("#" + data.items.visible[0].id);
				resetViews(newSlide);
			},
			onAfter 	: function(data) {
				currentSlide = $("#" + data.items.visible[0].id);
				runAnimations();
			}
        },
        onCreate		: function() {
        	$(".caroufredsel_wrapper").height("100%");
        }
    });
}