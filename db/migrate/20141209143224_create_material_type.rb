class CreateMaterialType < ActiveRecord::Migration
  def change
    create_table :material_types do |t|
      t.string :category

      t.timestamps
    end
  end
end
