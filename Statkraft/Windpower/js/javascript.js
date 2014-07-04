var countdown                   = 100; //600
var currentCountdown            = countdown;
var countdownSliderStartHeight  = 999;
var plantPresentationTemplate   = null;
var fredselHasBeenInitialized   = false;
var response					= null;
var oldResponse					= null;
var animationInterval			= 50;
var barAnimationTime			= 2000;
var currentSlide				= null;
var hasBeenInitialized			= false;
var showWeather					= true;
var showClouds					= false;
var rollBackground				= false;
var mapZoomLevel				= 5;
var customMapIcon				= "style/images/windpowerBig.png";
var backgroundImages			= ["style/images/bg1.jpg", "style/images/bg2.jpg", "style/images/bg3.jpg"];
var currentBackgroundIndex		= 0;

jQuery.support.cors 			= true;

$(document).ready(function() {
	$("body").click(function () {
		$("#admin").toggle();
	});

	/*
	$(".dataContent").click(function () {
		resetViews(currentSlide);
		runAnimations();
	});
	*/

	$("#nextImage").click(function () {
		rollBackgroundImage()
	});

	//$("body").addClass("fulhd");
});

function runAnimations()
{
	//--------------------------------------------------------
	// Timer to make the animation wait a bit before starting
	//--------------------------------------------------------

	setTimeout(function() {
		setupCharts();

		if (isIE() && isIE() <= 10)
		{
			animateProgressBarIe(response.totalPowerRightNow);
		}
		else
		{
	    	animateProgressBar(response.totalPowerRightNow);
		}
	}, 500);
}

function animateProgressBar(totalValue)
{
	if (currentSlide.find(".progressBarContainer").size() > 0  || $("body").hasClass("small"))
	{
		var currentValue 	= 0;
		var maxValue 		= response.maxPossibleProduction;
		var barWidth		= (totalValue / maxValue) * $("#totalProductionValueMeter").width();
		$(".bar").css("width", Math.round(barWidth) + "px");

		setTimeout(function() {
			animateThisWillPower();
		}, 3000);

		var i = setInterval(function ()
	    {
	    	currentValue = ($("#totalProductionValueMeter .bar").width() / barWidth) * totalValue;
			if (currentValue >= totalValue)
			{
				clearInterval(i);
				$("#totalProductionValueMeter .value").text(totalValue < 1 ? totalValue.toPrecision(2) : Math.round(totalValue));
			}
			else
			{
				$("#totalProductionValueMeter .value").text(currentValue < 1 ? currentValue.toPrecision(2) : Math.round(currentValue));
			}
	    }, 20);
	}
}

function animateThisWillPower()
{
	if (currentSlide.attr("id") == "totalPower" || $("body").hasClass("small"))
	{
		$(".bubble").addClass("bubbleLarge");
		setTimeout(function () {
			$(".bubble div").fadeIn(1000);
		}, 1000);
	}
}

/*-----------------------------------
  Special methods for the bad browser
  -----------------------------------*/

function animateProgressBarIe(totalValue)
{
	if (currentSlide.find(".progressBarContainer").size() > 0  || $("body").hasClass("small"))
	{
		var currentValue 	= 0;
		var maxValue 		= response.maxPossibleProduction;
		var barWidth		= (totalValue / maxValue) * $("#totalProductionValueMeter").width();
		var currentWidth	= 0;
		var stepSize		= totalValue / 100.0;

		var i = setInterval(function ()
	    {
	    	currentValue = currentValue + stepSize;

	    	if (currentValue >= totalValue)
			{
				clearInterval(i);
				$("#totalProductionValueMeter .value").text(totalValue < 1 ? totalValue.toPrecision(2) : Math.round(totalValue));
				animateThisWillPowerIe();
			}
			else
			{
				$("#totalProductionValueMeter .value").text(currentValue < 1 ? currentValue.toPrecision(2) : Math.round(currentValue));
			}

	    	currentWidth = barWidth * (currentValue / totalValue);//currentWidth + increment * stepSize;

	    	$(".bar").css("width", Math.round(currentWidth) + "px");
	    }, 20);
	}
}

