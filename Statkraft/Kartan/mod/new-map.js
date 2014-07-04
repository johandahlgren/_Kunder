$(document).ready(function () {
    $(".dropdown-header").click(function () {
        $(this).closest(".select-map-options-box").find(".map-dropdown").toggle();
        $(this).toggleClass("expanded");
    });

    var plants = [];
    var countries = [];
    var currentCountry = "";
    
    $.each(Statkraft.mapProjects, function(index, plant) {
        plants.push(plant.MapProjectName);
        currentCountry = plant.MapProjectCountry;
                        
        if ($.inArray(currentCountry, countries) == -1) {
            countries.push(currentCountry);
            $("#map-country-select .map-dropdown").append("<li class=\"checkbox-item\"><a class=\"type-checkbox checked\" type=\"" + currentCountry + "\" href=\"http://statkraft.com/about-statkraft/Projects/#\" data-text=\"" + currentCountry + "\"><span class=\"checkbox-marker\"></span></a></li>");
        }
    });
    
    $(".map-search").typeahead({
        hint: true,
        highlight: true,
        minLength: 1
    }, {
        name: "plants",
        displayKey: "value",
        source: substringMatcher(plants)
    });
    
    $(".map-search").bind("typeahead:selected", function(obj, selection) {
        $.each(Statkraft.mapProjects, function(index, plant) {
            if (plant.MapProjectName == selection.value) {
                window.location = plant.MapProjectUrl;
            }
        });
    });
    
    $("#map-country-select ul li a").click(function() {
        filterOnCountry();
    });
});

function filterOnCountry() {
    var currentCountry = "";
    var selectedCountry = $("#map-country-select ul li a.selected").attr("data-text");

    $.each(Statkraft.mapProjects, function(index, plant) {
        currentCountry = plant.MapProjectCountry.trim();

        if (currentCountry == selectedCountry || selectedCountry == "All") {
            console.log("Lägger till: " + plant.MapProjectName);
        }
    });
}

var substringMatcher = function (strs) {
    return function findMatches(q, cb) {
        var matches, substringRegex;

        // an array that will be populated with substring matches
        matches = [];

        // regex used to determine if a string contains the substring `q`
        substrRegex = new RegExp(q, 'i');

        // iterate through the pool of strings and for any string that
        // contains the substring `q`, add it to the `matches` array
        $.each(strs, function (i, str) {
            if (substrRegex.test(str)) {
                // the typeahead jQuery plugin expects suggestions to a
                // JavaScript object, refer to typeahead docs for more info
                matches.push({
                    value: str
                });
            }
        });
        cb(matches);
    };
};