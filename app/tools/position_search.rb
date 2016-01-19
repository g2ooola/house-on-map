class PositionSearch
  SPLIT_NUM = 3
  # FLOAT_TO_INT_FIX = 1000 * 1000 * 1000 * 1000
  FLOAT_TO_INT_FIX = 100000
  LAT_HALF = 90
  LNG_HALF = 180

  ZOOM_LEVEL_MAX = 18
  ZOOM_LEVEL_MIN = 0

  INT_LAT_MAX = LAT_HALF * 2 * FLOAT_TO_INT_FIX
  INT_LNG_MAX = LNG_HALF * 2 * FLOAT_TO_INT_FIX

  # calcul grid num of all zoom ( 0 ~ 18 )
  def index_calcul(lat, lng)
    # int_lat = ((lat + LAT_HALF) * FLOAT_TO_INT_FIX).to_i
    # int_lng = ((lng + LNG_HALF) * FLOAT_TO_INT_FIX).to_i
    int_lat = int_schema(lat + LAT_HALF)
    int_lng = int_schema(lng + LNG_HALF)

    index_hash = {}
    # MapZoom.delta.each do |data|
    MapZoom.range.each do |zoom|
      # zoom = data[:zoom]
      # lat_delta = (data[:lat] * FLOAT_TO_INT_FIX).to_i
      # lng_delta = (data[:lng] * FLOAT_TO_INT_FIX).to_i
      int_lat_delta, int_lng_delta = zoom_delta_int_calcul(zoom)

      # index_num = int_index_translate(lat_max, lng_max, lat_delta, lng_delta, int_lat, int_lng)
      id_lat, id_lng = int_index_translate(INT_LAT_MAX, INT_LNG_MAX, int_lat_delta, int_lng_delta, int_lat, int_lng)

      index_hash[zoom] = { id_lat: id_lat, id_lng: id_lng }
    end
    index_hash
  end

  def index_calcul_by_zoom(lat, lng, zoom)
    return nil if out_of_zoom_range(zoom)

    int_lat = int_schema(lat + LAT_HALF)
    int_lng = int_schema(lng + LNG_HALF)
    # lat_max = LAT_HALF * 2 * FLOAT_TO_INT_FIX
    # lng_max = LNG_HALF * 2 * FLOAT_TO_INT_FIX



    # lat_delta = (MapZoom.delta[zoom][:lat] * FLOAT_TO_INT_FIX).to_i
    # lng_delta = (MapZoom.delta[zoom][:lng] * FLOAT_TO_INT_FIX).to_i

    int_lat_delta, int_lng_delta = zoom_delta_int_calcul(zoom)

    # index_num = int_index_translate(lat_max, lng_max, lat_delta, lng_delta, int_lat, int_lng)
    int_index_translate(INT_LAT_MAX, INT_LNG_MAX, int_lat_delta, int_lng_delta, int_lat, int_lng)
    # return value is [id_lat, id_lng]
  end

  def index_around(zoom, id_lat, id_lng)
    id_lat_max, id_lng_max = zoom_id_max(zoom)

    id_lat = (id_lat + id_lat_max) % id_lat_max
    id_lng = (id_lng + id_lng_max) % id_lng_max

    id_lat_plus1  = (id_lat + id_lat_max + 1) % id_lat_max
    id_lat_minus1 = (id_lat + id_lat_max - 1) % id_lat_max
    id_lng_plus1  = (id_lng + id_lng_max + 1) % id_lng_max
    id_lng_minus1 = (id_lng + id_lng_max - 1) % id_lng_max

    [
      [id_lat_minus1, id_lng_minus1], [id_lat_minus1,  id_lng], [id_lat_minus1, id_lng_plus1],
      [id_lat,        id_lng_minus1], [id_lat,         id_lng], [id_lat,        id_lng_plus1],
      [id_lat_plus1,  id_lng_minus1], [id_lat_plus1,   id_lng], [id_lat_plus1,  id_lng_plus1]
    ]
  end

  def house_around_index(zoom, id_lat, id_lng)
    id_in_area = index_around(zoom, id_lat, id_lng)

    condition = '('
    if id_in_area.present?
      id_in_area.each { |id_infos| condition += "(#{zoom}, #{id_infos[0]}, #{id_infos[1]})," }
      condition = condition[0...-1]
    end
    condition += ')'

    HouseInfo.joins(:grid_ids) #.reference(:grid_ids)
    .where("(grid_ids.zoom, grid_ids.id_lat, grid_ids.id_lng) in #{condition}")
  end

private

  def out_of_zoom_range(zoom)
    return true if zoom > ZOOM_LEVEL_MAX || zoom < ZOOM_LEVEL_MIN
  end

  # calcul grid number of [lat and lng]
  def int_index_translate(lat_max, lng_max, lat_delta, lng_delta, lat, lng)
    puts " === "
    puts "  == lat_max #{lat_max}, lng_max, #{lng_max}, lat_delta #{lat_delta}, lng_delta, #{lng_delta}, lat #{lat}, lng #{lng}"
    lat_num = int_grid_num_calcul(lat_delta, lat)
    lat_num_max = int_grid_num_calcul(lat_delta, lat_max)
    lng_num = int_grid_num_calcul(lng_delta, lng)
    # lng_num_max = int_grid_num_calcul(lng_delta, lng_max)

    # puts " === #{lat_delta}, #{lng_delta}, #{lat}, #{lng}, ||| #{lat_num}, #{lat_num_max}, #{lng_num}, ||| #{lng_num * lat_num_max + lat_num}"


    # index_num = lng_num * lat_num_max + lat_num
    # { id_lat: lat_num, id_lng: lng_num }
    [lat_num, lng_num]
  end

  def zoom_delta_int_calcul(zoom)
    delta = MapZoom.delta[zoom]
    int_lat_delta = int_schema(delta[:lat])
    int_lng_delta = int_schema(delta[:lng])
    [int_lat_delta, int_lng_delta]
  end

  def zoom_id_max(zoom)
    # delta = MapZoom.delta[zoom]
    # puts " === #{INT_LAT_MAX} / #{delta[:lat]} #{FLOAT_TO_INT_FIX} to_i"
    # # id_lat_max = (LAT_HALF * 2 / delta[:lat] ).to_i
    # # id_lng_max = (LNG_HALF * 2 / delta[:lng] ).to_i
    int_lat_delta, int_lng_delta = zoom_delta_int_calcul(zoom)
    id_lat_max = INT_LAT_MAX / int_lat_delta
    id_lng_max = INT_LNG_MAX / int_lng_delta
    [id_lat_max, id_lng_max]
  end

  # step of int_index_translate, calcul in one dimension
  def int_grid_num_calcul(delta, object_digital)
    # puts " === #{delta}, #{object_digital}, #{(object_digital + delta - 1) / delta}"
    # (object_digital + delta - 1) / delta
    object_digital / delta
  end

  def int_schema(lat_or_lng)
    (lat_or_lng * FLOAT_TO_INT_FIX).to_i
  end
end
