$(document).ready ->

  $("body.analyses.index").ready ->
    src = "http://maps.google.com/maps/api/staticmap?size=512x400&visible="
    i = 0

    while i < analyses_data.length
      analysis = analyses_data[i]
      bounds = new google.maps.LatLngBounds(new google.maps.LatLng(analysis.geo_region.se_lat, analysis.geo_region.nw_lon), new google.maps.LatLng(analysis.geo_region.nw_lat, analysis.geo_region.se_lon))
      img = $("<img class=\"static-map\">")
      img.attr "src", src + bounds.getSouthWest().toUrlValue() + "|" + bounds.getNorthEast().toUrlValue()
      $("#map-image-" + analysis.id).html img
      i++

  $("body.analyses.new, body.analyses.edit, body.analyses.create").ready ->
    mapOptions =
      zoom: 8
      center: new google.maps.LatLng(40, -104.8)
      mapTypeId: google.maps.MapTypeId.MAP

    drawingManager = new google.maps.drawing.DrawingManager(
      drawingControl: true
      drawingControlOptions:
        position: google.maps.ControlPosition.TOP_CENTER
        drawingModes: [
          google.maps.drawing.OverlayType.RECTANGLE
        ]

      markerOptions:
        icon: "images/beachflag.png"

      circleOptions:
        fillColor: "#ffff00"
        fillOpacity: 1
        strokeWeight: 5
        clickable: false
        editable: true
        zIndex: 1
    )

    drawingManager.setMap new google.maps.Map(document.getElementById("map"), mapOptions)

    last_rectangle = null
    google.maps.event.addListener drawingManager, "rectanglecomplete", (rectangle) ->
      last_rectangle.setMap null if last_rectangle
      last_rectangle = rectangle
      ne = rectangle.getBounds().getNorthEast()
      sw = rectangle.getBounds().getSouthWest()
      $("#analysis_geo_region_attributes_nw_lat").val ne.lat()
      $("#analysis_geo_region_attributes_nw_lon").val sw.lng()
      $("#analysis_geo_region_attributes_se_lat").val sw.lat()
      $("#analysis_geo_region_attributes_se_lon").val ne.lng()


  $("body.analyses.show").ready ->

    #        maxIntensity: 1000,

    #            radius: 300

    # get get lat lon and scale out a bit to auto zoom to our data

    # Split healthy/unheathy located food sources and put on map
    getResults = (page_number, heatmap, regionData) ->
      $.getJSON "/analyses/" + analysis_id + "/analysis_geo_region_scores.json?page=" + page_number, (region_data) ->
        i = 0

        while i < region_data.length
          regionData.push
            location: new google.maps.LatLng(region_data[i].geo_region.center_lat, region_data[i].geo_region.center_lon)
            weight: parseInt(region_data[i].risk_score)

          i++
        heatmap.setData regionData
        getResults page_number + 1, heatmap, regionData  if region_data.length is 1000
        return

      return

    attachTitle = (marker, located_food_source) ->
      infowindow = new google.maps.InfoWindow(content: located_food_source.food_source.business_name)
      google.maps.event.addListener marker, "click", ->
        infowindow.open marker.get("map"), marker
        return

      return

    toggle_markers = (foodData) ->
      i = 0

      while i < foodData.length
        thisMap = foodData[i].get("map")
        thisMap = (if thisMap then null else map)
        foodData[i].setMap thisMap
        i++
      return

    analysis_id = $("#map").attr("data-analysis-id")
    regionData = []
    heatmap = new google.maps.visualization.HeatmapLayer(
      data: regionData
      dissipating: false
      radius: 0.003
    )
    handler = undefined
    map = undefined
    mapOptions =
      center: new google.maps.LatLng(geo_region.center_lat, geo_region.center_lon)
      mapTypeId: google.maps.MapTypeId.MAP
      mapTypeControlOptions:
        style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR
        position: google.maps.ControlPosition.TOP_LEFT

    map = new google.maps.Map(document.getElementById("map"), mapOptions)
    heatmap.setMap map
    bounds = new google.maps.LatLngBounds()
    nw_pt = new google.maps.LatLng(geo_region.nw_lat * 1.0001, geo_region.nw_lon * 1.0011)
    se_pt = new google.maps.LatLng(geo_region.se_lat * .9999, geo_region.se_lon * .999)
    bounds.extend nw_pt
    bounds.extend se_pt
    map.fitBounds bounds
    healthyFoodData = []
    unhealthyFoodData = []
    i = 0

    while i < food_data.length
      newMarker = new google.maps.Marker(
        position: new google.maps.LatLng(food_data[i].lat, food_data[i].lon)
        map: map
        title: food_data[i].food_source.business_name
      )
      attachTitle newMarker, food_data[i]
      console.log food_data[i]
      if food_data[i].food_source.healthy
        newMarker.setIcon "http://maps.google.com/mapfiles/ms/icons/green-dot.png"
        healthyFoodData.push newMarker
      else
        newMarker.setIcon "http://maps.google.com/mapfiles/ms/icons/red-dot.png"
        unhealthyFoodData.push newMarker
      i++
    getResults 1, heatmap, regionData
    $("#toggle-heatmap").click ->
      heatmap.setMap (if heatmap.getMap() then null else map)
      return

    $("#toggle-healthy").click ->
      toggle_markers healthyFoodData
      return

    $("#toggle-unhealthy").click ->
      toggle_markers unhealthyFoodData
      return

    return
