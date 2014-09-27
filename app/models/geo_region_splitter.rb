module GeoRegionSplitter
  INCREMENT = 0.002

  def self.split(analysis)
    region = analysis.geo_region
    rounded = [region.nw_lat, region.nw_lon, region.se_lat, region.se_lon]
      .map { |x| x.to_f.round(2) }

    nw_lat, nw_lon, se_lat, se_lon = rounded
    lats = Range.new(se_lat, nw_lat, false).step(INCREMENT).to_a
    longs = Range.new(nw_lon, se_lon, false).step(INCREMENT).to_a

    lats.product(longs).map do |lat, long|
      gr = GeoRegion.find_or_create_by! nw_lat: lat,
                    nw_lon: long,
                    se_lat: lat + INCREMENT,
                    se_lon: long + INCREMENT
      analysis.analysis_geo_region_scores.append AnalysisGeoRegionScore.create!(geo_region: gr, analysis: analysis)
    end
    nil
  end
end
