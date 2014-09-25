class CreateFoodSources < ActiveRecord::Migration
  def change
    create_table :food_sources do |t|
      t.string :business_name

      t.timestamps
    end
  end
end
