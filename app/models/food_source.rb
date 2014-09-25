class FoodSource < ActiveRecord::Base
  validates_presence_of :business_name
end
