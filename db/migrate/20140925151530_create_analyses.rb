class CreateAnalyses < ActiveRecord::Migration
  def change
    create_table :analyses do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.integer :geo_region_id
      t.decimal :resolution_mi
      t.integer :analysis_result_id

      t.timestamps
    end
  end
end
