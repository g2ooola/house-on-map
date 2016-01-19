# $ ->
#   google.maps.event.addDomListener(window, 'load', init)
#   test_init()



map = null
init = ->
  mapOption =
    zoom: 18
    center: new (google.maps.LatLng)(23.2, 120.3)

  map = new (google.maps.Map)($('#map')[0], mapOption)
  # test_init()

test_init = ->
  $('#test_button').on 'click', ->
    # alert("ya")
    # alert

    latlng = map.getCenter()
    zoom   = map.getZoom()
    url = "#{window.location.protocol}//#{window.location.host}/api/search/latlng.json"


    bounds = map.getBounds()
    console.log "bounds.getNorthEast() #{bounds.getNorthEast().lat()} #{bounds.getNorthEast().lng()}"
    console.log "bounds.getSouthWest() #{bounds.getSouthWest().lat()} #{bounds.getSouthWest().lng()}"
    console.log "zoom #{map.getZoom()}, lat = #{bounds.getNorthEast().lat() - bounds.getSouthWest().lat()}, lng = #{bounds.getNorthEast().lng() - bounds.getSouthWest().lng()}"
    console.log ""

    beachMarker = new google.maps.Marker
      position: bounds.getNorthEast()
      map: map

    beachMarker = new google.maps.Marker
      position: bounds.getSouthWest()
      map: map

    return true

    $.ajax
      type: 'get'
      url: url
      data:
        zoom: zoom
        lat:  latlng.lat()
        lng:  latlng.lng()
      dataType: 'json'
      success: (response)->
        console.log {success: response}
        # alert "success #{response}"

        left_down_position = new google.maps.LatLng(response.left_down.lat, response.left_down.lng);
        beachMarker = new google.maps.Marker
          position: left_down_position
          map: map

        right_top_position = new google.maps.LatLng(response.right_top.lat, response.right_top.lng);
        beachMarker = new google.maps.Marker
          position: right_top_position
          map: map

        beachMarker = new google.maps.Marker
          position: map.getCenter()
          map: map

      fail: (response) ->
        alert "fail #{response}"
      always: (response) ->
        # bundles = map.getBundles()
        # console.log {bundle: map.}
