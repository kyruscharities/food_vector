class CreateAnalysisGeoRegionScores < ActiveRecord::Migration
  def change
    create_table :analysis_geo_region_scores do |t|
      t.integer :analysis_id
      t.integer :geo_region_id
      t.decimal :risk_score

      t.timestamps
    end
  end
end
