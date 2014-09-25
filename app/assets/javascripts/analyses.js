/**
 * Created by scottaubert2 on 9/25/14.
 */

$(document).ready(function() {
    var handler, heatmap, map;

    /*handler = Gmaps.build('Google');
     handler.buildMap({ provider: {}, internal: {id: 'map'}, offsetWidth: 200}, function () {
     markers = handler.addMarkers([
     {
     "lat": 37.774546,
     "lng": -122.433523,
     "picture": {
     "url": "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
     "width": 36,
     "height": 36
     },
     "infowindow": "hello!"
     }
     ]);
     handler.bounds.extendWith(markers);
     handler.fitMapToBounds();
     });
     */
    var mapOptions = {
        zoom: 10,
        center: new google.maps.LatLng(center_point.lat, center_point.lon),
        mapTypeId: google.maps.MapTypeId.MAP
    };

    map = new google.maps.Map(document.getElementById('map'),
        mapOptions);

    var foodData = [];
    for (var i = 0; i < food_data.length; i++) {
        foodData.push(new google.maps.LatLng(food_data[i].lat, food_data[i].lon));
    }

    var pointArray = new google.maps.MVCArray(foodData);
    heatmap = new google.maps.visualization.HeatmapLayer({
        data: pointArray
    });

    heatmap.setMap(map);


    //markers = handler.addMarkers(<%=raw @hash.to_json %>);
})




