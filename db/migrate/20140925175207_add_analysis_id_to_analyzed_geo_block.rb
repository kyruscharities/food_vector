class AddAnalysisIdToAnalyzedGeoBlock < ActiveRecord::Migration
  def change
    add_column :analyzed_geo_blocks, :analysis_id, :integer
  end
end
