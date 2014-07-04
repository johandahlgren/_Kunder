//Helper functions for the maps
Statkraft.mapFunctions = (function () {

    // These two method returns different style for the map
    // The styles are generated with: http://gmaps-samples-v3.googlecode.com/svn/trunk/styledmaps/wizard/index.html

    // Returns the default map style
    // With poi turned off
    function mapStyle() {
        return  [{ "featureType": "landscape.natural", "elementType": "geometry.fill", "stylers": [ { "color": "#f1efec" }, { "lightness": -4 } ] },{ "featureType": "water", "elementType": "geometry.fill", "stylers": [ { "color": "#ffffff" } ] },{ "featureType": "road", "stylers": [ { "visibility": "off" } ] },{ },{ "featureType": "poi", "elementType": "geometry", "stylers": [ { "visibility": "off" } ] },{ "featureType": "transit", "stylers": [ { "visibility": "off" } ] },{ "featureType": "water", "elementType": "labels", "stylers": [ { "visibility": "off" } ] },{ "featureType": "poi", "stylers": [ { "visibility": "off" } ] },{ "featureType": "administrative.locality", "stylers": [ { "visibility": "off" } ] },{ "featureType": "administrative.country", "elementType": "labels.text.stroke", "stylers": [ { "color": "#808080" }, { "visibility": "off" } ] },{ "featureType": "administrative.country", "elementType": "labels.text.fill", "stylers": [ { "color": "#575757" } ] },{ "featureType": "administrative.country", "elementType": "geometry.stroke", "stylers": [ { "lightness": 100 }, { "visibility": "on" }, { "weight": 1.7 } ] } ];
    }

    return {
        mapStyle: mapStyle
    };

})();