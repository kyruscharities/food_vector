Analysis
- belongs_to User
- has_many healthy_food_sources, class: FoodSource
- has_many unhealthy_food_sources, class: FoodSource
- geo_region
- resolution
- has_many analyzed_geo_blocks
- has_many located_healthy_food_sources
- has_many located_unhealthy_food_sources

AnalyzedGeoBlock
geo_region
risk_score
has_many geographic_data_point (contributing factors)

FoodSource
business_name

LocatedFoodSource
business_name
healthy?
lat
lon

GeographicDataPoint
geo_region
type (census data, health data)
data