function animateThisWillPowerIe()
{
	var maxWidthSmall	= 130;
	var maxWidthLarge	= 200;
	var currentValue 	= 0;

	if ($("body").hasClass("small"))
	{
		maxWidth = maxWidthSmall;
	}
	else
	{
		maxWidth = maxWidthLarge;
	}

	var i = setInterval(function ()
    {
    	currentValue = currentValue + 5;

    	if (currentValue >= maxWidth)
		{
			clearInterval(i);
			$(".bubble").css("background-size", maxWidth + "px");
			setTimeout(function () {
				$(".bubble div").fadeIn(1000);
			}, 500);
		}
		else
		{
			$(".bubble").css("background-size", currentValue + "px");
		}
    }, 20);
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
        setupMap($(this).attr("id"), new google.maps.LatLng(parseFloat($(this).attr("data-lat")), parseFloat($(this).attr("data-long"))));
    });
}

function setupMap(aDivId, aLocation)
{
    var mapOptions = {
        zoom: mapZoomLevel,
        center: aLocation,
        disableDefaultUI: true,
        mapTypeId: google.maps.MapTypeId.SATELLITE
    }

    var map = new google.maps.Map(document.getElementById(aDivId), mapOptions);

    if (showWeather)
    {
	  	var weatherLayer = new google.maps.weather.WeatherLayer({
	    	temperatureUnits: google.maps.weather.TemperatureUnit.CELSIUS,
	    	windSpeedUnit: google.maps.weather.WindSpeedUnit.METERS_PER_SECOND
	  	});
	 	weatherLayer.setMap(map);
    }

	if (showClouds)
	{
	  	var cloudLayer = new google.maps.weather.CloudLayer();
	  	cloudLayer.setMap(map);
	}

	if (customMapIcon != null)
	{
	    var marker = new google.maps.Marker({
	        position: aLocation,
	        map: map,
	        icon: new google.maps.MarkerImage(
        		customMapIcon
        		,null, /* size is determined at runtime */
			    null, /* origin is 0,0 */
			    null, /* anchor is bottom center of the scaled image */
			    new google.maps.Size(80, 120)
        	)
	    });
	}
	else
	{
		var marker = new google.maps.Marker({
	        position: aLocation,
	        map: map
	    });
	}
}

function setupCharts()
{
	if (currentSlide.attr("id") == "active")
	{
		currentSlide.find(".plantPresentation").each(function() {
	        setupChart($(this), "rgb(231, 209, 5)", "rgba(0, 0, 0, 0)");
	    });
	}
	else if (currentSlide.attr("id") == "availability")
	{
		currentSlide.find(".plantPresentation").each(function() {
	        setupChart($(this), "rgb(0, 181, 222)", "rgba(0, 0, 0, 0)");
	    });
	};
}

function setupChartsSmall()
{
	$(".plantPresentation").each(function() {
        setupChart($(this), "rgb(2, 142, 178)", "rgba(0, 0, 0, 0)");
    });
}

function setupChart(presentationObject, valueColor, fillerColor)
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
    var chartOptions = {segmentShowStroke : false, segmentStrokeColor : "#bbb", segmentStrokeWidth : 1, animation: true};
    var myNewChart = new Chart(ctx).Pie(data, chartOptions);
}

function setupFanSpeed()
{
    $(".windicon").each(function() {
        var dataValue = parseInt($(this).closest(".plantPresentation").attr("data-value"));
        var windSpeed = 2000 - ((2000 / 25) * dataValue) + 500;
        if (dataValue > 0)
        {
            $(this).css("animation-duration", windSpeed + "ms");
            $(this).css("-webkit-animation-duration", windSpeed + "ms");
            $(this).css("-ms-animation-duration", windSpeed + "ms");
        }
    });

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
    aNewSlide.find(".bubble").removeClass("bubbleLarge").attr("style", "");
    aNewSlide.find(".bubble div").hide();
}

function setupLabels()
{
	$.getJSON("js/labels.en.js", function(jsonResponse) {
		$("[data-label ^= label_]").each(function () {
			var label = $(this).attr("data-label");
			var labelText = jsonResponse[label];
			$(this).html(labelText);
		});
	});
}

