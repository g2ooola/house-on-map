# $ ->
#   google.maps.event.addDomListener(window, 'load', init)

map = null
init = ->
  mapOption = 
    zoom: 12
    center: new (google.maps.LatLng)(23.2, 120.3)

  map = new (google.maps.Map)($('#map')[0], mapOption)


