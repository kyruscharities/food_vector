module AnalysisWorker
  class GeoRegionRiskScoreCalculatorWorker
    include Sidekiq::Worker

    def perform(analysis_geo_region_score_id_for_analysis)
      region = AnalysisGeoRegionScore.find analysis_geo_region_score_id_for_analysis
      Rails.logger.info "Beginning analysis ##{region.analysis.id} region ##{region.geo_region.id}"

      # region.risk_score = rand(0..10) * rand(0..10)
      puts "income_data: #{region.geo_region.income_data}"
      region.risk_score = region.geo_region.income_data['poverty_rate'].to_f * 100

      region.save!
    end
  end

  class GeoRegionEnsureIncomeDataWorker
    include Sidekiq::Worker

    def perform(analysis_geo_region_score_id_for_analysis)
      analysis_geo_region = AnalysisGeoRegionScore.find analysis_geo_region_score_id_for_analysis
      geo_region = analysis_geo_region.geo_region

      unless geo_region.income_data
        income_data = Census.getIncomeForCoordinate(geo_region.center_lat, geo_region.center_lon)
        geo_region.update! income_data: income_data, census_tract_id: income_data[:identifier]
      end

      analysis_geo_region.calculate_risk_score
    end
  end
end
