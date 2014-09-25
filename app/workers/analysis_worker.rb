class AnalysisWorker
  include Sidekiq::Worker

  def perform(analysis_id, nw_lat, nw_long, se_lat, se_long, resolution)
    analysis = Analysis.find(analysis_id)

    # TODO: run in parallel?
    regions = GeoRegionSplitter.split(nw_lat, nw_long, se_lat, se_long, resolution)
    regions.each do |region|
      # TODO: actually calculate risk score
      risk_score = 0.0

      transaction do
        region.analysis = analysis
        region.save!

        AnalyzedGeoBlock.create!(
          analysis: analysis,
          geo_region: region,
          risk_score: risk_score
        )
      end
    end
  end
end
