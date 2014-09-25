class CombinePartsOfFoodSources < ActiveRecord::Migration
  def change
    remove_column :located_food_sources, :business_name
    remove_column :located_food_sources, :healthy
    add_column :located_food_sources, :food_source_id, :integer
  end
end
