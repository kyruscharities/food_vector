module AnalysisWorker
  class GeoRegionRiskScoreCalculatorWorker
    include Sidekiq::Worker

    def perform(analysis_geo_region_score_id_for_analysis)
      region = AnalysisGeoRegionScore.find analysis_geo_region_score_id_for_analysis
      Rails.logger.info "Beginning analysis ##{region.analysis.id} region ##{region.geo_region.id}"

      # region.risk_score = rand(0..10) * rand(0..10)
      closest_sources = ClosestSources.new region.analysis.food_sources_near_the_region

      puts "income_data: #{region.geo_region.income_data}"

      nearest_healthy = closest_sources.nearest_healthy_source region.geo_region
      nearest_unhealthy = closest_sources.nearest_unhealthy_source region.geo_region

      distance_to_healthy = closest_sources.distance_between region.geo_region.center_lat, region.geo_region.center_lon, nearest_healthy.lat, nearest_healthy.lon
      distance_to_unhealthy = closest_sources.distance_between region.geo_region.center_lat, region.geo_region.center_lon, nearest_unhealthy.lat, nearest_unhealthy.lon

      region.risk_score = (region.geo_region.income_data['poverty_rate'].to_f * 100) + (((distance_to_healthy - distance_to_unhealthy) / [distance_to_healthy, distance_to_unhealthy].max) * 50)

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

  class AnalysisGenerateRiskScores
    include Sidekiq::Worker

    def perform(analysis_id)
      analysis = Analysis.find analysis_id
      analysis.clear_analysis_results!

      # identify and store all the regions
      GeoRegionSplitter.split(analysis.geo_region).each { |r| analysis.analysis_geo_region_scores.append AnalysisGeoRegionScore.create!(geo_region: r, analysis: analysis) }

      # get income data and calculate all the risk scores
      analysis.analysis_geo_region_scores.each { |r| r.ensure_income_data }
    end
  end

  class LocateFoodSourcesForGeoRegion
    include Sidekiq::Worker

    def perform(analysis_id)
      Vendors.get_food_sources_by_region Analysis.find(analysis_id)
    end
  end
end
