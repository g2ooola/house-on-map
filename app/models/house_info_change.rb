class HouseInfoChange < ActiveRecord::Base
  has_one :house_info

  def self.check_change(begin_date, num_of_days=1)
    result_info_hash = {}
    num_of_days.times do |d_num|
      date = begin_date + d_num.days
      result_info_hash[date] = {new: 0, change: 0}

      SourceHouseInfo.where(ecxuted_date: date).find_in_batches do |source_house_infos|
        source_house_infos.each do |source_house_info|
          last_changed = HouseInfoChange.where(parser: source_house_info.parser,feature_id: source_house_info.feature_id )
                                        .order('changed_date DESC')
                                        .first
          if last_changed.nil?
            record_change!(source_house_info)
            result_info_hash[date][:new] += 1
            next
          end

          unless last_changed.same_with(source_house_info)
            puts " ===================== same #{source_house_info.id} #{last_changed.price} #{source_house_info.price}"
            record_change!(source_house_info, last_changed.id)
            result_info_hash[date][:change] += 1
            next
          end

        end #source_house_infos.each
      end #SourceHouseInfo find_in_batch

    end #num_of_days

    result_info_hash
  end #self.check_change

  def self.record_change!(source_house_info, pre_change_id=nil)
    house_info_change = HouseInfoChange.new(
      house_info_id: source_house_info.house_info_id,
      parser: source_house_info.parser,
      feature_id: source_house_info.feature_id,

      price: source_house_info.price,
      year: source_house_info.year,
      floor: source_house_info.floor,
      floor_text: source_house_info.floor_text,
      buliding_format_id: source_house_info.buliding_format_id,
      material_id: source_house_info.material_id,
      plat_of_land: source_house_info.plat_of_land,
      float_area: source_house_info.float_area,

      num_of_badroom: source_house_info.num_of_badroom,
      num_of_livingroom: source_house_info.num_of_livingroom,
      num_of_restroom: source_house_info.num_of_restroom,

      address: source_house_info.address,
      coord_longitude: source_house_info.coord_longitude,
      coord_latitude: source_house_info.coord_latitude,

      changed_date: source_house_info.ecxuted_at.to_date,
      pre_change_id: pre_change_id,
      source_url: source_house_info.source_url,
      error_during_parsing: source_house_info.error_during_parsing,
    )

    house_info_change.save!
  end

  def same_with(source_house_info)
    puts " === self.price == source_house_info.price #{self.price == source_house_info.price}"
    self.price == source_house_info.price
  end

end
