/**
 * Created by scottaubert2 on 9/25/14.
 */

$(document).ready(function () {
    $('body.analyses.show').ready(function () {
        console.log("loading show stuff");
        var handler, map;

        var mapOptions = {
            center: new google.maps.LatLng(center_point.lat, center_point.lon),
            mapTypeId: google.maps.MapTypeId.MAP
        };

        map = new google.maps.Map(document.getElementById('map'),
            mapOptions);

        var regionData = [];
        for (var i = 0; i < region_data.length; i++) {
            regionData.push({
                location: new google.maps.LatLng(food_data[i].geo_region.center_lat,
                    food_data[i].geo_region.center_lon),
                weight: parseInt(region_data[i].risk_score)
            });
        }

        heatmap = new google.maps.visualization.HeatmapLayer({
            data: regionData,
            dissipating: false,
//        maxIntensity: 1000,
            radius: 0.006
        });

        heatmap.setMap(map);

        var bounds = new google.maps.LatLngBounds();
       // var nw_pt = new google.maps.LatLng(bound_data.nw_lat + bound_data.nw_lat * .10, bound_data + bound_data.nw_lon * .10);
        //var se_pt = new google.maps.LatLng(bound_data.se_lat + bound_data.se_lat * .10, bound_data.se_lon + bound_data.se_lon * .10);
        var nw_pt = new google.maps.LatLng(bound_data.nw_lat * 1.0001, bound_data.nw_lon * 1.0011);
        var se_pt = new google.maps.LatLng(bound_data.se_lat * .9999,  bound_data.se_lon * .999);
        bounds.extend(nw_pt);
        bounds.extend(se_pt);
       // center = bounds.getCenter();
        //map.setCenter(pt);
        map.fitBounds(bounds);
        map.setCenter(new google.maps.LatLng(center_point.lat, center_point.lon));
//        var listener = google.maps.event.addListener(map, "idle", function() {
//            map.setZoom(map.getZoom()-1);
//            google.maps.event.removeListener(listener);
//        });
//        console.log("Current zoom" + map.getZoom());
//       // map.setZoom(map.getZoom()-1);
//        console.log("Current zoom now" + map.getZoom());

        function toggleHeatmap() {
            heatmap.setMap(heatmap.getMap() ? null : map);
        }

        // Split healthy/unheathy located food sources and put on map
        var healthyFoodData = [];
        var unheathlyFoodData = [];
        for (var i = 0; i < food_data.length; i++) {
            var newMarker = new google.maps.Marker({
                position: new google.maps.LatLng(food_data[i].lat, food_data[i].lon),
                map: map,
                title: food_data[i].food_source.business_name
            });
            console.log(food_data[i])
            if (food_data[i].food_source.healthy) {
                newMarker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
                healthyFoodData.push(newMarker);
            } else {
                newMarker.setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png');
                unheathlyFoodData.push(newMarker);
            }
        }
    });

    $('body.analyses.new').ready(function () {
        console.log("loading new stuff");
        var handler, map;
        var drawn_rectangle;

        var mapOptions = {
            zoom: 7,
            center: new google.maps.LatLng(40, -104),
            mapTypeId: google.maps.MapTypeId.MAP
        };

        map = new google.maps.Map(document.getElementById('map'),
            mapOptions);

        var drawingManager = new google.maps.drawing.DrawingManager({
            drawingMode: google.maps.drawing.OverlayType.MARKER,
            drawingControl: true,
            drawingControlOptions: {
                position: google.maps.ControlPosition.TOP_CENTER,
                drawingModes: [
                    google.maps.drawing.OverlayType.RECTANGLE
                ]
            },
            markerOptions: {
                icon: 'images/beachflag.png'
            },
            circleOptions: {
                fillColor: '#ffff00',
                fillOpacity: 1,
                strokeWeight: 5,
                clickable: false,
                editable: true,
                zIndex: 1
            }
        });
        drawingManager.setDrawingMode(google.maps.drawing.OverlayType.RECTANGLE)
        drawingManager.setMap(map);

        google.maps.event.addListener(drawingManager, 'rectanglecomplete', function(rectangle) {
            if(drawn_rectangle !== undefined) {
                drawn_rectangle.setMap(null);
            }
            drawn_rectangle = rectangle;
            ne = rectangle.getBounds().getNorthEast();
            sw = rectangle.getBounds().getSouthWest();
            nw_lat = ne.lat();
            nw_lon = sw.lng();
            se_lat = sw.lat();
            se_lon = ne.lng();

            $('#analysis_geo_region_attributes_nw_lat').val(nw_lat);
            $('#analysis_geo_region_attributes_nw_lon').val(nw_lon);
            $('#analysis_geo_region_attributes_se_lat').val(se_lat);
            $('#analysis_geo_region_attributes_se_lon').val(se_lon);
        });
    });
})