/**
 * Created by scottaubert2 on 9/25/14.
 */

$(document).ready(function () {
    $('body.analyses.show').ready(function () {
        console.log("loading show stuff");
        var handler, map;

        var mapOptions = {
            zoom: 9,
            center: new google.maps.LatLng(center_point.lat, center_point.lon),
            mapTypeId: google.maps.MapTypeId.MAP
        };

        map = new google.maps.Map(document.getElementById('map'),
            mapOptions);

        var regionData = [];
        for (var i = 0; i < region_data.length; i++) {
            regionData.push({
                location: new google.maps.LatLng(region_data[i].geo_region.center_lat,
                    region_data[i].geo_region.center_lon),
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

            attachTitle(newMarker, food_data[i])

            console.log(food_data[i])
            if (food_data[i].food_source.healthy) {
                newMarker.setIcon('http://maps.google.com/mapfiles/ms/icons/green-dot.png');
                healthyFoodData.push(newMarker);
            } else {
                newMarker.setIcon('http://maps.google.com/mapfiles/ms/icons/red-dot.png');
                unheathlyFoodData.push(newMarker);
            }
        }

        function attachTitle(marker, located_food_source) {
            var infowindow = new google.maps.InfoWindow({
                content: located_food_source.food_source.business_name
            });

            google.maps.event.addListener(marker, 'click', function() {
                infowindow.open(marker.get('map'), marker);
            });
        }
    });

    $('body.analyses.new').ready(function () {
        console.log("loading new stuff");
        var handler, map;
        var drawn_rectangle;

        var mapOptions = {
            zoom: 3,
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
