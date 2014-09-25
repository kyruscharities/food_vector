class AnalysisWorker
  include Sidekiq::Worker

  def perform(analysis_id)
    analysis = Analysis.find(analysis_id)

    # TODO: run in parallel?
    regions = GeoRegionSplitter.split(analysis.geo_region, analysis.resolution_mi)
    regions.each_with_index do |region, index|
      # TODO: actually calculate risk score
      risk_score = index * rand(0..10)

      AnalyzedGeoBlock.transaction do
        result = AnalyzedGeoBlock.new(
          analysis: analysis,
          geo_region: region,
          risk_score: risk_score
        )

        region.analysis = analysis
        region.analyzed_geo_block = result
        region.save!

        analysis.update! analyzed_at: Time.now
      end
    end
  end
end
