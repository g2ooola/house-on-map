class CreateGridId < ActiveRecord::Migration
  def change
    create_table :grid_ids do |t|
      t.integer :house_info_id
      t.integer :zoom
      # t.integer :grid_num, limit: 8
      t.integer :id_lat, limit: 4
      t.integer :id_lng, limit: 4
    end

    add_index :grid_ids, :house_info_id
    add_index :grid_ids, [:house_info_id, :zoom], unique: true
    # add_index :grid_ids, [:zoom, :grid_num]
    add_index :grid_ids, [:zoom, :id_lat, :id_lng]
  end
end
