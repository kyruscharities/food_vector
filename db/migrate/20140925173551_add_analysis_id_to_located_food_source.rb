class AddAnalysisIdToLocatedFoodSource < ActiveRecord::Migration
  def change
    add_column :located_food_sources, :analysis_id, :integer
  end
end
