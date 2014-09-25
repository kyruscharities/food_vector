class AddCenterPointToGeoRegion < ActiveRecord::Migration
  def change
    add_column :geo_regions, :center_lat, :decimal
    add_column :geo_regions, :center_lon, :decimal
  end
end