function displayTrend(newValue, oldValue, displayIn)
{
	var trend = "";

	if (newValue > oldValue)
	{
		trend = "&uarr;";
	}
	if (newValue < oldValue)
	{
		trend = "&darr;";
	}
	if (newValue === oldValue)
	{
		trend = "=";
	}
	$(displayIn).html(trend).fadeIn(500);
}

var superFancyNumberGenerator = (function() {
	var counter = 0;
	this.get = function() {return counter++;};
	return this;
})();

function getWindspeed(data)
{
	var result = [];
	$.each(data, function(i, object) {
		var windspeed = {};
		windspeed.name = object['Name'];
		windspeed.value = parseFloat(object['WindSpeed10MinuteAverageMeterPerSecond']).toFixed(1);
		windspeed.unit = "m/s";
		windspeed.lat = object['Latitude'];
		windspeed['long'] = object['Longitude']; // long is a reserved word
		windspeed.plantId = superFancyNumberGenerator.get();
		result.push(windspeed);
	});
	result.sort(function(a,b) {return (b.value === a.value ? 0 : (b.value - a.value > 0 ? 1 : -1));});
	return result.splice(0,3);
}

function getCapacity(data)
{
	var result = [];
	$.each(data, function(i, object) {
		var capacity = {};
		capacity.name = object['Name'];
		capacity.value = parseFloat(object['CapacityFactor']).toFixed(2);
		capacity.unit = "%";
		capacity.lat = object['Latitude'];
		capacity['long'] = object['Longitude'];// long is a reserved word
		capacity.plantId = superFancyNumberGenerator.get();
		result.push(capacity);
	});
	result.sort(function(a,b) {return (b.value === a.value ? 0 : (b.value - a.value > 0 ? 1 : -1));})
	return result.splice(0,3);
}

function getAvailability(data)
{
	var result = [];
	$.each(data, function(i, object) {
		var availability = {};
		availability.name = object['Name'];
		availability.value = parseFloat(object['AvailabilityFactor']).toFixed(2);
		availability.unit = "%";
		availability.lat = object['Latitude'];
		availability['long'] = object['Longitude'];// long is a reserved word
		availability.plantId = superFancyNumberGenerator.get();
		result.push(availability);
	});
	result.sort(function(a,b) {return (b.value === a.value ? 0 : (b.value - a.value > 0 ? 1 : -1));})
	return result.splice(0,3);
}

function computeTotalProductions(data)
{
	var totalValues = {
		totalProductionToday: 0,
		totalProductionYesterday: 0,
		totalProductionPreviousYear: 0,
		totalPowerRightNow: 0,
		maxPossibleProduction: 0
	};
	$.each(data, function(i, object) {
		totalValues.totalProductionToday += parseFloat(object['AccumulatedProductionMWhThisDay']);
		totalValues.totalProductionYesterday += parseFloat(object['AccumulatedProductionMWhPreviousDay']);
		totalValues.totalProductionPreviousYear += parseFloat(object['AccumulatedProductionMWhPreviousYear']);
		totalValues.totalPowerRightNow += parseFloat(object['TotalPowerMWNow']);
		totalValues.maxPossibleProduction += parseFloat(object['MaxCapacityMW']);
	});
	totalValues.totalProductionToday = totalValues.totalProductionToday.toFixed(1);
	totalValues.totalProductionYesterday = totalValues.totalProductionYesterday.toFixed(1);
	totalValues.totalProductionPreviousYear = totalValues.totalProductionPreviousYear.toFixed(1);
	totalValues.totalPowerRightNow = totalValues.totalPowerRightNow;
	totalValues.maxPossibleProduction = totalValues.maxPossibleProduction.toFixed(1);
	return totalValues;
}

function getMarketValue(data)
{
	var result = {
		valueNo: 0,
		valueSe: 0,
		valueUkOffshore: 0,
		valueUkOnshore: 0
	};
	$.each(data, function(i, object) {
		if (object.Code === "NO") {
			result.valueNo = parseFloat(object['MWhisWorthInEuro']);
		} else if (object.Code === "SE") {
			result.valueSe = parseFloat(object['MWhisWorthInEuro']);
		} else if (object.Code === "UK_ONSHORE") {
			result.valueUkOnshore = parseFloat(object['MWhisWorthInEuro']);
		} else if (object.Code === "UK_OFFSHORE") {
			result.valueUkOffshore = parseFloat(object['MWhisWorthInEuro']);
		}
	});
	for (var key in result)
	{
		result[key] = result[key].toFixed(2);
	}
	return result;
}

