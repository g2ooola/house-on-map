class HouseInfo < ActiveRecord::Base
  has_many :grid_ids

  # after_save :update_grid_num # :if => Proc.new { |house_info| house_info.previous_changes }
  def self.update_using_source(source_house_info)
    house_info = self.find_or_initialize_by(feature_id: source_house_info.feature_id)
    house_info.update_using_source(source_house_info)



  end

  def update_using_source(source_house_info)
    self.price               = source_house_info.price
    self.year                = source_house_info.year
    self.floor               = source_house_info.floor
    self.floor_text          = source_house_info.floor_text
    self.buliding_format_id  = source_house_info.buliding_format_id
    self.material_id         = source_house_info.material_id
    self.plat_of_land        = source_house_info.plat_of_land
    self.float_area          = source_house_info.float_area

    # pattern            = source_house_info.pattern
    self.num_of_badroom      = source_house_info.num_of_badroom
    self.num_of_livingroom   = source_house_info.num_of_livingroom
    self.num_of_restroom     = source_house_info.num_of_restroom

    self.address             = source_house_info.address
    self.coord_longitude     = source_house_info.coord_longitude
    self.coord_latitude      = source_house_info.coord_latitude

    self.resource_at         = Time.now
    self.using_source_id     = source_house_info.id
    self.source_url          = source_house_info.source_url

    source_house_info.marged_at = resource_at
    source_house_info.is_marged = true
    source_house_info.save
    self.save
  end

  def coords_present?
    self.coord_longitude.present? && self.coord_latitude.present?
  end
  # def update_grid_num
  #   puts " == previous_changes #{coord_longitude_changed?}"
  #   puts " == previous_changes #{coord_latitude_changed?}"
  #   if coord_longitude_changed? || coord_latitude_changed?
  #     ::GridId.create_of_update_grid_for_house_info!(self)
  #   end
  # end

  # def self.in_grid(grid_index, zoom_level)
  #   self.joins(:grid_ids) #.reference(:grid_ids)
  #   .where(grid_ids: {grid_num: grid_index, zoom: zoom_level})
  # end

  # def self.in_grid(zoom_level, in_lat_id_lng_array)
  #   condition = '('
  #   in_lat_id_lng_array.each { |id_infos| condition += "(#{zoom_level}, #{id_infos[0]}, #{id_infos[1]})" }
  #   condition += ')'
  #
  #   self.joins(:grid_ids) #.reference(:grid_ids)
  #   .where("(grid_ids.zoom, grid_ids.id_lat, grid_ids.id_lng) in #{condition}")
  # end

  def self.grid_search(center_grid_index, zoom_level)
  end
end
