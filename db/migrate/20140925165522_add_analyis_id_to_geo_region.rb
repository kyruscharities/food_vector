class AddAnalyisIdToGeoRegion < ActiveRecord::Migration
  def change
    add_column :geo_regions, :analysis_id, :integer
    remove_column :analyses, :geo_region_id
  end
end