function getCanSupply(data)
{
	var result = {
		no: 0,
		se: 0,
		uk: 0
	};
	$.each(data, function(i, object) {
		if (object.CountryCode === "NO") {
			result.no = parseFloat(object['NumberOfHouseholdsSupplyNow']);
		} else if (object.CountryCode === "SE") {
			result.se = parseFloat(object['NumberOfHouseholdsSupplyNow']);
		} else if (object.CountryCode === "UK") {
			result.uk = parseFloat(object['NumberOfHouseholdsSupplyNow']);
		}
	});
	for (var key in result)
	{
		result[key] = result[key].toFixed(0);
	}
	return result;
}

var onError = function(error, foo, bar) {
		var logFunc = function(msg) {if (console.log) {console.log(msg);} else {alert(msg)}};
		logFunc("Error ------------");
		logFunc(error);
		logFunc(foo);
		logFunc(bar);
		logFunc("End error --------");
	};

function refresh()
{
    currentCountdown = countdown;

    currentSlide = $("#slides .slide:first-child");

    resetViews(currentSlide);

    $("#countdown").fadeOut(1000);

    var source = "http://nooslpev01/Statkraft.Ts.Information/WMSLive.svc/GetWindParkSummaryNow";
	if (window.location.hash === "#devmode") {
		source = "http://dahlgren.tv/johan/jobb/statkraft/jsonData3.php";
	}

	var onSuccess = function(jsonResponse) {
		response = computeTotalProductions(jsonResponse.WindParks);
		response.measurements = {};
		response.measurements.windspeed = getWindspeed(jsonResponse.WindParks);
		response.measurements.capacity = getCapacity(jsonResponse.WindParks);
		response.measurements.availability = getAvailability(jsonResponse.WindParks);
		response.marketValue = getMarketValue(jsonResponse.MarkedValues);
		response.canSupply = getCanSupply(jsonResponse.HouseholdSupplies);

    	if ($.fn.carouFredSel && !fredselHasBeenInitialized)
		{
			initializeFredsel();
			fredselHasBeenInitialized = true;
		}

    	$("#maxPossibleProduction").text(response.maxPossibleProduction);

		plantPresentationTemplate.into($("#windspeed .contentBlock")).render(response.measurements.windspeed);
		plantPresentationTemplate.into($("#availability .contentBlock")).render(response.measurements.availability);
		plantPresentationTemplate.into($("#active .contentBlock")).render(response.measurements.capacity);

		$("#valueNo").text(response.marketValue.valueNo);
		$("#valueSe").text(response.marketValue.valueSe);
		$("#valueUkOffshore").text(response.marketValue.valueUkOffshore);
		$("#valueUkOnshore").text(response.marketValue.valueUkOnshore);

		$("#supplyValueNo").text(thousandSeparator(response.canSupply.no));
		$("#supplyValueSe").text(thousandSeparator(response.canSupply.se));
		$("#supplyValueUk").text(thousandSeparator(response.canSupply.uk));

		$("#totalProductionToday").text(response.totalProductionToday);
		$("#totalProductionYesterday").text(response.totalProductionYesterday);
		$("#totalProductionPreviousYear").text(response.totalProductionPreviousYear);

		setupMaps();
		setupFanSpeed();
		var updateTime = new Date();
		var paddingHours = "";
		if (updateTime.getHours() < 10)
		{
			paddingHours = "0";
		}
		var paddingMinutes = "";
		if (updateTime.getMinutes() < 10)
		{
			paddingMinutes = "0";
		}
		var paddingSeconds = "";
		if (updateTime.getSeconds() < 10)
		{
			paddingSeconds = "0";
		}

    	$("#hours .timeValue").text(paddingHours + updateTime.getHours());
    	$("#minutes .timeValue").text(paddingMinutes + updateTime.getMinutes());
    	$("#seconds .timeValue").text(paddingSeconds + updateTime.getSeconds());

    	runAnimations();

		if (!hasBeenInitialized)
		{
			$("#loadingLayer").hide();
			hasBeenInitialized = true;
		}
    };

	$.ajax(source, {
		success: onSuccess,
		error: onError,
		dataType: 'jsonp'
	});
}

