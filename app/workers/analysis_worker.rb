module AnalysisWorker
  class GeoRegionRiskScoreCalculatorWorker
    include Sidekiq::Worker

    def perform(geo_region_id_for_analysis)
      region = GeoRegion.find geo_region_id_for_analysis
      Rails.logger.info "Beginning analysis ##{region.analysis.id} region ##{region.id}"

      region.risk_score = rand(0..10) * rand(0..10)
      region.save!
    end
  end
end
