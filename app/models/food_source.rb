class FoodSource < ActiveRecord::Base
  validates_presence_of :business_name
  validates_inclusion_of :healthy, in: [true, false]

  has_many :locations, class_name: 'LocatedFoodSource'
end
