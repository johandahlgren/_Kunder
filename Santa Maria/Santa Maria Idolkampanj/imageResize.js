var imageUrl, newImageUrl   = "";

var articleImageSizes       = {};
articleImageSizes.desktop   = 1920;
articleImageSizes.pad       = 768;
articleImageSizes.mobile    = 320;

var halfImageSizes          = {};
halfImageSizes.desktop      = 600;
halfImageSizes.pad          = 600;
halfImageSizes.mobile       = 300;

var thirdImageSizes         = {};
thirdImageSizes.desktop     = 400;
thirdImageSizes.pad         = 600;
thirdImageSizes.mobile      = 300;

setImageSizes();

$(window).on("resize", function() {
    setImageSizes();
});

function setImageSizes() {
    var windowWidth = $(window).width();

    if (windowWidth > 768) {
        screenSize = "desktop";
    } else if (windowWidth > 360) {
        screenSize = "pad";
    } else {
        screenSize = "mobile";
    }

    $("article[data-image]").each(function() {
        $(this).css("background-image", "url(" + getModifiedImageUrl($(this).attr("data-image"), articleImageSizes[screenSize]) + ")");
    });

    $(".blocks-2 .blockimage img[data-image]").each(function() {
        $(this).attr("src", getModifiedImageUrl($(this).attr("data-image"), halfImageSizes[screenSize]));
    });

    $(".blocks-3 .blockimage img[data-image]").each(function() {
        $(this).attr("src", getModifiedImageUrl($(this).attr("data-image"), thirdImageSizes[screenSize]));
    });
}

function getModifiedImageUrl(aImageUrl, aNewWidth) {
    if (aImageUrl && aImageUrl.length > 0) {
        var newImageUrl = aImageUrl.substring(0, aImageUrl.length);
        if (newImageUrl.indexOf("?") > -1) {
            newImageUrl = newImageUrl.substring(0, newImageUrl.indexOf("?"));
        }
        newImageUrl = newImageUrl + "?width=" + aNewWidth;

        return newImageUrl;
    } else {
        return aImageUrl;
    }
}