function refreshSmall()
{
	currentSlide = $("#slides");

	resetViews(currentSlide);

	var source = "http://nooslpev01/Statkraft.Ts.Information/WMSLive.svc/GetWindParkSummaryNow";
	if (window.location.hash === "#devmode") {
		source = "http://dahlgren.tv/johan/jobb/statkraft/jsonData3.php";
	}

	var onSuccess = function(jsonResponse) {
    	response = computeTotalProductions(jsonResponse.WindParks);
		response.measurements = {};
		response.measurements.windspeed = getWindspeed(jsonResponse.WindParks);
		response.measurements.capacity = getCapacity(jsonResponse.WindParks);
		response.measurements.availability = getAvailability(jsonResponse.WindParks);
		response.marketValue = getMarketValue(jsonResponse.MarkedValues);
		response.canSupply = getCanSupply(jsonResponse.HouseholdSupplies);

    	$("#maxPossibleProduction").text(response.maxPossibleProduction);

		plantPresentationTemplate.into($("#windspeed .contentBlock")).render(response.measurements.windspeed);
		plantPresentationTemplate.into($("#capacity .contentBlock")).render(response.measurements.capacity);
		plantPresentationTemplate.into($("#availability .contentBlock")).render(response.measurements.availability);

		$("#valueNo").text(response.marketValue.valueNo);
		$("#valueSe").text(response.marketValue.valueSe);
		$("#valueUkOffshore").text(response.marketValue.valueUkOffshore);
		$("#valueUkOnshore").text(response.marketValue.valueUkOnshore);

		$("#supplyValueNo").text(thousandSeparator(response.canSupply.no));
		$("#supplyValueSe").text(thousandSeparator(response.canSupply.se));
		$("#supplyValueUk").text(thousandSeparator(response.canSupply.uk));

		$("#totalProductionToday").text(response.totalProductionToday);
		$("#totalProductionYesterday").text(response.totalProductionYesterday);

		$("#loading").fadeOut(200);
		$(".container").show();

		setupFanSpeed();
		setupChartsSmall();
		runAnimations();
    }

	$.ajax(source, {
		success: onSuccess,
		error: onError,
		dataType: 'jsonp'
	});
}

function initializeFredsel()
{
    //$(".slide").height($(window).height());
    //$(".slide").width($(window).width());

    $("#slides").carouFredSel({
        items       	: {
        	visible		: 1,
        	//height		: "100%"
        },
        //width        	: "100%",
        //height			: "100%",
        responsive    	: true,
        //auto        	: false,
        auto 			: {
	        duration        : 2000,
	        timeoutDuration : 10000,
	        pauseOnHover    : false
	    },
        prev         	: "#prev",
        next         	: "#next",
        scroll      	: {
        	fx 			: "crossfade",
			easing 		: "linear",
        	onBefore 	: function(data) {
        		newSlide = $("#" + data.items.visible[0].id);
				resetViews(newSlide);
				if (newSlide[0].id == "totalProduction" && rollBackground)
				{
					rollBackgroundImage();
				}
			},
			onAfter 	: function(data) {
				currentSlide = $("#" + data.items.visible[0].id);
				runAnimations();
			}
        },
        onCreate		: function() {
        	//$(".caroufredsel_wrapper").height("100%");
        }
    });
}

function rollBackgroundImage()
{
	currentBackgroundIndex ++;
	if (currentBackgroundIndex >= backgroundImages.length)
	{
		currentBackgroundIndex = 0;
	}
	$("body").css("background-image", "url('" + backgroundImages[currentBackgroundIndex] + "')");
}

function thousandSeparator(aValue)
{
	aValue += '';
	x = aValue.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while (rgx.test(x1)) {
		x1 = x1.replace(rgx, '$1' + ' ' + '$2');
	}
	return x1 + x2;
}

function isIE ()
{
  var myNav = navigator.userAgent.toLowerCase();
  return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
}