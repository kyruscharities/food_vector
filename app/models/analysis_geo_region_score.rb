class AnalysisGeoRegionScore < ActiveRecord::Base
  belongs_to :geo_region
  belongs_to :analysis

  validates_presence_of :geo_region
  validates_presence_of :analysis

  def as_json(options = {})
    super(options.merge! include: :geo_region)
  end

  def calculate_risk_score
    # do this inline right now because we don't really need a second
    # job to calculate this - it's only called from within the
    # "ensure census data" worker
    AnalysisWorker::GeoRegionRiskScoreCalculatorWorker.new.perform self.id
  end

  def ensure_income_data
    AnalysisWorker::GeoRegionEnsureIncomeDataWorker.perform_async self.id
  end
end
