# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :analysis_geo_region_score do
    analysis_id 1
    geo_region_id 1
    risk_score "9.99"
  end
end
