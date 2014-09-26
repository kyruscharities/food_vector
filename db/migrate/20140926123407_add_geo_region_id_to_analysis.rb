class AddGeoRegionIdToAnalysis < ActiveRecord::Migration
  def change
    add_column :analyses, :geo_region_id, :integer
  end
end
