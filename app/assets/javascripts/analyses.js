/**
 * Created by scottaubert2 on 9/25/14.
 */

$(document).ready(function () {
    $('body.analyses.show').ready(function () {

        var analysis_id = $('#map').attr('data-analysis-id');
        var regionData = [];
        var heatmap = new google.maps.visualization.HeatmapLayer({
            data: regionData,
            dissipating: false,
//        maxIntensity: 1000,
            radius: 0.003
//            radius: 300
        });

        var handler, map;

        var mapOptions = {
            center: new google.maps.LatLng(geo_region.center_lat, geo_region.center_lon),
            mapTypeId: google.maps.MapTypeId.MAP,
            mapTypeControlOptions: {
                style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
                position: google.maps.ControlPosition.TOP_LEFT
            }
        };

        map = new google.maps.Map(document.getElementById('map'),
            mapOptions);

        heatmap.setMap(map);

        // get get lat lon and scale out a bit to auto zoom to our data
        var bounds = new google.maps.LatLngBounds();
        var nw_pt = new google.maps.LatLng(geo_region.nw_lat * 1.0001, geo_region.nw_lon * 1.0011);
        var se_pt = new google.maps.LatLng(geo_region.se_lat * .9999,  geo_region.se_lon * .999);
        bounds.extend(nw_pt);
        bounds.extend(se_pt);
        map.fitBounds(bounds);

        // Split healthy/unheathy located food sources and put on map
        var healthyFoodData = [];
        var unhealthyFoodData = [];
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
                unhealthyFoodData.push(newMarker);
            }
        }

        function getResults(page_number, heatmap, regionData) {
            $.getJSON('/analyses/' + analysis_id + '/analysis_geo_region_scores.json?page=' + page_number, function(region_data) {
                for (var i = 0; i < region_data.length; i++) {
                    regionData.push({
                        location: new google.maps.LatLng(region_data[i].geo_region.center_lat,
                            region_data[i].geo_region.center_lon),
                        weight: parseInt(region_data[i].risk_score)
                    });

                    heatmap.setData(regionData)
                }

                if(region_data.length === 100) {
                    getResults(page_number + 1, heatmap, regionData);
                }
            });
        }

        getResults(1, heatmap, regionData);

        function attachTitle(marker, located_food_source) {
            var infowindow = new google.maps.InfoWindow({
                content: located_food_source.food_source.business_name
            });

            google.maps.event.addListener(marker, 'click', function() {
                infowindow.open(marker.get('map'), marker);
            });
        }

        $('#toggle-heatmap').click(function () {
            heatmap.setMap(heatmap.getMap() ? null : map);
        });

        $('#toggle-healthy').click(function() {
            toggle_markers(healthyFoodData)
        });

        $('#toggle-unhealthy').click(function() {
            toggle_markers(unhealthyFoodData)
        });

        function toggle_markers(foodData) {
            for (var i = 0; i < foodData.length; i++) {
                var thisMap = foodData[i].get('map');
                thisMap = thisMap ? null : map
                foodData[i].setMap(thisMap);
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

    $('body.analyses.index').ready(function () {
        console.log("loading index stuff");

        var src = 'http://maps.google.com/maps/api/staticmap?size=512x400&visible=';

        for (var i = 0; i < analyses_data.length; i++) {
            var analysis = analyses_data[i]

            var bounds = new google.maps.LatLngBounds(
                new google.maps.LatLng(analysis.geo_region.se_lat, analysis.geo_region.nw_lon),
                new google.maps.LatLng(analysis.geo_region.nw_lat, analysis.geo_region.se_lon)
            )

            var img = $('<img class="static-map">');
            img.attr('src', src + bounds.getSouthWest().toUrlValue() + '|' + bounds.getNorthEast().toUrlValue());
            $('#map-image-' + analysis.id).html(img)
        }
    });
})
