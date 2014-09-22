class CreateGeographicDataPoints < ActiveRecord::Migration
  def change
    create_table :geographic_data_points do |t|
      t.integer :geo_region_id
      t.string :type
      t.string :data

      t.timestamps
    end
  end
end
