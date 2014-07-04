Statkraft.map = (function () {

    //Global variabels
    var selectedMarker;
    var windSmall;
    var hydroSmall;
    var heatingSmall;
    var gasSmall;
    var hydroBig;
    var windBig;
    var heatingBig;
    var gasBig;
    var projectListCounter = 8;

    //Initialization
    var initMap = function () {
        // Show map blocks if javascript is enabled, and hide alert text that is shown for visitors without javascript enabled
        javascriptEnabled();

        //If there's no points to render or any settings exit
        if (!Statkraft.mapSettings || !Statkraft.mapSettings.points || Statkraft.mapSettings.points.length == 0 || $('#BigMap').length == 0) {
            //Hide the differen kinds of maps
            $('#BigMap').addClass('hidden');

            return;
        }

        //Initialize and render google maps markers
        initializeMarkers();

        //Create google map with markers
        createMap();

        //This function decides the actions happening when markers getting clicked
        actionsWhenMarkersGetClicked();

        //This function decides what to show for the different views (map view / list view)
        switchView();

        //This function will render the items in  the project-items-list correct with corresponding css.
        positionItemsInProjectList();

        //This function will render the translated text for the checkbox links
        manageCheckboxes();

        //This function decides wich markers to render accordingly to the clicked checkbox links
        $('.type-checkbox').click(calculateMarkersToDisplay);

        //This function renders a list of projects filtered depending on the checkboxes 
        renderMapProjects();

        //This function auto load more projects on scroll bottom of page.
        autoLoadProjects();

        // Toggle mobile filter menu
        toggleMobileFilterMenu();
    };

    // Show map blocks if javascript is enabled, and hide alert text that is shown for visitors without javascript enabled
    javascriptEnabled = function () {
        $('.jsdisabled').remove();
        $('.jsenabled').show().removeClass('jsenabled');
    }

    //This function auto load more projects on scroll bottom of page.
    function autoLoadProjects() {

        var footerHeight = $('footer').height() + 25,
            winHeight = $(window).height();

        $(window).scroll(function () {
            debounce(function () {
                
                if ($(window).scrollTop() + winHeight >= getDocHeight() - footerHeight) {
                    
                    //checking if there's more projects to load.
                    if (projectListCounter < Statkraft.mapProjects.length) {

                        if ((projectListCounter + 8) > Statkraft.mapProjects.length) {
                            projectListCounter = projectListCounter - (projectListCounter - Statkraft.mapProjects.length);
                            renderMapProjects(projectListCounter, 'scroll');
                        } else {
                            projectListCounter = projectListCounter + 8;
                            //shows the loading animation.
                            $('.load-more-projects-container').removeClass('hidden');
                            $('.load-more-projects').removeClass('hidden');

                            //load more projects
                            renderMapProjects(projectListCounter, 'scroll');

                            //removes the loading animation
                            $('.load-more-projects-container').addClass('hidden');
                            $('.load-more-projects').addClass('hidden');;
                        }

                    } else {
                        //show the no more loading dialog.
                        $('.load-more-projects-container').removeClass('hidden');
                        $('.no-more-loading').removeClass('hidden');
                    }
                }
            }, 200, 'map');
        });
    }

    function getDocHeight() {
        var D = document;
        return Math.max(
            Math.max(D.body.scrollHeight, D.documentElement.scrollHeight),
            Math.max(D.body.offsetHeight, D.documentElement.offsetHeight),
            Math.max(D.body.clientHeight, D.documentElement.clientHeight)
        );
    }


    //This function renders a list of projects filtered depending on the checkboxes 
    function renderMapProjects(_projectListCounter, event) {
        if (_projectListCounter == undefined) {
            _projectListCounter = 8;
        }
        
        
        //Gets the the unchecked types we're going to filter out.
        var uncheckedTypesHtmlArray = $('.type-checkbox.unchecked');
        var uncheckedTypesArray = new Array();
        for (var u = 0; u < uncheckedTypesHtmlArray.length; u++) {
            uncheckedTypesArray.push($(uncheckedTypesHtmlArray[u]).attr("type"));
        }

        //Creating the array that's going to contain the filtered projects.
        var filteredMapProjectsArray = [];
        var currentCountry, selectedCountry = "";

        //Looping through all the projects.
        for (var i = 0; i < Statkraft.mapProjects.length; i++) {
            var project = Statkraft.mapProjects[i];

            /*
            //We're checking if the projects map point type is in the uncheckedTypesArray, if it's not in the array we will add the project to filteredMapProjectsArray.
            if (jQuery.inArray(project.MapPointType, uncheckedTypesArray) < 0) {
                filteredMapProjectsArray.push(project);
            }
            */
            
            /*-------------------------------------
                START NEW SCRIPT CODE FOR SEARCH
            -------------------------------------*/
            
            var searchString = $("#map-search").val();
            
            // If a search string has been entered, we display projects whose names match the search string.
            // If a country has been selected, we only display projects from that country.
            // Otherwise, we display the projects of the selected types.
            
            if (searchString !== "") {
                var searchRegex = new RegExp("." + searchString + ".", 'i');
                if (searchRegex.test(project.MapProjectName)) {
                    filteredMapProjectsArray.push(project);
                }
            } else {
                // Find all selected countries

                $("#map-country-select .type-checkbox.checked").each(function (index, item) {
                    selectedCountries.push($(item).attr("data-text"));
                });

                // Find all selected energy sources

                $("#map-energy-source-select .type-checkbox.checked").each(function (index, item) {
                    selectedSources.push($(item).attr("data-text"));
                });

                // Show the projects that match the selection.

                for (var marker in Statkraft.Markers) {
                    if ($.inArray(Statkraft.Markers[marker].type, selectedSources) != -1 && $.inArray(Statkraft.Markers[marker].country, selectedCountries) != -1) {
                        filteredMapProjectsArray.push(project);
                    }
                }
            } 
            
            /*-------------------------------------
                END NEW SCRIPT CODE FOR SEARCH
            -------------------------------------*/
            
        }

        //Each time a filter checkbox is clicked we'll empty all projects so we can fill it with new filtered projects.
        var ul = $('.project-list');
        var start = 0;
        
        if (event === 'scroll') {
            start = ul.find('li').length;
        } else {
            ul.empty();
        }

        //Creating the html for the project blocks.
        for (var index = start;index < _projectListCounter && index < filteredMapProjectsArray.length; index++) {
            var mapProject = filteredMapProjectsArray[index];

            $(ul).append(
                '<li>' +
                    '<div class="project-item ' + mapProject.MapPointType.toLowerCase().replace(' ', '-') + '">' +
                        '<a href="' + mapProject.MapProjectUrl + '" ' +
                            '<p class="' + mapProject.MapPointType.toLowerCase().replace(' ', '-') + '-item header"><span class="cell">' + mapProject.MapProjectTranslateText + '</span><span class="marker"></span></p>' +
                            '<span class="project-image-wrapper"><img src="' + mapProject.ImageUrl + '?width=320&amp;height=214&amp;mode=crop&amp;scale=both" ' +
                            'alt="' + mapProject.ImageAltText + '"/></span>' +
                                '<p class="project-country">' + mapProject.MapProjectCountry + '</p>' +
                                '<h3>' + mapProject.MapProjectName + '</h3>' +
                            '<p class="project-list-exerpt">' + mapProject.MapProjectExcerptWithFallBack + '</p>' +
                        '</a>' +
                    '</div>' +
                '</li>');
        }

        if ($('.listview').hasClass('active')) {
            $('.project-list-exerpt').show();
        }

        positionItemsInProjectList();
        
        projectListCounter = ul.find('li').length;
    }


    //Closes the factbox and changes the marker icon to a smaller icon
    function closeFactBox(clickEvent) {

        clickEvent.preventDefault();

        $('.mapFactsBox').removeClass('box-is-open').addClass('box-is-closed');
        $('.mapFactsBox').hide();
        $('.project-item.active').removeClass('active');

        if (selectedMarker != undefined) {
            if (selectedMarker.type == "Hydropower") {
                selectedMarker.setIcon(hydroSmall);
            }

            if (selectedMarker.type == "Wind power") {
                selectedMarker.setIcon(windSmall);
            }

            if (selectedMarker.type == "District heating") {
                selectedMarker.setIcon(heatingSmall);
            }

            if (selectedMarker.type == "Gas power") {
                selectedMarker.setIcon(gasSmall);
            }
        }
    }

    //This function will render the translated text for the checkbox links
    function manageCheckboxes() {
        $('.type-checkbox').each(function (index) {
            $(this).append($(this).attr('data-text'));
        });
    }

    ////This function will render the items in  the project-items-list correct with corresponding css.
    function positionItemsInProjectList() {
        var items = $('.project-list').find("li").filter(function (index, el) {
            return $(el).css('display') !== 'none';
        });

        //remove the class if the list has been modified allready, we want to render new fourthitem if the checkboxes have been clicked.
        items.removeClass('fourth-item third-item');

        //adding a css class deciding the correct padding for each fourth or third item in the project-item-list depending on if map view or grid view
        items.each(function (index, el) {
            index++;
            if ((index !== 0 && index % 4 === 0) && !$('.project-list').hasClass('big-grid') ) {
                $(el).addClass('fourth-item');
            } else if ((index !== 0 && index % 3 === 0) && $('.project-list').hasClass('big-grid')) {
                $(el).addClass('third-item');
            }
        });

        //
        toggleMobileExerpts();
    }

    //Initialize and render google maps markers
    function initializeMarkers() {
        windSmall = {
            url: '/Content/images/map-markers/wind-small.png',
            // This marker is 26 pixels wide by 26 pixels tall.
            size: new google.maps.Size(26, 26),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(13, 13)
        };

        hydroSmall = {
            url: '/Content/images/map-markers/water-small.png',
            // This marker is 25 pixels wide by 25 pixels tall.
            size: new google.maps.Size(26, 26),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(13, 13)
        };

        heatingSmall = {
            url: '/Content/images/map-markers/heating-small.png',
            // This marker is 25 pixels wide by 25 pixels tall.
            size: new google.maps.Size(25, 25),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(12, 12)
        };

        gasSmall = {
            url: '/Content/images/map-markers/gas-small.png',
            // This marker is 25 pixels wide by 25 pixels tall.
            size: new google.maps.Size(25, 25),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(12, 12)
        };

        hydroBig = {
            url: '/Content/images/map-markers/water-big.png',
            // This marker is 26 pixels wide by 26 pixels tall.
            size: new google.maps.Size(50, 50),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(25, 25)
        };

        windBig = {
            url: '/Content/images/map-markers/wind-big.png',
            // This marker is 26 pixels wide by 26 pixels tall.
            size: new google.maps.Size(50, 50),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(25, 25)
        };

        heatingBig = {
            url: '/Content/images/map-markers/heating-big.png',
            // This marker is 26 pixels wide by 26 pixels tall.
            size: new google.maps.Size(50, 50),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(25, 25)
        };

        gasBig = {
            url: '/Content/images/map-markers/gas-big.png',
            // This marker is 26 pixels wide by 26 pixels tall.
            size: new google.maps.Size(50, 50),
            // The origin for this image is 0,0.
            origin: new google.maps.Point(0, 0),
            // The anchor for this image is at the middle of the image
            anchor: new google.maps.Point(25, 25)
        };
    }

    //This function decides what to show for the different views (map view / list view)
    function switchView() {

        var $mapFactsBox = $('.mapFactsBox'),
            $projectList = $('.project-list');

        //Show the map and hide the exerpt for the project items in project-items-list.
        $('.mapview').click(function () {
            $('#BigMap').show();
            $projectList.removeClass('big-grid');
            $('.third-item').removeClass();
            $('li:nth-child(4n)', $projectList).addClass('fourth-item');

            //$('.project-list-exerpt').hide();
            $('.mapview').addClass('active');
            $('.listview').removeClass('active');

            if ($mapFactsBox.hasClass('box-is-open')) {
                $mapFactsBox.show();
            }
            //This is preventing the click event forcing the screen to the top.
            return false;
        });

        //Hide the map and show the exerpt for the project items in project-items-list.
        $('.listview').click(function () {
            $('#BigMap').hide();
            $projectList.addClass('big-grid');
            $('.fourth-item').removeClass();
            $('li:nth-child(3n)', $projectList).addClass('third-item');

            //$('.project-list-exerpt').show();
            $('.listview').addClass('active');
            $('.mapview').removeClass('active');
            if ($mapFactsBox.hasClass('box-is-open')) {
                $mapFactsBox.hide();
            }

            //This is preventing the click event forcing the screen to the top.
            return false;
        });
    }

    //This function decides the actions happening when markers getting clicked
    function actionsWhenMarkersGetClicked() {

        for (var markerPosition in Statkraft.Markers) {

            // HÄR BEHÖVS REFAKTORERING, varför behövs marker.

            //When the next marker is clicked we'll change back the icon for the previous marker to the small-marker-icon 
            var marker = Statkraft.Markers[markerPosition];
            google.maps.event.addListener(marker, 'click', function () {

                if (selectedMarker != undefined) {
                    if (selectedMarker.type == "Hydropower") {
                        selectedMarker.setIcon(hydroSmall);
                    }

                    if (selectedMarker.type == "Wind power") {
                        selectedMarker.setIcon(windSmall);
                    }

                    if (selectedMarker.type == "District heating") {
                        selectedMarker.setIcon(heatingSmall);
                    }

                    if (selectedMarker.type == "Gas power") {
                        selectedMarker.setIcon(gasSmall);
                    }
                }

                //We change the marker icon for the currently clicked marker to a bigger marker-icon
                if (this.type == "Hydropower") {
                    this.setIcon(hydroBig);
                }

                if (this.type == "Wind power") {
                    this.setIcon(windBig);
                }

                if (this.type == "District heating") {
                    this.setIcon(heatingBig);
                }

                if (this.type == "Gas power") {
                    this.setIcon(gasBig);
                }

                selectedMarker = this;
                window.markerX = selectedMarker;

                var $mapFactsBlock = $('.mapFactsBox');

                //We clear all the html in the fact box. 
                $mapFactsBlock.empty();

                //We match the id so we can render the project-item data into the fact box.
                var item = $('.project-list').find('a').filter(function (index, el) {
                    return $(el).data('id') == selectedMarker.pageId;
                });

                //Creating the fact box with the following html elements and insert project-item data to the corresponding html items.
                    
                $mapFactsBlock.prepend('<div class="fact-projectlink-container"><a class="fact-projectlink" href="' + selectedMarker.point.MapProjectUrl + '" >' + selectedMarker.point.MapProjectLinkText + '</a></div>');
                $mapFactsBlock.prepend('<div class="fact-mainbody"><h2>' + selectedMarker.point.MapProjectName + '</h2>' + $('<div/>').html(selectedMarker.point.MapProjectFacts).text() + '</div>');
                
                $('.project-item.active').removeClass('active');
                $(item).parent('.project-item').addClass('active');

                $mapFactsBlock.prepend('<img class="fact-image ' + selectedMarker.point.MapPointType.toLowerCase().replace(' ', '-') + '" src="' + selectedMarker.point.ImageUrl + '?width=322&height=214&mode=crop&scale=both" alt="' + selectedMarker.point.ImageAltText + '"></img>');
                $mapFactsBlock.prepend('<a href="#" class="factbox-close"></a>');

                //Making fact box visible
                $mapFactsBlock.show();

                //Closing the factbox when the closing link is clicked
                //We're also adding a css class so we can determine if the factbox should stay open or closed when we switch view (map-view / list-view)
                $mapFactsBlock.removeClass('box-is-closed').addClass('box-is-open');
                $('.factbox-close').click(closeFactBox);
            });
        }
    }

    //Create google map with markers
    function createMap() {

        //Sets the map options for the google map
        var mapOptions = {
            scrollwheel: false,
            zoom: Statkraft.mapSettings.Zoom,
            minZoom: 2,
            center: new google.maps.LatLng(Statkraft.mapSettings.Center.Latitude, Statkraft.mapSettings.Center.Longitude),
            mapTypeControlOptions: {
                mapTypeIds: [google.maps.MapTypeId.SATELLITE, 'map_style']
            }
        };

        //Creating the map and adds the markers
        var map = new google.maps.Map(document.getElementById('BigMap'), mapOptions);
        var styledMap = new google.maps.StyledMapType(Statkraft.mapFunctions.mapStyle(), { name: "Map" });
        map.mapTypes.set('map_style', styledMap);
        map.setMapTypeId('map_style');

        Statkraft.Markers = [];

        for (var n in Statkraft.mapSettings.points) {
            if (Statkraft.mapSettings.points[n].MapPointType === "Wind power") {
                addMarkerForWindPowerPoint(Statkraft.mapSettings.points[n], map);
            }
            else if (Statkraft.mapSettings.points[n].MapPointType === "Hydropower") {
                addMarkerForHydropowerPoint(Statkraft.mapSettings.points[n], map);
            }
            else if (Statkraft.mapSettings.points[n].MapPointType === "District heating") {

                addMarkerForDistrictHeatingPoint(Statkraft.mapSettings.points[n], map);
            }
            else if (Statkraft.mapSettings.points[n].MapPointType === "Gas power") {

                addMarkerForGasPowerPoint(Statkraft.mapSettings.points[n], map);
            }
        }
    }
    
    function findProjectForPoint(point) {
        for (var i = 0; i < Statkraft.mapProjects.length; i++) {
            if (Statkraft.mapProjects[i].MapProjectPageLink == point.PageId) {
                return Statkraft.mapProjects[i];
            }
        }
    }

    //Creating marker for Wind power
    function addMarkerForWindPowerPoint(point, map) {

        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(point.Coordinate.Latitude, point.Coordinate.Longitude),
            map: map,
            icon: windSmall,
            animation: google.maps.Animation.DROP,
            title: point.Name,
            type: "Wind power",
            point: findProjectForPoint(point)
        });

        marker.pageId = point.PageId;

        Statkraft.Markers.push(marker);
    }

    //Creating marker for tidal power
    function addMarkerForHydropowerPoint(point, map) {

        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(point.Coordinate.Latitude, point.Coordinate.Longitude),
            map: map,
            icon: hydroSmall,
            animation: google.maps.Animation.DROP,
            title: point.Name,
            type: "Hydropower",
            point: findProjectForPoint(point)
        });

        marker.pageId = point.PageId;

        Statkraft.Markers.push(marker);
    }

    //Creating marker for heatingTurbine
    function addMarkerForDistrictHeatingPoint(point, map) {

        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(point.Coordinate.Latitude, point.Coordinate.Longitude),
            map: map,
            icon: heatingSmall,
            animation: google.maps.Animation.DROP,
            title: point.Name,
            type: "District heating",
            point: findProjectForPoint(point)
        });

        marker.pageId = point.PageId;

        Statkraft.Markers.push(marker);
    }

    //Creating marker for gasTurbine
    function addMarkerForGasPowerPoint(point, map) {

        var marker = new google.maps.Marker({
            position: new google.maps.LatLng(point.Coordinate.Latitude, point.Coordinate.Longitude),
            map: map,
            icon: gasSmall,
            animation: google.maps.Animation.DROP,
            title: point.Name,
            type: "Gas power",
            point: findProjectForPoint(point)
        });

        marker.pageId = point.PageId;

        Statkraft.Markers.push(marker);
    }

    //This function decides wich markers to render accordingly to the clicked checkbox links
    function calculateMarkersToDisplay(event) {
        event.preventDefault();
        $('.load-more-projects-container').addClass('hidden');
        $('.no-more-loading').addClass('hidden');

        var clickedCheckbox = $(this);

        if (clickedCheckbox.hasClass("checked")) {
            clickedCheckbox.children().first().removeClass("checked").addClass("unchecked");
            clickedCheckbox.removeClass("checked").addClass("unchecked");
        } else {
            clickedCheckbox.children().first().removeClass("unchecked").addClass("checked");
            clickedCheckbox.removeClass("unchecked").addClass("checked");
        }
        
        var checkboxValue = "";
        var selectedCountries = [];
        var selectedSources = [];

        // Find all selected countries
        
        $("#map-country-select .type-checkbox.checked").each(function (index, item) {
            selectedCountries.push($(item).attr("data-text"));
            console.log($(item).attr("data-text"));
        });

        // Find all selected energy sources
        
        $("#map-energy-source-select .type-checkbox.checked").each(function (index, item) {
            selectedSources.push($(item).attr("data-text"));
            console.log($(item).attr("data-text"));
        });

        // Show the markers that match the selection.
        // Hide the others.

        for (var marker in Statkraft.Markers) {
            if ($.inArray(Statkraft.Markers[marker].type, selectedSources) == -1 && $.inArray(Statkraft.Markers[marker].country, selectedCountries) == -1) {
                Statkraft.Markers[marker].setVisible(false);
            } else {
                Statkraft.Markers[marker].setVisible(true);
            }
        }

        renderMapProjects();

        //After filtering what project items to show in the project-item-list, we need to recount the fourth item.  
        positionItemsInProjectList();

        //This is preventing the click event forcing the screen to the top.
        return false;
    };

    toggleMobileFilterMenu = function() {
        $('.mobile-filter-menu').click(function() {
            $(this).toggleClass('open');
        });
    };

    toggleMobileExerpts = function() {
        $('.project-item .header .marker').off().on('click', function(e) {
            e.stopPropagation();
            e.preventDefault();
            $(this).parents('.project-item').toggleClass('open');
        });
    };
    
    /*-------------------------------------
        START NEW SCRIPT CODE FOR SEARCH
    -------------------------------------*/
    
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
                $("#map-country-select .map-dropdown").append("<li class=\"checkbox-item\"><a type=\"" + currentCountry + "\" href=\"http://statkraft.com/about-statkraft/Projects/#\" data-text=\"" + currentCountry + "\"></a></li>");
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
            console.log(selection.value);  

            $.each(Statkraft.mapProjects, function(index, plant) {
                if (plant.MapProjectName == selection.value) {
                    window.location = plant.MapProjectUrl;
                }
            });
        });
    });

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

            console.log("Anropar rendermetoden...");
            renderMapProjects();

            cb(matches);
        };
    };
    
    /*-------------------------------------
        END NEW SCRIPT CODE FOR SEARCH
    -------------------------------------*/

    //Return functions that should be public
    return {
        initMap: initMap
    };

}());
