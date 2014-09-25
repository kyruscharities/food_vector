class AnalyzedGeoBlock < ActiveRecord::Base
  belongs_to :analysis

  has_one :geo_region
  validates_presence_of :geo_region

  validates_presence_of :risk_score

  has_many :geographic_data_points

  def as_json(options = {})
    options.merge! include: :geo_region
    super(options)
  end
end

