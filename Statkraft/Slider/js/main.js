var doit;
var numberOfSliderItems = 0;

function isSmallScreen () {
	var windowWidth = $(window).width();
	if (windowWidth < 768) {
		return true;
	} else {
		return false;
	}
}

function debug(aText) {
	$("#debug").html(aText);
}

function fitText(aSelector, aContainerSelector, aPadding, aMaxWidth, aPaddingSmall, aAdjustLineHeight) {
	if ($(window).width() >= 768) {
		$(aSelector).each(function () {
			var width 			= $(this).width();
			var containerWidth 	= $(aContainerSelector).width();
			var safety 			= 0;

			debug("selector: " + aSelector + ", width: " + width + ", containerWidth: " + containerWidth);

			while (((width + aPadding) > containerWidth || (width + aPadding) > aMaxWidth) && safety < 200) {
				var temp 		= $(aSelector).css("font-size");
				var fontSize 	= parseInt(temp.substring(0, temp.length - 2));
				$(aSelector).css("font-size", fontSize - 1 + "px");
				if (aAdjustLineHeight) {
					$(aSelector).css("line-height", (fontSize * 3) + "px");
				}
				safety ++;
				width 			= $(this).width();
				containerWidth 	= $(aContainerSelector).width();
			}
		});
	} else if ($(window).width() >= 320) {
		$(aSelector).each(function () {
			var width 			= $(this).find("span").width();
			var containerWidth 	= $(window).width();
			var safety 			= 0;

			debug("selector: " + aSelector + ", width: " + width + ", containerWidth: " + containerWidth);

			while (((width + aPaddingSmall) > containerWidth) && safety < 200) {
				var temp 		= $(aSelector).css("font-size");
				var fontSize 	= parseInt(temp.substring(0, temp.length - 2));
				$(aSelector).css("font-size", fontSize - 1 + "px");
				if (aAdjustLineHeight) {
					$(aSelector).css("line-height", (fontSize * 3) + "px");
				}
				safety ++;
				width 			= $(this).find("span").width();
				containerWidth 	= $(window).width();
			}
		});
	}
}

function fitDivWidth(aSelector, aContainerSelector, aPadding, aMaxWidth) {
	if ($(window).width() > 767) {
		$(aSelector).each(function () {
			var newWidth = $(aContainerSelector).width() - aPadding;
			if (newWidth > aMaxWidth) {
				newWidth = aMaxWidth;
			}
			$(aSelector).css("max-width", newWidth);
		});
	}
}

function fitTexts() {
	fitText(".slider_textWrapper h3", "#slider_paginationOuterWrapper", 100, 1360, 50, false);
	fitText(".slider_paginationText", "#slider_pagination a", 0, 1360, 0, true);
	fitDivWidth(".slider_textWrapper p", "#slider_paginationOuterWrapper", 200, 900);
}

function refresh() {
	initializeFredsel();
	fitTexts();
}

function initializeFredsel () {
	var visibleItems    = 0;
    var startItem       = 0;
    var deviation       = 0;
	var responsive		= false;
    var activeElement   = 0;
    
    if (numberOfSliderItems < 3) {
        visibleItems    = 1;
        startItem       = 0;
        activeElement   = 0;
    } else {
        visibleItems 	= 3;
        startItem 		= -1;
        activeElement   = 1;
        deviation       = 1;
    }
    
	if (isSmallScreen()) {
		visibleItems 	= 1;
		startItem 		= 0;
		responsive		= true;
	}

	$("#slider_carousel").carouFredSel({    
		width			: "100%",
        circular        : true,
		infinte			: true,
		responsive		: responsive,
		items			: {
			visible: visibleItems,
			start: startItem,
			minimum: 2
		},
		swipe			: {
			onTouch		: true,
			onMouse		: true
		},
		scroll			: {
			items: 1,
			duration: 500,
			timeoutDuration: 100,
			onBefore 	: function(data) {
				var visibleItem = data.items.old[activeElement];
				$(visibleItem).find(".slider_textWrapper h3").removeClass("slider_show");
				$(visibleItem).find(".slider_textWrapper p").removeClass("slider_show");
				$(visibleItem).find(".slider_textWrapper a").removeClass("slider_show");
			},
			onAfter 	: function(data) {
				var visibleItem = data.items.visible[activeElement];
				$(visibleItem).find(".slider_textWrapper h3").addClass("slider_show");
				setTimeout(function() {
					$(visibleItem).find(".slider_textWrapper p").addClass("slider_show");
					$(visibleItem).find(".slider_textWrapper a").addClass("slider_show");
				}, 500);
			}
		},
		prev			: "#slider_prev",
		next			: "#slider_next",
		pagination		: {
			container: "#slider_pagination",
			deviation: deviation,
			anchorBuilder : false
		},
		auto 			: {
			play		: false
		},
		onCreate		: function () {
			fitTexts();
		}
	});
}

$(document).ready(function() {
	$(".slider_carouselItem").click(function () {
		var url = $(this).find(".slider_actionButton").attr("href");
		document.location.href = url;
	});

	$(window).resize(function() {
		clearTimeout(doit);
  		doit = setTimeout(refresh, 100);
        
        var windowWidth = $(window).width();
        $(".slider_centerSlide").css("max-width", windowWidth + "px");
	});
    
    var windowWidth = $(window).width();
        $(".slider_centerSlide").css("max-width", windowWidth + "px");

	setTimeout(function () {
		refresh();
	}, 100);
    
    numberOfSliderItems =  $(".slider_carouselItem").size();
    
    if (numberOfSliderItems < 3) {
        $(".slider_carouselItem:first-child .slider_textWrapper h3").addClass("slider_show");
        setTimeout(function() {
            $(".slider_carouselItem:first-child .slider_textWrapper p").addClass("slider_show");
            $(".slider_carouselItem:first-child .slider_textWrapper a").addClass("slider_show");
        }, 500);
    }
    if (numberOfSliderItems < 2) {
        $("#slider_paginationOuterWrapper").hide();
    }
});