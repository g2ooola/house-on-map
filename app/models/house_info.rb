class HouseInfo < ActiveRecord::Base
  def self.update_using_source(source_house_info)
    house_info = self.find_or_create_by!(feature_id: source_house_info.feature_id)
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
end