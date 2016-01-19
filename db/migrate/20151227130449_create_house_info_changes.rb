class CreateHouseInfoChanges < ActiveRecord::Migration
  def change
    create_table :house_info_changes do |t|
      t.integer :house_info_id
      # t.boolean :is_marged, default: false
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

      t.date :changed_date
      # t.datetime :ecxuted_at
      t.integer :pre_change_id
      t.string  :source_url
      t.boolean :error_during_parsing, default: false

      t.timestamps
    end

    add_index :house_info_changes, :feature_id
    add_index :house_info_changes, :house_info_id
    add_index :house_info_changes, :pre_change_id
    add_index :house_info_changes, :changed_date
    add_index :house_info_changes, [:parser, :feature_id]
    add_index :house_info_changes, [:parser, :feature_id, :changed_date], unique: true, name: :index_parser_featureid_changedat_on_changes
  end
end
