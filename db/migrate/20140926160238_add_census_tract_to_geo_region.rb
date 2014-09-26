class AddCensusTractToGeoRegion < ActiveRecord::Migration
  def change
    add_column :geo_regions, :census_tract_id, :integer
  end
end
