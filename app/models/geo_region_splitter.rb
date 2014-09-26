module GeoRegionSplitter
  # Returns a list of 0-n evenly-sized square GeoRegions contained within
  # the lat/lon pairs of the analysis.
  def self.split(region, resolution_mi)
    lat_increment = (region.se_lat - region.nw_lat).abs / 30
    lon_increment = (region.se_lon - region.nw_lon).abs / 30
    # increment = 0.011363636 * resolution_mi

    lats = Range.new(region.se_lat, region.nw_lat, true).step(lat_increment).to_a
    longs = Range.new(region.nw_lon, region.se_lon, true).step(lon_increment).to_a

    lats.product(longs).map do |lat, long|
      GeoRegion.new(nw_lat: lat,
                    nw_lon: long,
                    se_lat: lat + lat_increment,
                    se_lon: long + lon_increment)
    end
  end
end