class AddRiskScoreToGeoRegion < ActiveRecord::Migration
  def change
    add_column :geo_regions, :risk_score, :float
  end
end
