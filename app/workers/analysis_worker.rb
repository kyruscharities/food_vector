module AnalysisWorker
  class GeoRegionRiskScoreCalculatorWorker
    include Sidekiq::Worker

    def perform(analysis_geo_region_score_id_for_analysis)
      region = AnalysisGeoRegionScore.find analysis_geo_region_score_id_for_analysis
      Rails.logger.info "Beginning analysis ##{region.analysis.id} region ##{region.geo_region.id}"

      region.risk_score = rand(0..10) * rand(0..10)

      region.save!
    end
  end
end
