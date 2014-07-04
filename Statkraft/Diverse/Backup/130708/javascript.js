var countdown                   = 20; //600
var currentCountdown            = countdown;
var countdownSliderStartHeight  = 999;
var plantPresentationTemplate   = null;
var fredselHasBeenInitialized   = false;
var valueColor                  = "#ff642a";
var fillerColor                 = "#e9eae5";


function animateNumbers(targetDiv, currentVal, endVal)
{
    var i = setInterval(function ()
    {
        if (currentVal >= endVal)
        {
            clearInterval(i);
        }
        else
        {
            currentVal = currentVal + 10;
            targetDiv.text(currentVal);
        }
    }, 10);
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

function refresh(isLargeView)
{
    currentCountdown = countdown;
    $("#countdownSlider").height(countdownSliderStartHeight);
    
    $.getJSON("jsonData.json", function(response) {
        plantPresentationTemplate.into($("#windspeed .dataContent")).render(response.measurements.windspeed);
        plantPresentationTemplate.into($("#capacity .dataContent")).render(response.measurements.capacity);
        plantPresentationTemplate.into($("#availability .dataContent")).render(response.measurements.availability);
        
        $("#nordpool").text(response.marketValue.nordpool);
        $("#nasdaq").text(response.marketValue.nasdaq);
        
        setupMaps();
        setupCharts();
        setupFanSpeed();
        
        if(isLargeView)
        {
            var updateTime = new Date();
            var padding = "";
            if (updateTime.getMinutes() < 10)
            {
                padding = "0";
            }
            $("#latestUpdate").text(updateTime.getHours() + ":" + padding + updateTime.getMinutes());
            
            if (!fredselHasBeenInitialized)
            {
                initializeFredsel();
                fredselHasBeenInitialized = true;
            }
        }
        
        animateNumbers($("#totalProductionValue .value"), 0, response.totalProductionValue);
    });
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
    $(".plantPresentation").each(function() {
        if ($(this).closest(".slide").attr("id") != "windspeed")
        {
            setupChart($(this));
        }
    });
    
}

function setupChart(presentationObject)
{
    var data = [
        {
            value: parseInt($(presentationObject).attr("data-value")),
            value: 23,
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

function initializeFredsel()
{
    $(".slide").height($(window).height());
    $(".slide").width($(window).width());
    
    $("#slides").carouFredSel({
        items       : 1,
        width        : "100%",
        responsive    : true,
        auto        : false,
        /*
        auto : {
        //easing          : "elastic",
        duration        : 1000,
        timeoutDuration    : 5000,
        pauseOnHover    : false
    },
        */
        prev         : "#prev",
        next         : "#next"
    });
}