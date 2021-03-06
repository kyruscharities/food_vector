class GeoRegion < ActiveRecord::Base
  before_validation :calculate_center_point

  validates_presence_of :nw_lat
  validates_numericality_of :nw_lat, greater_than_or_equal_to: -85.0, less_than_or_equal_to: 85.0

  validates_presence_of :nw_lon
  validates_numericality_of :nw_lon, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0

  validates_presence_of :se_lat
  validates_numericality_of :se_lat, greater_than_or_equal_to: -85.0, less_than_or_equal_to: 85.0

  validates_presence_of :se_lon
  validates_numericality_of :se_lon, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0

  validates_presence_of :center_lat
  validates_numericality_of :center_lat, greater_than_or_equal_to: -85.0, less_than_or_equal_to: 85.0

  validates_presence_of :center_lon
  validates_numericality_of :center_lon, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0

  belongs_to :analysis
  #validates_presence_of :analysis

  serialize :income_data, JSON

  def calculate_center_point
    self.center_lat = nw_lat / 2 + se_lat / 2 if nw_lat? and se_lat?
    self.center_lon = nw_lon / 2 + se_lon / 2 if nw_lon? and se_lon?
  end

  def center_point_as_array
    return [self.center_lat, self.center_lon]
  end

  def nw
    [nw_lat, nw_lon]
  end

  def se
    [se_lat, se_lon]
  end

  def number_of_points
    (((nw_lat.round(2) - se_lat.round(2)) / GeoRegionSplitter.increment) * ((nw_lon.round(2) - se_lon.round(2)) / GeoRegionSplitter.increment)).abs
  end
end
