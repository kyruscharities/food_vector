class AnalysisGeoRegionScore < ActiveRecord::Base
  belongs_to :geo_region
  belongs_to :analysis

  validates_presence_of :geo_region
  validates_presence_of :analysis

  def calculate_risk_score
    AnalysisWorker::GeoRegionRiskScoreCalculatorWorker.perform_async self.id
  end
end
