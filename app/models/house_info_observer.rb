class HouseInfoObserver < ActiveRecord::Observer
  # observe :house_infos1
  def after_create(record)
    puts " ========================= =================================="
    puts " ========================= house info observer after_create #{record.id}"
    puts "\n"
    
    # GridId.create_of_update_grid_for_house_info!(record)
    GridId.create_for_house_info!(record)
  end

  def after_update(record)
    # puts " ====== ya!!!"
    # if record.coord_longitude_changed? || record.coord_latitude_changed?
    #   GridId.create_of_update_grid_for_house_info!(record)
    # end

    puts "\n ========================= =================================="
    puts " =========================== house info observer after_update #{record.id}"
    puts "\n"
    if record.coords_present? && (record.coord_longitude_changed? || record.coord_latitude_changed?)
      GridId.update_for_house_info!(record)
    end
  end

  def after_destroy(record)
    puts " house info observer after_destroy #{record.id}"
    GridId.destroy_for_house_info!(record.id)
  end
end
