module AnalysisWorker
  class GeoRegionRiskScoreCalculatorWorker
    include Sidekiq::Worker

    def perform(analysis_geo_region_score_id_for_analysis)
      region = AnalysisGeoRegionScore.find analysis_geo_region_score_id_for_analysis
      Rails.logger.info "Beginning analysis ##{region.analysis.id} region ##{region.geo_region.id}"

      # region.risk_score = rand(0..10) * rand(0..10)
      closest_sources = ClosestFoodSourceLocator.new region.analysis.food_sources_near_the_region

      puts "income_data: #{region.geo_region.income_data}"

      #nearest_healthy = closest_sources.nearest_healthy_source region.geo_region
      #nearest_unhealthy = closest_sources.nearest_unhealthy_source region.geo_region

      distances = closest_sources.miles_to_nearest_sources region.geo_region
      distance_to_healthy = distances[0]
      distance_to_unhealthy = distances[1]

      # region.risk_score = (region.geo_region.income_data['poverty_rate'].to_f * 100) + (((distance_to_healthy - distance_to_unhealthy) / [distance_to_healthy, distance_to_unhealthy].max) * 50)

      # region.risk_score = scorer.usda_approximate_risk_score region.geo_region.income_data['poverty_rate'], distance_to_healthy, distance_to_unhealthy
      # region.risk_score = scorer.simple_risk_score region.geo_region.income_data['poverty_rate'], distance_to_healthy, distance_to_unhealthy
      # region.risk_score = scorer.weighted_risk_score region.geo_region.income_data['poverty_rate'], distance_to_healthy, distance_to_unhealthy
      region.risk_score = RiskScore.game_theory_risk_score region.geo_region.income_data['poverty_level']['individuals_below_poverty_line'], distance_to_healthy, distance_to_unhealthy

      # region.risk_score = scorer.game_theory_risk_score_with_income_tiers region.geo_region.income_data['income_tiers'], distance_to_healthy, distance_to_unhealthy

      region.save!
    end
  end

  class GeoRegionEnsureIncomeDataWorker
    include Sidekiq::Worker

    def perform(analysis_geo_region_score_id_for_analysis)
      analysis_geo_region = AnalysisGeoRegionScore.find analysis_geo_region_score_id_for_analysis
      geo_region = analysis_geo_region.geo_region

      unless geo_region.income_data
        income_data = {
            'poverty_level' => Census.getIncomeForCoordinate(geo_region.center_lat, geo_region.center_lon),
            # 'income_tiers' => Census.get_households_by_income_tier(geo_region.center_lat, geo_region.center_lon)
        }
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
      GeoRegionSplitter.split(analysis)
    end
  end

  class SplitRegionAndStartAnalysis
    include Sidekiq::Worker

    def perform(analysis_id, se_lat, nw_lat, nw_lon, se_lon, increment)
      analysis = Analysis.find analysis_id

      longs = Range.new(nw_lon, se_lon, false).step(increment).to_a

      longs.each do |long|
        gr = GeoRegion.find_or_create_by! nw_lat: se_lat + increment,
                                          nw_lon: long,
                                          se_lat: se_lat,
                                          se_lon: long + increment
        agrs = AnalysisGeoRegionScore.create!(geo_region: gr, analysis: analysis)
        analysis.analysis_geo_region_scores.append agrs
        agrs.ensure_income_data
      end
      nil
    end
  end

  class LocateFoodSourcesForGeoRegion
    include Sidekiq::Worker

    def perform(analysis_id)
      Vendors.get_food_sources_by_region Analysis.find(analysis_id)
    end
  end
end
