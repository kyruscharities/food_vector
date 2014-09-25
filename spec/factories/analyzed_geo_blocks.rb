# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :analyzed_geo_block do
    geo_region_id 1
    risk_score "9.99"
  end
end
