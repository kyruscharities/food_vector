class GeographicDataPoint < ActiveRecord::Base
  has_one :geo_region
  validates_presence_of :geo_region

  validates_presence_of :type
  validates_inclusion_of :type, in: [:census_data, :health_data]

  validates_presence_of :data
end
