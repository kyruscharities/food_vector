class AddIncomeDataToGeoRegion < ActiveRecord::Migration
  def change
    add_column :geo_regions, :income_data, :text
  end
end
