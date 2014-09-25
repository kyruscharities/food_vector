class AddHealthyToFoodSource < ActiveRecord::Migration
  def change
    add_column :food_sources, :healthy, :boolean
  end
end
