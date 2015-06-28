class CreateSourceHouseInfo < ActiveRecord::Migration
  def change
    create_table :source_house_infos do |t|
      t.integer :house_info_id
      t.boolean :is_marged, default: false
      t.string  :parser
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

      t.datetime :ecxuted_at
      t.datetime :marged_at
      t.string  :source_url
      t.boolean :error_during_parsing, default: false

      t.timestamps
    end

    add_index :source_house_infos, :feature_id
    add_index :source_house_infos, :ecxuted_at
    add_index :source_house_infos, :marged_at
  end
end
