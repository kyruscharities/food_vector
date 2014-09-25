class CreateLocatedFoodSources < ActiveRecord::Migration
  def change
    create_table :located_food_sources do |t|
      t.string :business_name
      t.boolean :healthy
      t.decimal :lat
      t.decimal :lon

      t.timestamps
    end
  end
end
