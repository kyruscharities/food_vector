# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :geographic_data_point do
    geo_region_id 1
    type "MyString"
    data "MyString"
  end
end
