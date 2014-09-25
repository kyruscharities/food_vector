class AddPriceRankingToLocatedFoodSource < ActiveRecord::Migration
  def change
    add_column :located_food_sources, :price_rank, :integer
  end
end
