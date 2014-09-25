class AddAnalyzedGeoBlockIdToGeoRegion < ActiveRecord::Migration
  def change
    add_column :geo_regions, :analyzed_geo_block_id, :integer
  end
end
