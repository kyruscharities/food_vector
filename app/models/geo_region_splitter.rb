module GeoRegionSplitter

  def self.increment
    0.002
  end

  def self.split(analysis)
    region = analysis.geo_region
    rounded = [region.nw_lat, region.nw_lon, region.se_lat, region.se_lon]
    .map { |x| x.to_f.round(2) }

    nw_lat, nw_lon, se_lat, se_lon = rounded
    lats = Range.new(se_lat, nw_lat, false).step(INCREMENT).to_a.each do |lat|
      AnalysisWorker::SplitRegionAndStartAnalysis.perform_async(analysis.id, lat, lat + self.increment, nw_lon, se_lon, self.increment)
    end
  end
end
