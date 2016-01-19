class AddColumnEcxutedAtToSoourceHouseInfo < ActiveRecord::Migration
  def change
    add_column :source_house_infos, :ecxuted_date, :date
    add_index :source_house_infos, :ecxuted_date
    add_index :source_house_infos, [:parser, :feature_id, :ecxuted_date], unique: true, name: :index_parser_featureid_ecxuteddate_on_source
  end
end
