class AnalyzedGeoBlock < ActiveRecord::Base
  has_many :geo_region
  validates_presence_of :geo_region

  validates_presence_of :risk_score

  has_many :geographic_data_points
end
