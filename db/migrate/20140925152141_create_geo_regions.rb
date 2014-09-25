class CreateGeoRegions < ActiveRecord::Migration
  def change
    create_table :geo_regions do |t|
      t.decimal :nw_lat
      t.decimal :nw_lon
      t.decimal :se_lat
      t.decimal :se_lon

      t.timestamps
    end
  end
end
