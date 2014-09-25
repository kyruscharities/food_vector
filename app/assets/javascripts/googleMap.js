/**
 * Created by scottaubert2 on 9/25/14.
 */

$(document).ready(function() {

    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}, offsetWidth: 200}, function () {
        markers = handler.addMarkers([
            {
                "lat": 0,
                "lng": 0,
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

    //markers = handler.addMarkers(<%=raw @hash.to_json %>);
})

