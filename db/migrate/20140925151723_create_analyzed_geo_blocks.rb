class CreateAnalyzedGeoBlocks < ActiveRecord::Migration
  def change
    create_table :analyzed_geo_blocks do |t|
      t.integer :geo_region_id
      t.decimal :risk_score

      t.timestamps
    end
  end
end
