module GeoRegionSplitter
  # Returns a list of 0-n evenly-sized square GeoRegions contained within
  # the lat/lon pairs of the analysis.
  def self.split(region, max_boxes)
    lat_increment = (region.se_lat - region.nw_lat).abs / Math.sqrt(max_boxes)
    lon_increment = (region.se_lon - region.nw_lon).abs / Math.sqrt(max_boxes)

    lats = Range.new(region.se_lat, region.nw_lat, true).step(lat_increment).to_a
    longs = Range.new(region.nw_lon, region.se_lon, true).step(lon_increment).to_a

    lats.product(longs).map do |lat, long|
      GeoRegion.new nw_lat: lat,
                    nw_lon: long,
                    se_lat: lat + lat_increment,
                    se_lon: long + lon_increment
    end
  end
end
