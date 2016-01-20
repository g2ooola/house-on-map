$ ->
  google.maps.event.addDomListener(window, 'load', init)

  $('.datepicker').datepicker({
    format: 'yyyy/mm/dd'
    endDate: '1d'
    # startView1: 'days',
    # minViewMode: 'days'
  });

map = null
house_info_json = {}

selectPinColor = '75FE69'
selectPinImageUrl = "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + selectPinColor
selectPinImage = new google.maps.MarkerImage(
  selectPinImageUrl
  new google.maps.Size(21, 34)
  new google.maps.Point(0,0)
  new google.maps.Point(10, 34)
  )

generalPinColor = 'FE7569'
geenralPinImageUrl = "http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + generalPinColor
generalPinImage = new google.maps.MarkerImage(
  geenralPinImageUrl
  new google.maps.Size(21, 34)
  new google.maps.Point(0,0)
  new google.maps.Point(10, 34)
  )

selectedMarker = null


init = ->
  mapOption =
    zoom: 16
    center: new (google.maps.LatLng)(22.995044, 120.19378)

  map = new (google.maps.Map)($('#map')[0], mapOption)

  google.maps.event.addListener(map, 'dragend', ->
    start_show_house_info_flow()
  )
  google.maps.event.addListener(map, 'zoom_changed', ->
    start_show_house_info_flow()
  )
  # google.maps.event.addListener(map, 'bounds_changed', ->
  #   start_show_house_info_flow()
  # )

  start_show_house_info_flow()

start_show_house_info_flow = ->
  center_latlng =  map.getCenter()
  zoom = map.getZoom()
  get_house_info(zoom, center_latlng)

get_house_info = (zoom, latlng)->
  url = "#{window.location.protocol}//#{window.location.host}/api/search/latlng.json"

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
      if response.data && $.isArray(response.data.house_infos)
        init_house_info(response.data.house_infos)


    fail: (response) ->
      alert "fail #{response}"
    always: (response) ->
      # bundles = map.getBundles()
      # console.log {bundle: map.}

init_house_info = (house_infos)->
  $.each(house_infos, (index, house_info) ->
    key = house_info.id
    if house_info_json[key]
      # marker = house_info_json[key].marker
      # reset_house_info_marker(marker, house_info)
      # # reset other infos
    else
      marker = create_house_info_marker(house_info)
      house_info.marker = marker

    house_info_json[key] = house_info
    )

create_house_info_marker = (house_info) ->
  # console.log house_info.coord_latitude
  # console.log ({map: map})
  marker_position = new (google.maps.LatLng)(house_info.coord_latitude, house_info.coord_longitude)
  # console.log(map.getBounds().contains(marker_position))
  # console.log ({marker_position: marker_position})
  marker = new google.maps.Marker(
    position: marker_position
    map: map
    title: house_info.address
    icon: generalPinImage
    )
  marker.id = house_info.id
  google.maps.event.addListener( marker, 'mouseover', ->
    # alert("ya'")
    selected_house_info = house_info_json[marker.id]
    show_info(selected_house_info)

    # shape =
    #   coords: [10, 10, 25, 30]
    #   type: 'rect'
    #
    # color =
    #   fillColor: 'blue'

    if selectedMarker
      selectedMarker.setIcon(generalPinImage)
      # selectedMarker.getIcon.setColor

    marker.setIcon(selectPinImage)
    selectedMarker = marker
    )

reset_house_info_marker = (marker, house_info) ->
  marker.setPosition(
    new (google.maps.LatLng)(house_info.coord_latitude, house_info.longitude)
  )
  null

show_info = (house_info) ->
  info = ''
  $.each(house_info, (key, value) ->
    info += "#{key} : #{value}<br>"
    )
  $('#info-div').html(info)
