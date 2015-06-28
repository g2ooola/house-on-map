class GridTool

  def get_grid_of_coord(zoom, lat, lng)
  end

  def get_grid_of_coord_array(zoom, lat, lng)
  end

  def search_viewable_grid_of_coord(zoom, lat, lng)
  end

# private
  GRID_NUM_OF_VIEWPORT = 2
  def get_grid_size(zoom)
    divide_num = 2 ** zoom
    lat_unit =  90.0 / divide_num
    lng_unit = 180.0 / divide_num

    { lat_unit: lat_unit, lng_unit: lng_unit}
  end

  def test(zoom, lat, lng)
    grid_size = get_grid_size(zoom)

    puts " ============ lat #{lat}, lng #{lng}"
    left_down = { lat: (lat - grid_size[:lat_unit] / 2), lng: (lng - grid_size[:lng_unit] / 2) }
    right_top = { lat: (lat + grid_size[:lat_unit] / 2), lng: (lng + grid_size[:lng_unit] / 2) }

    { left_down: left_down, right_top: right_top }
  end
end