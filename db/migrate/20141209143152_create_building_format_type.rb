class CreateBuildingFormatType < ActiveRecord::Migration
  def change
    create_table :building_format_types do |t|
      t.string :category

      t.timestamps
    end
  end
end
