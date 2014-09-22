# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :geo_region do
    nw_lat "9.99"
    nw_lon "9.99"
    se_lat "9.99"
    se_lon "9.99"
  end
end
