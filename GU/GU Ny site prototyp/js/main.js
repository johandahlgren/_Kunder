$(document).ready(function () {
    $("#menuButton").click(function () {
        $("#topMenu").toggle();
    });
    $("#topMenu > div > a").click(function () {
        $("#topMenu .selected").each(function () {
            $(this).removeClass("selected");
        });
        $(this).parent().addClass("selected");
    });
    
    $("#topMenu > div > div > div > a").click(function () {
        $("#topMenu > div > div > div.selected").each(function () {
            $(this).removeClass("selected");
        });
        $(this).parent().addClass("selected");
    });
    
    $(window).resize(function () {
        placeMenu();
    });
    
    placeMenu();
});

function placeMenu () {
    if ($(window).width() < 960) {
        $("#pageMenu").appendTo("#topMenu .selected .selected");
    } else {
        $("#pageMenu").prependTo("#content");
    }
}