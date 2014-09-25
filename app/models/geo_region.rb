class GeoRegion < ActiveRecord::Base
  validates_presence_of :nw_lat
  validates_numericality_of :nw_lat, greater_than_or_equal_to: -85.0, less_than_or_equal_to: 85.0

  validates_presence_of :nw_lon
  validates_numericality_of :nw_lon, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0

  validates_presence_of :se_lat
  validates_numericality_of :se_lat, greater_than_or_equal_to: -85.0, less_than_or_equal_to: 85.0

  validates_presence_of :se_lon
  validates_numericality_of :se_lon, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0

  belongs_to :analysis
end
