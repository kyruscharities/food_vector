module GeoRegionSplitter
  RESOLUTIONS = [0.06, 0.05, 0.04, 0.03, 0.02, 0.01]

  # Returns a list of 0-n evenly-sized square GeoRegions contained within
  # the pairs of lat/longs.
  #
  # Resolution is presumed to be an integer value in the range of 0-5, where
  # 5 specifies maximum resolution, and 0 specifies minimum resolution.
  def self.split(ne_lat, ne_long, se_lat, se_long, resolution)
    increment = RESOLUTIONS[resolution]

    lats = Range.new(ne_lat, se_lat, true).step(increment).to_a
    longs = Range.new(ne_long, se_long, true).step(increment).to_a

    lats.product(longs).map do |lat, long|
      GeoRegion.new(nw_lat: lat,
                    nw_lon: long,
                    se_lat: lat + increment,
                    se_lon: long + increment)
    end
  end
end
