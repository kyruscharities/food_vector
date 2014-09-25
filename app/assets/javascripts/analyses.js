/**
 * Created by scottaubert2 on 9/25/14.
 */

$(document).ready(function() {
    var handler, map;

    var mapOptions = {
        zoom: 3,
        center: new google.maps.LatLng(center_point.lat, center_point.lon),
        mapTypeId: google.maps.MapTypeId.MAP
    };

    map = new google.maps.Map(document.getElementById('map'),
        mapOptions);

    var foodData = [];
    for (var i = 0; i < food_data.length; i++) {
        foodData.push({location: new google.maps.LatLng(food_data[i].geo_region.center_lat,
            food_data[i].geo_region.center_lon), weight: parseInt(food_data[i].risk_score)});
    }

    heatmap = new google.maps.visualization.HeatmapLayer({
        data: foodData,
        dissipating: false,
//        maxIntensity: 1000,
        radius: 0.5
    });

    heatmap.setMap(map);

    function toggleHeatmap() {
        heatmap.setMap(heatmap.getMap() ? null : map);
    }
})




