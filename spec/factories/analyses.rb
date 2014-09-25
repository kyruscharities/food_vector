# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :analysis do
    name "MyString"
    description "MyText"
    user_id 1
    geo_region_id 1
    resolution "9.99"
    analysis_result_id 1
  end
end
