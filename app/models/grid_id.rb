class GridId < ActiveRecord::Base
  belongs_to :house_info
  # def self.calcul_grid_for_house_info(house_info)
  #   index_hash = PositionSearch.new.index_calcul(house_info.coord_latitude, house_info.coord_longitude)
  #
  #   index_hash.each do |zoom, grid_num|
  #     position_grid_number = GridId.find_or_create_by(house_info_id: house_info.id, zoom: zoom)
  #     position_grid_number.grid_num = grid_num
  #     position_grid_number.save!
  #   end
  # end
  #
  # def self.create_of_update_grid_for_house_info!(house_info)
  #   index_hash = PositionSearch.new.index_calcul(house_info.coord_latitude, house_info.coord_longitude)
  #
  #   begin
  #     # create
  #
  #     new_grid_number_hash = index_hash.map do |zoom, grid_num|
  #        GridId.new(house_info_id: house_info.id, zoom: zoom, grid_num: grid_num)
  #     end
  #     GridId.import new_grid_number_hash
  #
  #   rescue ActiveRecord::RecordNotUnique => e
  #     # ActiveRecord::Base.connection.execute 'ROLLBACK'
  #           ActiveRecord::Base.connection.execute ''
  #     # ActiveRecord::Base.connection_pool.disconnect!
  #     # https://github.com/influitive/apartment/issues/172
  #     # house_info.reload
  #
  #     # update
  #     house_info_id = house_info.id
  #     ref_string = ''
  #     index_hash.each { |zoom, grid_num| ref_string += "(#{zoom}, #{grid_num})," }
  #     # index_hash.each { |zoom, grid_num| ref_string += "(#{zoom}, 1)," }
  #     ref_string = ref_string[0...-1] unless index_hash.empty?
  #
  #     sql_string = "
  #       UPDATE grid_ids as g
  #       SET grid_num = a.grid_num
  #       FROM (values #{ref_string}) as a(zoom, grid_num)
  #       WHERE g.house_info_id = #{house_info_id} AND g.zoom = a.zoom"# .delete!("\n")
  #     ActiveRecord::Base.connection.execute( sql_string )
  #   end
  # end

  def self.create_for_house_info!(house_info)
    puts ""
    index_hash = PositionSearch.new.index_calcul(house_info.coord_latitude, house_info.coord_longitude)
    new_grid_number_hash = index_hash.map do |zoom, grid_num|
      #  GridId.new(house_info_id: house_info.id, zoom: zoom, grid_num: grid_num)
      GridId.new(house_info_id: house_info.id, zoom: zoom, id_lat: grid_num[:id_lat], id_lng: grid_num[:id_lng])
    end
    GridId.import new_grid_number_hash
  end

  def self.update_for_house_info!(house_info)
    index_hash = PositionSearch.new.index_calcul(house_info.coord_latitude, house_info.coord_longitude)

    house_info_id = house_info.id
    ref_string = ''
    # index_hash.each { |zoom, grid_num| ref_string += "(#{zoom}, #{grid_num})," }
    index_hash.each { |zoom, grid_num| ref_string += "(#{zoom}, #{grid_num[:id_lat]}, #{grid_num[:id_lng]})," }
    ref_string = ref_string[0...-1] unless index_hash.empty?

    # sql_string = "
    #   UPDATE grid_ids as g
    #   SET grid_num = a.grid_num
    #   FROM (values #{ref_string}) as a(zoom, grid_num)
    #   WHERE g.house_info_id = #{house_info_id} AND g.zoom = a.zoom"# .delete!("\n")
    sql_string = "
      UPDATE grid_ids as g
      SET id_lat = a.id_lat, id_lng = a.id_lng
      FROM (values #{ref_string}) as a(zoom, id_lat, id_lng)
      WHERE g.house_info_id = #{house_info_id} AND g.zoom = a.zoom"# .delete!("\n")
    ActiveRecord::Base.connection.execute( sql_string )
  end

  def self.destroy_for_house_info!(house_info_id)
    GridId.where(house_info_id: house_info_id).delete_all
  end
end
