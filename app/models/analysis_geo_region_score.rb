class AnalysisGeoRegionScore < ActiveRecord::Base
  belongs_to :geo_region
  belongs_to :analysis

  validates_presence_of :geo_region
  validates_presence_of :analysis

  def as_json(options = {})
    options.merge! include: :geo_region
    super(options)
  end

  def calculate_risk_score
    AnalysisWorker::GeoRegionRiskScoreCalculatorWorker.perform_async self.id
  end

  def ensure_income_data
    AnalysisWorker::GeoRegionEnsureIncomeDataWorker.perform_async self.id
  end
end
