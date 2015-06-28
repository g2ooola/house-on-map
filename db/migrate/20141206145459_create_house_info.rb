class CreateHouseInfo < ActiveRecord::Migration
  def change
    create_table :house_infos do |t|  
      t.string  :feature_id
      t.integer :price
      t.integer :year
      t.integer :floor
      t.string  :floor_text
      t.integer :buliding_format_id
      t.integer :material_id
      t.float   :plat_of_land
      t.float   :float_area

      # t.string  :pattern
      t.integer :num_of_badroom
      t.integer :num_of_livingroom
      t.integer :num_of_restroom

      t.string  :address
      t.float   :coord_longitude
      t.float   :coord_latitude

      t.datetime :resource_at
      t.integer  :using_source_id
      t.string  :source_url

      t.timestamps
    end

    add_index :house_infos, :feature_id
  end
end
