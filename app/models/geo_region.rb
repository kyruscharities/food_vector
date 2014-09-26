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

  def calculate_center_point
    self.center_lat = nw_lat - ((nw_lat - se_lat) / 2)
    self.center_lon = nw_lon - ((nw_lon - se_lon) / 2)
  end

  def center_point
    {
        lat: center_lat,
        lon: center_lon
    }
  end

  def nw
    [nw_lat, nw_lon]
  end

  def se
    [se_lat, se_lon]
  end
end
