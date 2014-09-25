module GeoRegionSplitter
  # Returns a list of 0-n evenly-sized square GeoRegions contained within
  # the lat/lon pairs of the analysis.
  def self.split(region, resolution_mi)
    increment = 0.011363636 * resolution_mi

    lats = Range.new(region.se_lat, region.nw_lat, true).step(increment).to_a
    longs = Range.new(region.nw_lon, region.se_lon, true).step(increment).to_a

    lats.product(longs).map do |lat, long|
      GeoRegion.new(nw_lat: lat,
                    nw_lon: long,
                    se_lat: lat + increment,
                    se_lon: long + increment)
    end
  end
end
