# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :located_food_source do
    business_name ""
    healthy false
    lat "9.99"
    lon "9.99"
  end
end
