class GeographicDataPoint < ActiveRecord::Base
  TYPES = [:census_data, :health_data]

  has_one :geo_region
  validates_presence_of :geo_region

  validates_presence_of :type
  validates_inclusion_of :type, in: TYPES

  validates_presence_of :data
end
